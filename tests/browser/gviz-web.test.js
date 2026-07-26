const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');

const application = process.argv[2];
if (!application) throw new Error('usage: node gviz-web.test.js APP_JS');

class Element {
  constructor() {
    this.dataset = {};
    this.listeners = {};
    this.values = {};
    this.style = {
      setProperty: (name, value) => { this.values[name] = value; }
    };
    this.classes = new Set();
    this.classList = {
      add: (name) => this.classes.add(name),
      remove: (name) => this.classes.delete(name),
      contains: (name) => this.classes.has(name),
      toggle: (name, force) => force
        ? this.classes.add(name)
        : this.classes.delete(name)
    };
    this.children = [];
    this.hidden = false;
    this.disabled = false;
    this.textContent = '';
    this.value = '';
    this.selectionStart = 0;
    this.selectionEnd = 0;
    this.scrollTop = 0;
    this.captured = new Set();
  }

  addEventListener(name, callback) { this.listeners[name] = callback; }
  setAttribute(name, value) { this[name] = value; }
  removeAttribute(name) { delete this[name]; }
  focus() { this.focused = true; }
  click() { this.clicked = true; }
  append(child) { this.children.push(child); }
  setPointerCapture(id) { this.captured.add(id); }
  releasePointerCapture(id) { this.captured.delete(id); }
  hasPointerCapture(id) { return this.captured.has(id); }
  getBoundingClientRect() {
    return {left: 0, top: 0, width: 800, height: 600};
  }
  replaceChildren(...children) {
    this.children = children.length === 1 && children[0].fragment
      ? children[0].children
      : children;
  }
  contains(item) {
    return item === this || this.children.some((child) => {
      return child === item || child.contains?.(item);
    });
  }
  closest(selector) {
    if (selector === '.node, .edge'
      && (this.classes.has('node') || this.classes.has('edge'))) return this;
    return this.parent?.closest?.(selector);
  }
  matches(selector) {
    return selector.split(',').some((name) => {
      return name.trim().toLowerCase() === this.localName?.toLowerCase();
    });
  }
  querySelector(name) {
    return name === 'svg'
      ? this.children.find((item) => item.localName === 'svg')
      : null;
  }
  setSelectionRange(start, end) {
    this.selectionStart = start;
    this.selectionEnd = end;
  }
  setRangeText(replacement, start, end) {
    this.value = this.value.slice(0, start) + replacement
      + this.value.slice(end);
    this.setSelectionRange(start + replacement.length, start + replacement.length);
  }
  async requestFullscreen() {
    document.fullscreenElement = this;
    documentListeners.fullscreenchange?.({});
  }
}

function group(kind, identity) {
  const item = new Element();
  const title = {localName: 'title', textContent: identity, attributes: []};
  const shape = new Element();
  shape.localName = kind === 'node' ? 'ellipse' : 'path';
  shape.attributes = [];
  item.localName = 'g';
  item.attributes = [];
  item.classList.add(kind);
  item.children = [title, shape];
  title.parent = item;
  shape.parent = item;
  item.querySelector = (selector) => {
    return selector === ':scope > title' ? title : null;
  };
  return item;
}

function svgDocument(source) {
  const title = {localName: 'title', id: '', textContent: source, attributes: []};
  const groups = [
    group('node', 'Alpha'),
    group('node', 'Beta'),
    group('node', 'Gamma'),
    group('edge', 'Alpha->Beta'),
    group('edge', 'Beta->Gamma')
  ];
  const svg = new Element();
  svg.localName = 'svg';
  svg.namespaceURI = 'http://www.w3.org/2000/svg';
  svg.attributes = [];
  svg.viewBox = {baseVal: {width: 200, height: 100}};
  svg.renderSource = source;
  svg.children = groups;
  svg.groups = groups;
  for (const item of groups) item.parent = svg;
  svg.querySelector = (selector) => {
    return selector === ':scope > title' ? title : null;
  };
  svg.querySelectorAll = (selector) => {
    if (selector === '.node, .edge') return groups;
    if (selector === '*') {
      return [title, ...groups, ...groups.flatMap((item) => item.children)];
    }
    return [];
  };
  return {documentElement: svg, querySelector: () => null};
}

const selectors = [
  '#dot', '#line-numbers', '#template', '#render', '#error', '#preview',
  '#zoom-out', '#zoom-in', '#fullscreen-zoom-out', '#fullscreen-zoom-in',
  '#svg-source', '#toggle-svg-source', '#copy-svg', '#fullscreen-svg',
  '#preview-shell', '#render-status', '#source-status', '#reset-view',
  '#browse-dot', '#load-dot', '#save-dot',
  '#browse-svg', '#load-svg', '#save-svg', '#fit',
  '#auto-render', '#help',
  '#help-panel', '#close-help', '#file-browser-modal',
  '#file-browser-title', '#file-browser-tree', '#close-file-browser',
  '#clay-error-modal',
  '#clay-error-message', '#close-clay-error', '#workspace', '#splitter',
  '#inspector',
  '#selection-kind', '#selection-id', '#clear-selection',
  '#delete-selection', '#attribute-form', '#shape-control', '#fill-control',
  '#edge-controls',
  '#attr-label', '#attr-shape', '#attr-color', '#attr-fillcolor',
  '#attr-style', '#attr-penwidth', '#attr-arrowhead', '#attr-arrowtail',
  '#attr-arrowsize', '#attr-dir', '#attr-minlen', '#attr-weight',
  '#attr-fontname', '#attr-fontsize', '#attr-fontcolor',
  '#attr-change-all', '#attr-use-default',
  '#new-node-name', '#new-node-category', '#new-node-shape', '#add-node',
  '#draw-edge'
];
const elements = Object.fromEntries(selectors.map((name) => {
  return [name, new Element()];
}));
elements['#auto-render'].checked = true;
elements['#file-browser-modal'].hidden = true;
elements['#clay-error-modal'].hidden = true;

const requests = [];
const saved = new Map();
const documentListeners = {};
const windowListeners = {};
const prompts = [];
const confirmations = [];
const confirmationAnswers = [];
const clipboardWrites = [];
saved.set('graph-viz.session.v1', JSON.stringify({
  version: 1,
  source: 'digraph saved { Alpha -> Beta }',
  paneWidth: 62,
  view: {scale: 2, x: 20, y: 30},
  preferences: {autoRender: false}
}));

global.document = {
  fullscreenElement: null,
  querySelector: (selector) => elements[selector],
  importNode: (node) => node,
  createDocumentFragment: () => ({
    fragment: true,
    children: [],
    append(item) { this.children.push(item); }
  }),
  createElement: () => new Element(),
  addEventListener: (name, callback) => { documentListeners[name] = callback; },
  exitFullscreen: async () => {
    global.document.fullscreenElement = null;
    documentListeners.fullscreenchange?.({});
  }
};
global.DOMParser = class {
  parseFromString(source) { return svgDocument(source); }
};
global.matchMedia = () => ({matches: false});
Object.defineProperty(global, 'navigator', {
  configurable: true,
  value: {
    clipboard: {
      writeText: async (source) => { clipboardWrites.push(source); }
    }
  }
});
global.getComputedStyle = (element) => ({
  lineHeight: '22px',
  paddingTop: '16px',
  getPropertyValue: () => element.values['--editor-width'] || '44%'
});
global.requestAnimationFrame = (callback) => callback();
URL.createObjectURL = () => 'blob:test';
URL.revokeObjectURL = () => {};
global.localStorage = {
  getItem: (key) => saved.get(key) ?? null,
  setItem: (key, value) => saved.set(key, value)
};
global.window = {
  location: {href: 'http://localhost:18080/apps/graph-viz/'},
  addEventListener: (name, callback) => { windowListeners[name] = callback; },
  prompt: () => prompts.shift(),
  confirm: (message) => {
    confirmations.push(message);
    return confirmationAnswers.shift();
  }
};
global.fetch = (url, options) => new Promise((resolve, reject) => {
  requests.push({url, options, resolve, reject});
});

function response(ok, body, status = ok ? 200 : 422) {
  return {
    ok,
    status,
    headers: {get: () => ok ? 'image/svg+xml' : 'application/json'},
    text: async () => body
  };
}

const tick = () => new Promise((resolve) => setTimeout(resolve, 0));
async function resolveBrowse(path, file, children) {
  const request = requests.at(-1);
  assert.equal(request.options.headers['x-graph-viz-path'],
    path || undefined);
  request.resolve(response(true, JSON.stringify({file, children})));
  await tick();
}
function descendants(element) {
  return element.children.flatMap((child) => {
    return [child, ...descendants(child)];
  });
}
vm.runInThisContext(fs.readFileSync(application, 'utf8'), {filename: application});

(async () => {
  assert.equal(elements['#dot'].value, 'digraph saved { Alpha -> Beta }');
  assert.equal(elements['#workspace'].values['--editor-width'], '62%');
  assert.equal(elements['#auto-render'].checked, false);
  assert.equal(elements['#new-node-category'].value, 'basic-shapes');
  assert.equal(elements['#new-node-shape'].value, 'ellipse');
  assert.equal(elements['#new-node-shape'].children.length, 16);
  elements['#new-node-category'].value = 'dna-construction-symbols';
  elements['#new-node-category'].listeners.change({});
  assert.equal(elements['#new-node-shape'].value, 'primersite');
  assert.equal(elements['#new-node-shape'].children.length, 11);
  assert(elements['#new-node-shape'].children.some((option) => {
    return option.value === 'lpromoter';
  }));
  for (const [category, first, count] of [
    ['basic-symbols', 'note', 7],
    ['special-shapes', 'doublecircle', 10],
    ['gene-expression-symbols', 'promoter', 9],
    ['other-shapes', 'polygon', 6]
  ]) {
    elements['#new-node-category'].value = category;
    elements['#new-node-category'].listeners.change({});
    assert.equal(elements['#new-node-shape'].value, first);
    assert.equal(elements['#new-node-shape'].children.length, count);
  }
  elements['#new-node-category'].value = 'basic-shapes';
  elements['#new-node-category'].listeners.change({});

  requests[0].resolve(response(true, '<svg id="initial"/>'));
  await tick();
  await tick();
  assert(elements['#preview'].children[0], elements['#error'].textContent);
  assert.equal(elements['#preview'].children[0].renderSource,
    '<svg id="initial"/>');
  assert.equal(elements['#copy-svg'].disabled, false);
  assert.equal(elements['#fullscreen-svg'].disabled, false);
  assert.equal(elements['#fullscreen-svg'].hidden, false);
  await elements['#copy-svg'].listeners.click({});
  assert.equal(clipboardWrites.at(-1), '<svg id="initial"/>');
  assert.equal(elements['#source-status'].textContent, 'SVG copied');
  assert.equal(elements['#preview'].children[0].style.transform,
    'translate(20px, 30px) scale(2)');
  await elements['#fullscreen-svg'].listeners.click({});
  assert.equal(document.fullscreenElement, elements['#preview-shell']);
  assert(elements['#preview-shell'].classes.has('is-fullscreen'));
  assert.equal(elements['#fullscreen-svg']['aria-pressed'], 'true');
  assert.equal(elements['#fullscreen-zoom-out'].disabled, false);
  assert.equal(elements['#fullscreen-zoom-in'].disabled, false);
  const beforeFullscreenZoom =
    elements['#preview'].children[0].style.transform;
  elements['#fullscreen-zoom-out'].listeners.click({});
  assert.notEqual(
    elements['#preview'].children[0].style.transform,
    beforeFullscreenZoom
  );
  const afterFullscreenZoomOut =
    elements['#preview'].children[0].style.transform;
  elements['#fullscreen-zoom-in'].listeners.click({});
  assert.notEqual(
    elements['#preview'].children[0].style.transform,
    afterFullscreenZoomOut
  );
  assert.equal(
    elements['#fullscreen-svg'].title,
    'Return SVG to preview panel'
  );
  await elements['#fullscreen-svg'].listeners.click({});
  assert.equal(document.fullscreenElement, null);
  assert(!elements['#preview-shell'].classes.has('is-fullscreen'));
  assert.equal(elements['#fullscreen-svg']['aria-pressed'], 'false');
  elements['#toggle-svg-source'].listeners.click({});
  assert.equal(elements['#preview'].hidden, true);
  assert.equal(elements['#svg-source'].hidden, false);
  assert.equal(elements['#svg-source'].textContent, '<svg id="initial"/>');
  assert.equal(elements['#toggle-svg-source'].textContent, 'View rendered');
  assert.equal(elements['#toggle-svg-source']['aria-pressed'], 'true');
  assert.equal(elements['#fullscreen-svg'].hidden, true);
  await elements['#copy-svg'].listeners.click({});
  assert.equal(clipboardWrites.at(-1), '<svg id="initial"/>');
  elements['#toggle-svg-source'].listeners.click({});
  assert.equal(elements['#preview'].hidden, false);
  assert.equal(elements['#svg-source'].hidden, true);
  assert.equal(elements['#toggle-svg-source'].textContent, 'View source');
  assert.equal(elements['#fullscreen-svg'].hidden, false);

  elements['#template'].value = 'strict-digraph';
  elements['#template'].listeners.change({});
  assert(elements['#dot'].value.startsWith('strict digraph unique_edges'));
  assert(elements['#dot'].value.includes('last wins'));

  const dot = elements['#dot'];
  dot.value = 'digraph old { Alpha -> Beta }';
  elements['#render'].listeners.click({});
  const oldRequest = requests.at(-1);
  dot.value = 'digraph new { Alpha -> Beta }';
  elements['#render'].listeners.click({});
  const newRequest = requests.at(-1);
  newRequest.resolve(response(true, '<svg id="new"/>'));
  await tick();
  await tick();
  oldRequest.resolve(response(true, '<svg id="old"/>'));
  await tick();
  await tick();
  assert.equal(elements['#preview'].children[0].renderSource,
    '<svg id="new"/>');
  elements['#toggle-svg-source'].listeners.click({});
  assert.equal(elements['#svg-source'].textContent, '<svg id="new"/>');
  elements['#toggle-svg-source'].listeners.click({});

  const retained = elements['#preview'].children[0];
  elements['#render'].listeners.click({});
  requests.at(-1).resolve(response(false, JSON.stringify({
    kind: 'parse', line: 1, column: 9, message: 'syntax error'
  })));
  await tick();
  await tick();
  assert.equal(elements['#preview'].children[0], retained);
  assert.equal(elements['#preview-shell'].dataset.state, 'ready');
  assert(elements['#error'].textContent.includes('Line 1, column 9'));

  let svg = elements['#preview'].children[0];
  const beforeZoom = svg.style.transform;
  elements['#preview'].listeners.wheel({
    clientX: 400, clientY: 300, deltaY: -100, preventDefault() {}
  });
  assert.notEqual(svg.style.transform, beforeZoom);
  const beforePan = svg.style.transform;
  elements['#preview'].listeners.pointerdown({
    target: elements['#preview'], button: 0, pointerId: 7,
    clientX: 100, clientY: 100, preventDefault() {}
  });
  elements['#preview'].listeners.pointermove({
    pointerId: 7, clientX: 130, clientY: 120
  });
  elements['#preview'].listeners.pointerup({pointerId: 7});
  assert.notEqual(svg.style.transform, beforePan);

  dot.value = [
    'digraph shapes {',
    '  Alpha [shape=doublecircle]',
    '  Alpha -> Beta',
    '}'
  ].join('\n');
  elements['#preview'].listeners.click({target: svg.groups[0]});
  assert.equal(elements['#attr-shape'].value, 'doublecircle');
  assert.equal(
    elements['#attr-shape'].dataset.sourceShape,
    'doublecircle'
  );
  elements['#attr-style'].value = 'dashed';
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  assert(dot.value.includes('shape=doublecircle'));
  assert(dot.value.includes('style=\"dashed\"'));
  requests.at(-1).resolve(response(true, '<svg id="styled"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  dot.value = [
    'digraph bulk_nodes {',
    '  Alpha [shape=box]',
    '  Alpha -> Beta',
    '}'
  ].join('\n');
  elements['#preview'].listeners.click({target: svg.groups[0]});
  assert.equal(elements['#attr-change-all'].checked, false);
  assert.equal(elements['#attr-use-default'].checked, false);
  elements['#attr-label'].value = '';
  elements['#attr-shape'].value = 'diamond';
  elements['#attr-color'].value = 'purple';
  elements['#attr-fillcolor'].value = 'yellow';
  elements['#attr-style'].value = 'bold';
  elements['#attr-change-all'].checked = true;
  elements['#attr-use-default'].checked = true;
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  for (const name of ['Alpha', 'Beta']) {
    const nodeLine = dot.value.split('\n').find((line) => {
      return line.trimStart().startsWith(`${name} [`);
    });
    assert(nodeLine, name);
    assert(nodeLine.includes('shape=diamond'), nodeLine);
    assert(nodeLine.includes('color=\"purple\"'), nodeLine);
    assert(nodeLine.includes('fillcolor=\"yellow\"'), nodeLine);
    assert(nodeLine.includes('style=\"bold,filled\"'), nodeLine);
  }
  const nodeDefault = dot.value.split('\n').find((line) => {
    return line.trimStart().startsWith('node [');
  });
  assert(nodeDefault);
  assert(nodeDefault.includes('shape=diamond'));
  assert.equal(elements['#new-node-shape'].value, 'diamond');
  requests.at(-1).resolve(response(true, '<svg id="bulk-nodes"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  elements['#new-node-name'].value = 'Gamma';
  elements['#add-node'].listeners.click({});
  assert(dot.value.split('\n').some((line) => line.trim() === 'Gamma'));
  requests.at(-1).resolve(response(true, '<svg id="default-node"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  dot.value = [
    'digraph bulk_edges {',
    '  Alpha -> Beta',
    '  Beta -> Gamma',
    '}'
  ].join('\n');
  elements['#preview'].listeners.click({target: svg.groups[3]});
  assert.equal(elements['#attr-change-all'].checked, false);
  assert.equal(elements['#attr-use-default'].checked, false);
  elements['#attr-label'].value = '';
  elements['#attr-color'].value = 'blue';
  elements['#attr-style'].value = 'dotted';
  elements['#attr-penwidth'].value = '2';
  elements['#attr-change-all'].checked = true;
  elements['#attr-use-default'].checked = true;
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  const edgeLines = dot.value.split('\n').filter((line) => {
    return line.includes(' -> ');
  });
  assert.equal(edgeLines.length, 2);
  for (const line of edgeLines) {
    assert(line.includes('color=\"blue\"'), line);
    assert(line.includes('style=\"dotted\"'), line);
    assert(line.includes('penwidth=2'), line);
  }
  const edgeDefault = dot.value.split('\n').find((line) => {
    return line.trimStart().startsWith('edge [');
  });
  assert(edgeDefault);
  assert(edgeDefault.includes('color=\"blue\"'));
  requests.at(-1).resolve(response(true, '<svg id="bulk-edges"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  elements['#preview'].listeners.click({target: svg.groups[0]});
  elements['#preview'].listeners.click({
    target: svg.groups[2], shiftKey: true
  });
  elements['#draw-edge'].listeners.click({});
  assert(dot.value.split('\n').some((line) => {
    return line.trim() === 'Alpha -> Gamma';
  }));
  requests.at(-1).resolve(response(true, '<svg id="default-edge"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  dot.value = 'digraph chain { Alpha -> Beta -> Gamma }';
  elements['#preview'].listeners.click({target: svg.groups[4]});
  assert.equal(elements['#selection-kind'].textContent, 'Edge');
  assert.equal(elements['#selection-id'].textContent, 'Beta->Gamma');
  assert.equal(elements['#attribute-form'].hidden, false);
  assert.equal(elements['#shape-control'].hidden, true);
  assert.equal(elements['#fill-control'].hidden, true);
  assert.equal(elements['#edge-controls'].hidden, false);
  elements['#attr-label'].value = 'next';
  elements['#attr-color'].value = 'blue';
  elements['#attr-style'].value = 'dashed';
  elements['#attr-penwidth'].value = '2';
  elements['#attr-arrowhead'].value = 'vee';
  elements['#attr-arrowtail'].value = 'dot';
  elements['#attr-arrowsize'].value = '1.5';
  elements['#attr-dir'].value = 'both';
  elements['#attr-minlen'].value = '2';
  elements['#attr-weight'].value = '3';
  elements['#attr-fontname'].value = 'Arial';
  elements['#attr-fontsize'].value = '12';
  elements['#attr-fontcolor'].value = 'green';
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  assert(dot.value.includes('Alpha -> Beta'));
  const selectedEdgeLine = dot.value.split('\n').find((line) => {
    return line.includes('Beta -> Gamma');
  });
  assert(selectedEdgeLine);
  assert(!dot.value.includes(
    'Alpha -> Beta [label=\"next\"'
  ));
  for (const attribute of [
    'label=\"next\"',
    'color=\"blue\"',
    'style=\"dashed\"',
    'penwidth=2',
    'arrowhead=vee',
    'arrowtail=dot',
    'arrowsize=1.5',
    'dir=both',
    'minlen=2',
    'weight=3',
    'fontname=\"Arial\"',
    'fontsize=12',
    'fontcolor=\"green\"'
  ]) {
    assert(selectedEdgeLine.includes(attribute), attribute);
  }
  requests.at(-1).resolve(response(true, '<svg id="edge-styled"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  elements['#preview'].listeners.click({target: svg.groups[0]});
  assert(svg.groups[0].classList.contains('is-selected'));
  assert.equal(elements['#selection-kind'].textContent, 'Node');
  assert.equal(elements['#selection-id'].textContent, 'Alpha');
  assert(dot.value.slice(dot.selectionStart, dot.selectionEnd).includes('Alpha'));

  elements['#preview'].listeners.click({
    target: svg.groups[1], shiftKey: true
  });
  assert(svg.groups[0].classList.contains('is-selected'));
  assert(svg.groups[1].classList.contains('is-selected'));
  assert.equal(elements['#selection-id'].textContent, 'Alpha -> Beta');

  elements['#preview'].listeners.click({
    target: svg.groups[2], shiftKey: true
  });
  assert(svg.groups[0].classList.contains('is-selected'));
  assert(!svg.groups[1].classList.contains('is-selected'));
  assert(svg.groups[2].classList.contains('is-selected'));
  assert.equal(elements['#selection-id'].textContent, 'Alpha -> Gamma');
  assert.equal(elements['#draw-edge'].disabled, false);

  dot.value = 'digraph persisted { Alpha -> Beta }';
  dot.listeners.input({});
  await new Promise((resolve) => setTimeout(resolve, 200));
  const session = JSON.parse(saved.get('graph-viz.session.v1'));
  assert.equal(session.source, dot.value);
  assert(Number.isFinite(session.view.scale));

  prompts.push('/examples/source');
  const saveDotRequest = elements['#save-dot'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/save');
  assert.equal(requests.at(-1).options.headers['x-graph-viz-path'],
    'examples/source');
  assert.equal(requests.at(-1).options.body, dot.value);
  confirmationAnswers.push(true);
  requests.at(-1).resolve(response(false, 'Clay file already exists', 409));
  await tick();
  assert(confirmations.at(-1).includes('DOT path "examples/source"'));
  assert.equal(requests.at(-1).options.headers['x-graph-viz-overwrite'],
    'true');
  requests.at(-1).resolve(response(true, 'saved'));
  await saveDotRequest;

  prompts.push('examples/output');
  const saveSvgRequest = elements['#save-svg'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/svg/save');
  assert.equal(requests.at(-1).options.headers['x-graph-viz-path'],
    'examples/output');
  const requestCount = requests.length;
  confirmationAnswers.push(false);
  requests.at(-1).resolve(response(false, 'Clay file already exists', 409));
  await saveSvgRequest;
  assert(confirmations.at(-1).includes('SVG path "examples/output"'));
  assert.equal(requests.length, requestCount);

  const browseDotRequest = elements['#browse-dot'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/browse');
  await resolveBrowse('', false, ['examples']);
  await resolveBrowse('examples', false, ['alpha', 'beta']);
  await resolveBrowse('examples/alpha', false, ['txt']);
  await resolveBrowse('examples/alpha/txt', true, []);
  await resolveBrowse('examples/beta', false, ['txt']);
  await resolveBrowse('examples/beta/txt', true, []);
  await browseDotRequest;
  assert.equal(elements['#file-browser-modal'].hidden, false);
  const dotFile = descendants(elements['#file-browser-tree']).find((item) => {
    return item.dataset?.path === 'examples/beta/txt';
  });
  assert(dotFile);
  assert.equal(dotFile.textContent, 'beta/txt');
  const browseLoadDot = dotFile.listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/load');
  assert.equal(requests.at(-1).options.headers['x-graph-viz-path'],
    'examples/beta/txt');
  requests.at(-1).resolve(response(true, 'digraph browsed { B -> C }'));
  await browseLoadDot;
  assert.equal(dot.value, 'digraph browsed { B -> C }');

  elements['#auto-render'].checked = true;
  const browseSvgRequest = elements['#browse-svg'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/svg/browse');
  await resolveBrowse('', false, ['examples']);
  await resolveBrowse('examples', false, ['preview']);
  await resolveBrowse('examples/preview', false, ['svg']);
  await resolveBrowse('examples/preview/svg', true, []);
  await browseSvgRequest;
  const svgFile = descendants(elements['#file-browser-tree']).find((item) => {
    return item.dataset?.path === 'examples/preview/svg';
  });
  assert(svgFile);
  assert.equal(svgFile.textContent, 'preview/svg');
  const browseLoadSvg = svgFile.listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/svg/load');
  requests.at(-1).resolve(response(true, '<svg id="browsed"/>'));
  await browseLoadSvg;
  assert.equal(elements['#preview'].children[0].renderSource,
    '<svg id="browsed"/>');
  assert.equal(elements['#auto-render'].checked, false);

  prompts.push('/examples/loaded');
  const loadDotRequest = elements['#load-dot'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/load');
  requests.at(-1).resolve(response(true, 'digraph loaded { A -> B }'));
  await loadDotRequest;
  assert.equal(dot.value, 'digraph loaded { A -> B }');

  elements['#auto-render'].checked = true;
  prompts.push('examples/loaded');
  const loadSvgRequest = elements['#load-svg'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/svg/load');
  requests.at(-1).resolve(response(true, '<svg id="loaded"/>'));
  await loadSvgRequest;
  assert.equal(elements['#preview'].children[0].renderSource,
    '<svg id="loaded"/>');
  assert.equal(elements['#auto-render'].checked, false);

  const failedBrowse = elements['#browse-dot'].listeners.click({});
  requests.at(-1).resolve(response(false, 'Clay browse failed'));
  await failedBrowse;
  assert.equal(elements['#file-browser-modal'].hidden, true);
  assert.equal(elements['#clay-error-modal'].hidden, false);
  elements['#close-clay-error'].listeners.click({});

  prompts.push('examples/missing');
  const failedLoad = elements['#load-dot'].listeners.click({});
  requests.at(-1).resolve(response(false, 'Clay file not found'));
  await failedLoad;
  assert.equal(elements['#clay-error-modal'].hidden, false);
  assert(elements['#clay-error-message'].textContent.includes(
    'Clay file not found'
  ));
  elements['#close-clay-error'].listeners.click({});
  assert.equal(elements['#clay-error-modal'].hidden, true);

  console.log('browser smoke: ok');
})().catch((cause) => {
  console.error(cause);
  process.exitCode = 1;
});
