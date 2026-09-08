'use strict';

const assert = require('node:assert/strict');

const {renderInto} = require('./support.js');

// Clay file management: save with conflict, browse tree, load, context menu,
// and delete, over both the DOT and SVG roots.

module.exports = async (env) => {
  const {
    elements, descendants, requests, prompts, confirmations,
    confirmationAnswers, response, resolveBrowse, tick, getDotSource
  } = env;

  assert.equal(requests[0].url, '/apps/graph-viz/file/dot/browse');
  assert.equal(requests[1].url, '/apps/graph-viz/file/svg/browse');
  requests[0].resolve(response(true, JSON.stringify({
    file: false, children: []
  })));
  requests[1].resolve(response(true, JSON.stringify({
    file: false, children: []
  })));
  await tick();
  await renderInto(env, '<svg id="initial"/>');

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
  const contextRequestCount = requests.length;
  const contextLoadDot = elements['#file-context-open'].listeners.click({});
  await contextLoadDot;
  assert.equal(requests.length, contextRequestCount);
  assert.equal(getDotSource(), 'digraph browsed { B -> C }');
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
  assert.equal(elements['#auto-render'].checked, true);

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
  assert.equal(elements['#auto-render'].checked, true);
};
