const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');

const application = process.argv[2];
if (!application) throw new Error('usage: node gviz-web.test.js APP_JS');
const applicationSource = fs.readFileSync(application === '-' ? 0 : application,
  'utf8');

class Element {
  constructor(localName = 'div') {
    this.localName = localName;
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
    this.scrollTop = 0;
    this.captured = new Set();
  }

  addEventListener(name, callback) { this.listeners[name] = callback; }
  removeEventListener(name, callback) {
    if (this.listeners[name] === callback) delete this.listeners[name];
  }
  getAttribute(name) { return this[name] ?? null; }
  setAttribute(name, value) { this[name] = value; }
  removeAttribute(name) { delete this[name]; }
  focus() {
    this.focused = true;
    if (global.document) global.document.activeElement = this;
  }
  click() { this.clicked = true; }
  append(...children) {
    for (const child of children) {
      child.parent = this;
      this.children.push(child);
    }
  }
  after(...siblings) {
    if (!this.parent) return;
    const index = this.parent.children.indexOf(this);
    this.parent.children.splice(index + 1, 0, ...siblings);
    for (const sibling of siblings) sibling.parent = this.parent;
  }
  remove() {
    if (!this.parent) return;
    this.parent.children = this.parent.children.filter((item) => item !== this);
    this.parent = undefined;
  }
  get parentElement() { return this.parent; }
  setPointerCapture(id) { this.captured.add(id); }
  releasePointerCapture(id) { this.captured.delete(id); }
  hasPointerCapture(id) { return this.captured.has(id); }
  getBoundingClientRect() {
    return {
      left: 0, top: 0, right: 800, bottom: 600,
      width: 800, height: 600
    };
  }
  replaceChildren(...children) {
    this.children = children.length === 1 && children[0].fragment
      ? children[0].children
      : children;
    for (const child of this.children) child.parent = this;
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
  querySelector(selector) {
    return this.querySelectorAll(selector)[0] || null;
  }
  querySelectorAll(selector) {
    const all = descendants(this);
    if (selector === '[role="tab"]') {
      return all.filter((item) => item.role === 'tab');
    }
    if (selector === '[data-docs-tab]') {
      return all.filter((item) => item.dataset.docsTab);
    }
    if (selector === '.docs-explorer-panel') {
      return all.filter((item) => item.className === 'explorer-panel docs-explorer-panel');
    }
    if (selector === 'svg') {
      return all.filter((item) => item.localName === 'svg');
    }
    const view = selector.match(/^\[data-explorer-view="([^"]+)"\]$/);
    if (view) {
      return all.filter((item) => item.dataset.explorerView === view[1]);
    }
    const panelFrame = selector.match(/^#([^ ]+) iframe$/);
    if (panelFrame) {
      const panel = all.find((item) => item.id === panelFrame[1]);
      return panel ? descendants(panel).filter((item) => {
        return item.localName === 'iframe';
      }) : [];
    }
    return [];
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
  '#dot', '#editor-load-error', '#template', '#render', '#error', '#preview',
  '#zoom-out', '#zoom-in', '#fullscreen-zoom-out', '#fullscreen-zoom-in',
  '#svg-source', '#toggle-svg-source', '#copy-svg', '#fullscreen-svg',
  '#preview-shell', '#render-status', '#source-status', '#reset-view',
  '#browse-dot', '#load-dot', '#save-dot',
  '#browse-svg', '#load-svg', '#save-svg', '#fit',
  '#auto-render', '#theme', '#help',
  '#help-panel', '#editor-help-card', '#close-help',
  '#fallback-help-content', '#docs-help-content',
  '#workbench', '#explorer-pane', '#explorer-tabs', '#explorer-resizer',
  '#dot-files-tab', '#svg-files-tab',
  '#dot-files-panel', '#svg-files-panel',
  '#dot-files-tree', '#svg-files-tree',
  '#file-context-menu', '#file-context-open', '#file-context-delete',
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
const docsHelpLinks = [
  ['usr/users-guide', '/docs/d/graph-viz/usr/users-guide'],
  ['reference', '/docs/d/graph-viz/reference'],
  ['graph-noun', '/docs/d/graph-viz/graph-noun'],
  ['release-notes', '/docs/d/graph-viz/release-notes']
].map(([path, href]) => {
  const link = new Element();
  link.dataset.docPath = path;
  link.href = href;
  link.textContent = path === 'usr/users-guide' ? 'Users Guide' : path;
  return link;
});
elements['#auto-render'].checked = true;
elements['#help-panel'].hidden = true;
elements['#docs-help-content'].hidden = true;
elements['#file-context-menu'].hidden = true;
elements['#clay-error-modal'].hidden = true;
elements['#editor-load-error'].hidden = true;

for (const [name, view, panel] of [
  ['#dot-files-tab', 'dot-files', '#dot-files-panel'],
  ['#svg-files-tab', 'svg-files', '#svg-files-panel']
]) {
  const wrapper = new Element();
  const tab = elements[name];
  tab.dataset.explorerView = view;
  tab.setAttribute('role', 'tab');
  tab.setAttribute('aria-controls', panel.slice(1));
  wrapper.append(tab);
  elements['#explorer-tabs'].append(wrapper);
}
elements['#explorer-pane'].append(
  elements['#explorer-tabs'],
  elements['#dot-files-panel'],
  elements['#svg-files-panel']
);

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

function documentDescendants() {
  return Object.values(elements).flatMap((element) => {
    return [element, ...descendants(element)];
  });
}

global.document = {
  fullscreenElement: null,
  documentElement: new Element('html'),
  querySelector: (selector) => {
    if (elements[selector]) return elements[selector];
    const panelFrame = selector.match(/^#([^ ]+) iframe$/);
    if (panelFrame) {
      const panel = documentDescendants().find((item) => {
        return item.id === panelFrame[1];
      });
      return panel ? descendants(panel).find((item) => {
        return item.localName === 'iframe';
      }) : null;
    }
    if (selector.startsWith('#')) {
      return documentDescendants().find((item) => {
        return item.id === selector.slice(1);
      }) || null;
    }
    const docs = selector.match(/^\[data-docs-tab="([^"]+)"\]$/);
    if (docs) {
      return documentDescendants().find((item) => {
        return item.dataset?.docsTab === docs[1];
      });
    }
    return null;
  },
  querySelectorAll: (selector) => selector === '.docs-help-link'
    ? docsHelpLinks
    : [],
  getElementById: (id) => elements[`#${id}`] ||
    documentDescendants().find((item) => item.id === id) || null,
  importNode: (node) => node,
  createDocumentFragment: () => ({
    fragment: true,
    children: [],
    append(item) { this.children.push(item); }
  }),
  createElement: (name) => new Element(name),
  addEventListener: (name, callback) => { documentListeners[name] = callback; },
  exitFullscreen: async () => {
    global.document.fullscreenElement = null;
    documentListeners.fullscreenchange?.({});
  }
};
global.DOMParser = class {
  parseFromString(source) { return svgDocument(source); }
};
const themeMedia = {
  matches: false,
  listeners: {},
  addEventListener(name, callback) { this.listeners[name] = callback; },
  addListener(callback) { this.listeners.change = callback; }
};
global.matchMedia = (query) => query === '(prefers-color-scheme: dark)'
  ? themeMedia
  : {matches: false};
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
  getPropertyValue: (name) => element.values[name] ||
    (name === '--explorer-width' ? '288px' : '44%')
});
global.requestAnimationFrame = (callback) => callback();
URL.createObjectURL = () => 'blob:test';
URL.revokeObjectURL = () => {};
global.localStorage = {
  getItem: (key) => saved.get(key) ?? null,
  setItem: (key, value) => saved.set(key, value)
};

class FakeAceRange {
  constructor(startRow, startColumn, endRow, endColumn) {
    this.start = {row: startRow, column: startColumn};
    this.end = {row: endRow, column: endColumn};
  }
}

function fakePositionToIndex(source, position) {
  const lines = source.split('\n');
  const row = Math.max(0, Math.min(lines.length - 1, position.row));
  const column = Math.max(0, Math.min(lines[row].length, position.column));
  return lines.slice(0, row).reduce((total, line) => {
    return total + line.length + 1;
  }, column);
}

function fakeIndexToPosition(source, offset) {
  const next = Math.max(0, Math.min(source.length, offset));
  const before = source.slice(0, next);
  const lines = before.split('\n');
  return {row: lines.length - 1, column: lines.at(-1).length};
}

function createFakeAceEditor(host) {
  const changeListeners = [];
  const state = {source: '', anchorOffset: 0, leadOffset: 0};
  let nextMarker = 1;
  const undoManager = {
    reset() {},
    startNewGroup() {}
  };
  const session = {
    doc: {
      indexToPosition(offset) {
        return fakeIndexToPosition(state.source, offset);
      },
      positionToIndex(position) {
        return fakePositionToIndex(state.source, position);
      }
    },
    setValue(source) {
      state.source = source;
      state.anchorOffset = source.length;
      state.leadOffset = source.length;
      for (const listener of changeListeners) listener({action: 'setValue'});
    },
    replace(range, replacement) {
      const start = fakePositionToIndex(state.source, range.start);
      const end = fakePositionToIndex(state.source, range.end);
      state.source = state.source.slice(0, start) + replacement
        + state.source.slice(end);
      for (const listener of changeListeners) listener({action: 'replace'});
    },
    insert(position, source) {
      const offset = fakePositionToIndex(state.source, position);
      state.source = state.source.slice(0, offset) + source
        + state.source.slice(offset);
      state.anchorOffset = offset + source.length;
      state.leadOffset = state.anchorOffset;
      for (const listener of changeListeners) listener({action: 'insert'});
    },
    on(name, listener) {
      if (name === 'change') changeListeners.push(listener);
    },
    getUndoManager() { return undoManager; },
    setMode(mode) { this.mode = mode; },
    setUseWorker(worker) { this.worker = worker; },
    setAnnotations(annotations) { this.annotations = annotations; },
    clearAnnotations() { this.annotations = []; },
    addMarker(range, name, type) {
      const id = nextMarker++;
      this.marker = {id, range, name, type};
      return id;
    },
    removeMarker(id) {
      if (this.marker?.id === id) this.marker = undefined;
    }
  };
  const selection = {
    getRange() {
      const start = fakeIndexToPosition(state.source, state.anchorOffset);
      const end = fakeIndexToPosition(state.source, state.leadOffset);
      return new FakeAceRange(start.row, start.column, end.row, end.column);
    },
    setSelectionRange(range) {
      state.anchorOffset = fakePositionToIndex(state.source, range.start);
      state.leadOffset = fakePositionToIndex(state.source, range.end);
    },
    moveCursorTo(row, column) {
      const offset = fakePositionToIndex(state.source, {row, column});
      state.anchorOffset = offset;
      state.leadOffset = offset;
    }
  };
  host.aceSession = session;
  return {
    session,
    selection,
    commands: {
      platform: 'win',
      addCommands(commands) { this.addedCommands = commands; },
      bindKey(key, command) { this.boundKey = {key, command}; }
    },
    textInput: {getElement: () => host},
    getValue: () => state.source,
    setOptions(options) { this.options = options; },
    setTheme(theme) { this.theme = theme; host.aceTheme = theme; },
    focus: () => host.focus(),
    clearSelection() {
      state.anchorOffset = state.leadOffset;
    },
    scrollToLine(line) { host.scrollLine = line; },
    resize() { host.resizeCount = (host.resizeCount || 0) + 1; }
  };
}

global.window = {
  innerWidth: 1_024,
  innerHeight: 768,
  location: {
    href: 'http://localhost:18080/apps/graph-viz/',
    origin: 'http://localhost:18080'
  },
  addEventListener: (name, callback) => { windowListeners[name] = callback; },
  prompt: () => prompts.shift(),
  confirm: (message) => {
    confirmations.push(message);
    return confirmationAnswers.shift();
  },
  __GVIZ_BROWSER_TEST__: {acePlatform: 'win', keyboardLayout: 'en-US'}
};
const fakeAceEditors = new WeakMap();
global.window.ace = {
  edit: (host) => {
    if (!fakeAceEditors.has(host)) {
      fakeAceEditors.set(host, createFakeAceEditor(host));
    }
    return fakeAceEditors.get(host);
  },
  require: (name) => {
    if (name === 'ace/range') return {Range: FakeAceRange};
    assert.equal(name, 'ace/ext/beautify');
    return {commands: [{name: 'beautify'}]};
  }
};
global.window.graphVizAceAssets = {
  mode: 'ace/mode/dot',
  lightTheme: 'ace/theme/github',
  darkTheme: 'ace/theme/monokai',
  useWorker: false
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

function docsResponse(url = 'http://localhost:18080/docs') {
  return {
    ok: true,
    status: 200,
    url,
    headers: {get: () => 'text/html; charset=utf-8'},
    text: async () => '<html></html>'
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
  return (element.children || []).flatMap((child) => {
    return [child, ...descendants(child)];
  });
}
vm.runInThisContext(applicationSource, {filename: application});

const editor = window.__GVIZ_EDITOR_TEST__;
const getDotSource = () => editor.getSource();
const setDotSource = (source, notify = false) => {
  editor.setSource(source, {history: 'reset', notify});
};
const getDotSelection = () => editor.getSelection();

(async () => {
  assert.equal(getDotSource(), 'digraph saved { Alpha -> Beta }');
  assert.equal(elements['#workspace'].values['--editor-width'], '62%');
  assert.equal(elements['#workbench'].values['--explorer-width'], '288px');
  assert.equal(elements['#theme'].value, 'system');
  assert.equal(document.documentElement.dataset.theme, 'system');
  assert.equal(document.documentElement.dataset.effectiveTheme, 'light');
  assert.equal(document.documentElement.style.colorScheme, 'light');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/github');
  assert.equal(requests[0].url, '/apps/graph-viz/file/dot/browse');
  assert.equal(requests[1].url, '/apps/graph-viz/file/svg/browse');
  requests[0].resolve(response(true, JSON.stringify({
    file: false, children: []
  })));
  requests[1].resolve(response(true, JSON.stringify({
    file: false, children: []
  })));
  await tick();
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

  elements['#theme'].value = 'dark';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.theme, 'dark');
  assert.equal(document.documentElement.dataset.effectiveTheme, 'dark');
  assert.equal(document.documentElement.style.colorScheme, 'dark');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/monokai');
  await new Promise((resolve) => setTimeout(resolve, 200));
  assert.equal(JSON.parse(saved.get('graph-viz.session.v1'))
    .preferences.theme, 'dark');
  themeMedia.matches = true;
  elements['#theme'].value = 'light';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'light');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/github');
  elements['#theme'].value = 'system';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'dark');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/monokai');
  themeMedia.matches = false;
  themeMedia.listeners.change({matches: false});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'light');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/github');

  requests[2].resolve(response(true, '<svg id="initial"/>'));
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
  const themedSvg = elements['#preview'].children[0];
  elements['#theme'].value = 'dark';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'dark');
  assert.equal(elements['#preview'].children[0], themedSvg);
  assert.equal(themedSvg.renderSource, '<svg id="initial"/>');
  elements['#theme'].value = 'system';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'light');
  assert.equal(requests[3].url, '/docs');
  assert.equal(requests[3].options.credentials, 'same-origin');
  assert.equal(requests[3].options.cache, 'no-store');
  requests[3].resolve(docsResponse('http://localhost:18080/login'));
  await tick();
  assert.equal(elements['#fallback-help-content'].hidden, false);
  assert.equal(elements['#docs-help-content'].hidden, true);
  elements['#help'].listeners.click({});
  assert.equal(elements['#help-panel'].hidden, false);
  assert.equal(elements['#help']['aria-expanded'], 'true');
  assert.equal(document.activeElement, elements['#close-help']);
  assert.deepEqual(
    descendants(elements['#explorer-tabs'])
      .filter((item) => item.role === 'tab')
      .map((item) => item.dataset.explorerView),
    ['dot-files', 'svg-files']
  );
  elements['#close-help'].listeners.click({});
  assert.equal(elements['#help-panel'].hidden, true);
  assert.equal(elements['#help']['aria-expanded'], 'false');
  assert.equal(document.activeElement, elements['#help']);
  elements['#help'].listeners.click({});
  assert.equal(elements['#help-panel'].hidden, false);
  elements['#help-panel'].listeners.click({target: elements['#help-panel']});
  assert.equal(elements['#help-panel'].hidden, true);
  elements['#help'].listeners.click({});
  requests[4].resolve(docsResponse());
  await tick();
  assert.equal(elements['#fallback-help-content'].hidden, true);
  assert.equal(elements['#docs-help-content'].hidden, false);
  assert.equal(descendants(elements['#explorer-tabs']).filter((item) => {
    return item.className === 'docs-tab-control';
  }).length, 0);
  docsHelpLinks[0].listeners.click({preventDefault() {}});
  assert.equal(elements['#help-panel'].hidden, true);
  let docsControls = descendants(elements['#explorer-tabs']).filter((item) => {
    return item.className === 'docs-tab-control';
  });
  assert.equal(docsControls.length, 1);
  assert.deepEqual(
    descendants(elements['#explorer-tabs'])
      .filter((item) => item.role === 'tab')
      .map((item) => item.dataset.explorerView),
    ['dot-files', 'svg-files', 'docs-1']
  );
  let docsPanels = descendants(elements['#explorer-pane']).filter((item) => {
    return item.className === 'explorer-panel docs-explorer-panel';
  });
  assert.equal(docsPanels.length, 1);
  let docsFrame = descendants(docsPanels[0]).find((item) => {
    return item.localName === 'iframe';
  });
  assert.equal(docsFrame.src, '/docs/d/graph-viz/usr/users-guide');
  docsFrame.contentDocument = {
    title: 'Docs / Graph Viz / Users Guide',
    querySelector: () => null
  };
  docsFrame.contentWindow = {
    location: {pathname: '/docs/d/graph-viz/usr/users-guide'}
  };
  docsFrame.listeners.load({});
  assert.equal(docsControls[0].children[0].textContent, 'Users Guide');
  docsHelpLinks[0].listeners.click({preventDefault() {}});
  assert.equal(descendants(elements['#explorer-tabs']).filter((item) => {
    return item.className === 'docs-tab-control';
  }).length, 1);
  docsHelpLinks[1].listeners.click({preventDefault() {}});
  docsControls = descendants(elements['#explorer-tabs']).filter((item) => {
    return item.className === 'docs-tab-control';
  });
  assert.equal(docsControls.length, 2);
  docsPanels = descendants(elements['#explorer-pane']).filter((item) => {
    return item.className === 'explorer-panel docs-explorer-panel';
  });
  const referenceFrame = descendants(docsPanels[1]).find((item) => {
    return item.localName === 'iframe';
  });
  assert.equal(referenceFrame.src, '/docs/d/graph-viz/reference');
  const referenceClose = descendants(docsControls[1]).find((item) => {
    return item.className === 'docs-tab-close';
  });
  referenceClose.listeners.click({});
  assert.equal(descendants(elements['#explorer-tabs']).filter((item) => {
    return item.className === 'docs-tab-control';
  }).length, 1);
  docsFrame.listeners.error({});
  assert.equal(elements['#fallback-help-content'].hidden, false);
  assert.equal(elements['#docs-help-content'].hidden, true);
  assert.equal(descendants(elements['#explorer-tabs']).filter((item) => {
    return item.className === 'docs-tab-control';
  }).length, 0);
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
  assert(getDotSource().startsWith('strict digraph unique_edges'));
  assert(getDotSource().includes('last wins'));

  const dot = elements['#dot'];
  setDotSource('digraph old { Alpha -> Beta }');
  elements['#render'].listeners.click({});
  const oldRequest = requests.at(-1);
  setDotSource('digraph new { Alpha -> Beta }');
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
  assert.deepEqual(elements['#dot'].aceSession.annotations, [{
    row: 0, column: 8, text: 'syntax error', type: 'error'
  }]);
  assert.equal(elements['#dot'].aceSession.marker.range.start.column, 8);
  assert.equal(elements['#dot']['aria-invalid'], 'true');
  setDotSource(getDotSource(), true);
  assert.deepEqual(elements['#dot'].aceSession.annotations, []);
  assert.equal(elements['#dot'].aceSession.marker, undefined);
  assert.equal(elements['#dot']['aria-invalid'], 'false');

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

  setDotSource([
    'digraph shapes {',
    '  Alpha [shape=doublecircle]',
    '  Alpha -> Beta',
    '}'
  ].join('\n'));
  elements['#preview'].listeners.click({target: svg.groups[0]});
  assert.equal(elements['#attr-shape'].value, 'doublecircle');
  assert.equal(
    elements['#attr-shape'].dataset.sourceShape,
    'doublecircle'
  );
  elements['#attr-style'].value = 'dashed';
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  assert(getDotSource().includes('shape=doublecircle'));
  assert(getDotSource().includes('style=\"dashed\"'));
  requests.at(-1).resolve(response(true, '<svg id="styled"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  setDotSource([
    'digraph bulk_nodes {',
    '  Alpha [shape=box]',
    '  Alpha -> Beta',
    '}'
  ].join('\n'));
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
    const nodeLine = getDotSource().split('\n').find((line) => {
      return line.trimStart().startsWith(`${name} [`);
    });
    assert(nodeLine, name);
    assert(nodeLine.includes('shape=diamond'), nodeLine);
    assert(nodeLine.includes('color=\"purple\"'), nodeLine);
    assert(nodeLine.includes('fillcolor=\"yellow\"'), nodeLine);
    assert(nodeLine.includes('style=\"bold,filled\"'), nodeLine);
  }
  const nodeDefault = getDotSource().split('\n').find((line) => {
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
  assert(getDotSource().split('\n').some((line) => line.trim() === 'Gamma'));
  requests.at(-1).resolve(response(true, '<svg id="default-node"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  setDotSource([
    'digraph bulk_edges {',
    '  Alpha -> Beta',
    '  Beta -> Gamma',
    '}'
  ].join('\n'));
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
  const edgeLines = getDotSource().split('\n').filter((line) => {
    return line.includes(' -> ');
  });
  assert.equal(edgeLines.length, 2);
  for (const line of edgeLines) {
    assert(line.includes('color=\"blue\"'), line);
    assert(line.includes('style=\"dotted\"'), line);
    assert(line.includes('penwidth=2'), line);
  }
  const edgeDefault = getDotSource().split('\n').find((line) => {
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
  assert(getDotSource().split('\n').some((line) => {
    return line.trim() === 'Alpha -> Gamma';
  }));
  requests.at(-1).resolve(response(true, '<svg id="default-edge"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  setDotSource('digraph chain { Alpha -> Beta -> Gamma }');
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
  assert(getDotSource().includes('Alpha -> Beta'));
  const selectedEdgeLine = getDotSource().split('\n').find((line) => {
    return line.includes('Beta -> Gamma');
  });
  assert(selectedEdgeLine);
  assert(!getDotSource().includes(
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
  const selectedSource = getDotSelection();
  assert(getDotSource().slice(
    selectedSource.start,
    selectedSource.end
  ).includes('Alpha'));

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

  setDotSource('digraph persisted { Alpha -> Beta }', true);
  elements['#dot-files-tab'].listeners.keydown({
    key: 'ArrowRight', currentTarget: elements['#dot-files-tab'],
    preventDefault() {}
  });
  assert.equal(elements['#svg-files-tab']['aria-selected'], 'true');
  elements['#svg-files-tab'].listeners.keydown({
    key: 'ArrowLeft', currentTarget: elements['#svg-files-tab'],
    preventDefault() {}
  });
  assert.equal(elements['#dot-files-tab']['aria-selected'], 'true');
  elements['#explorer-resizer'].listeners.keydown({
    key: 'ArrowRight', preventDefault() {}
  });
  elements['#explorer-resizer'].listeners.pointerdown({pointerId: 21});
  elements['#explorer-resizer'].listeners.pointermove({
    pointerId: 21,
    clientX: 2_000
  });
  assert.equal(elements['#workbench'].values['--explorer-width'], '790px');
  await new Promise((resolve) => setTimeout(resolve, 200));
  const session = JSON.parse(saved.get('graph-viz.session.v1'));
  assert.equal(session.source, getDotSource());
  assert(Number.isFinite(session.view.scale));
  assert.equal(session.explorerWidth, 790);
  assert.equal(session.explorerView, 'dot-files');
  assert.deepEqual(session.docsTabs, []);
  assert.equal(session.nextDocs, 3);
  assert.equal(session.preferences.theme, 'system');

  prompts.push('/examples/source');
  const saveDotRequest = elements['#save-dot'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/save');
  assert.equal(requests.at(-1).options.headers['x-graph-viz-path'],
    'examples/source');
  assert.equal(requests.at(-1).options.body, getDotSource());
  confirmationAnswers.push(true);
  requests.at(-1).resolve(response(false, 'Clay file already exists', 409));
  await tick();
  assert(confirmations.at(-1).includes('DOT path "examples/source"'));
  assert.equal(requests.at(-1).options.headers['x-graph-viz-overwrite'],
    'true');
  requests.at(-1).resolve(response(true, 'saved'));
  await tick();
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/browse');
  await resolveBrowse('', false, []);
  await saveDotRequest;

  prompts.push('examples/output');
  const svgBeforeSave = elements['#preview'].children[0].renderSource;
  const saveSvgRequest = elements['#save-svg'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/svg/save');
  assert.equal(requests.at(-1).options.headers['x-graph-viz-path'],
    'examples/output');
  assert.equal(requests.at(-1).options.body, svgBeforeSave);
  const requestCount = requests.length;
  confirmationAnswers.push(false);
  requests.at(-1).resolve(response(false, 'Clay file already exists', 409));
  await saveSvgRequest;
  assert(confirmations.at(-1).includes('SVG path "examples/output"'));
  assert.equal(requests.length, requestCount);

  const browseDotRequest = elements['#browse-dot'].listeners.click({});
  assert.equal(elements['#dot-files-tab']['aria-selected'], 'true');
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/browse');
  await resolveBrowse('', false, ['examples']);
  await resolveBrowse('examples', false, ['alpha', 'beta']);
  await resolveBrowse('examples/alpha', false, ['txt']);
  await resolveBrowse('examples/alpha/txt', true, []);
  await resolveBrowse('examples/beta', false, ['txt']);
  await resolveBrowse('examples/beta/txt', true, []);
  await browseDotRequest;
  const dotFile = descendants(elements['#dot-files-tree']).find((item) => {
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
  assert.equal(getDotSource(), 'digraph browsed { B -> C }');

  const dotFileRow = dotFile.parentElement;
  const dotFileActions = dotFileRow.children.find((item) => {
    return item.className === 'file-tree-actions';
  });
  assert(dotFileActions);
  assert.equal(dotFileActions['aria-haspopup'], 'menu');
  dotFileRow.listeners.contextmenu({
    type: 'contextmenu', clientX: 120, clientY: 140,
    preventDefault() {}, stopPropagation() {}
  });
  assert.equal(elements['#file-context-menu'].hidden, false);
  assert.equal(dotFile['aria-expanded'], 'true');
  const contextLoadDot = elements['#file-context-open'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/load');
  requests.at(-1).resolve(response(true, 'digraph context { C -> D }'));
  await contextLoadDot;
  assert.equal(getDotSource(), 'digraph context { C -> D }');
  assert.equal(elements['#file-context-menu'].hidden, true);

  dotFileRow.listeners.contextmenu({
    type: 'contextmenu', clientX: 120, clientY: 140,
    preventDefault() {}, stopPropagation() {}
  });
  confirmationAnswers.push(true);
  const deleteDot = elements['#file-context-delete'].listeners.click({});
  assert(confirmations.at(-1).includes(
    'Delete examples/beta/txt? This cannot be undone.'
  ));
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/delete');
  assert.equal(requests.at(-1).options.headers['x-graph-viz-path'],
    'examples/beta/txt');
  requests.at(-1).resolve(response(true, 'deleted'));
  await tick();
  await resolveBrowse('', false, []);
  await deleteDot;
  assert.equal(elements['#source-status'].textContent,
    'examples/beta/txt deleted');
  assert(!descendants(elements['#dot-files-tree']).some((item) => {
    return item.dataset?.path === 'examples/beta/txt';
  }));

  elements['#auto-render'].checked = true;
  const browseSvgRequest = elements['#browse-svg'].listeners.click({});
  assert.equal(elements['#svg-files-tab']['aria-selected'], 'true');
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/svg/browse');
  await resolveBrowse('', false, ['examples']);
  await resolveBrowse('examples', false, ['preview']);
  await resolveBrowse('examples/preview', false, ['svg']);
  await resolveBrowse('examples/preview/svg', true, []);
  await browseSvgRequest;
  const svgFile = descendants(elements['#svg-files-tree']).find((item) => {
    return item.dataset?.path === 'examples/preview/svg';
  });
  assert(svgFile);
  assert.equal(svgFile.textContent, 'preview/svg');
  const sourceBeforeBrowseSvg = getDotSource();
  const browseLoadSvg = svgFile.listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/svg/load');
  requests.at(-1).resolve(response(true, '<svg id="browsed"/>'));
  await browseLoadSvg;
  assert.equal(elements['#preview'].children[0].renderSource,
    '<svg id="browsed"/>');
  assert.equal(getDotSource(), sourceBeforeBrowseSvg);
  assert.equal(elements['#auto-render'].checked, false);

  prompts.push('/examples/loaded');
  const loadDotRequest = elements['#load-dot'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/dot/load');
  requests.at(-1).resolve(response(true, 'digraph loaded { A -> B }'));
  await loadDotRequest;
  assert.equal(getDotSource(), 'digraph loaded { A -> B }');

  elements['#auto-render'].checked = true;
  const sourceBeforePromptSvg = getDotSource();
  prompts.push('examples/loaded');
  const loadSvgRequest = elements['#load-svg'].listeners.click({});
  assert.equal(requests.at(-1).url, '/apps/graph-viz/file/svg/load');
  requests.at(-1).resolve(response(true, '<svg id="loaded"/>'));
  await loadSvgRequest;
  assert.equal(elements['#preview'].children[0].renderSource,
    '<svg id="loaded"/>');
  assert.equal(getDotSource(), sourceBeforePromptSvg);
  assert.equal(elements['#auto-render'].checked, false);

  const failedBrowse = elements['#browse-dot'].listeners.click({});
  requests.at(-1).resolve(response(false, 'Clay browse failed'));
  await tick();
  await failedBrowse;
  assert(elements['#dot-files-tree'].textContent.includes(
    'Unable to load files'
  ));
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
