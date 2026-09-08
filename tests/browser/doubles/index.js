'use strict';

const assert = require('node:assert/strict');
const vm = require('node:vm');

const {createDom} = require('./dom.js');
const {createAce} = require('./ace.js');
const {createFetch, response, docsResponse, tocResponse} =
  require('./fetch.js');
const {createStorage, defaultSession, SESSION_KEY} = require('./storage.js');
const {createMedia} = require('./media.js');

const tick = () => new Promise((resolve) => setTimeout(resolve, 0));

// Install one scenario's doubles as process globals.  One environment per
// process: the application is a plain script and owns the global scope.

function createEnvironment({session = defaultSession} = {}) {
  const dom = createDom();
  const {ace, graphVizAceAssets} = createAce();
  const {requests, fetch} = createFetch();
  const {saved, localStorage} = createStorage(session);
  const {themeMedia, matchMedia} = createMedia();

  const documentListeners = dom.documentListeners;
  const windowListeners = {};
  const prompts = [];
  const confirmations = [];
  const confirmationAnswers = [];
  const clipboardWrites = [];

  const window = {
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
  window.ace = ace;
  window.graphVizAceAssets = graphVizAceAssets;

  global.document = dom.document;
  global.DOMParser = dom.DOMParser;
  global.matchMedia = matchMedia;
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
  global.localStorage = localStorage;
  global.window = window;
  global.fetch = fetch;

  const env = {
    Element: dom.Element,
    elements: dom.elements,
    document: dom.document,
    descendants: dom.descendants,
    group: dom.group,
    svgDocument: dom.svgDocument,
    documentListeners,
    windowListeners,
    window,
    themeMedia,
    requests,
    saved,
    prompts,
    confirmations,
    confirmationAnswers,
    clipboardWrites,
    sessionKey: SESSION_KEY,
    response,
    docsResponse,
    tocResponse,
    tick
  };

  env.resolveBrowse = async (path, file, children) => {
    const request = requests.at(-1);
    assert.equal(request.options.headers['x-graph-viz-path'],
      path || undefined);
    request.resolve(response(true, JSON.stringify({file, children})));
    await tick();
  };

  return env;
}

// Run the application against an installed environment and expose the
// editor handles the scenarios drive.

function bootApplication(env, applicationSource, filename) {
  vm.runInThisContext(applicationSource, {filename});
  env.editor = global.window.__GVIZ_EDITOR_TEST__;
  env.svgEditor = global.window.__GVIZ_SVG_EDITOR_TEST__;
  env.getDotSource = () => env.editor.getSource();
  env.getSvgSource = () => env.svgEditor.getSource();
  env.setDotSource = (source, notify = false) => {
    env.editor.setSource(source, {history: 'reset', notify});
  };
  env.getDotSelection = () => env.editor.getSelection();
  return env;
}

module.exports = {createEnvironment, bootApplication, tick};
