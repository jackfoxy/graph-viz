'use strict';

// Setup helpers shared by scenarios.  These drive the doubles only; every
// assertion stays in the scenario that owns it.

async function settleFileTrees(env) {
  const {requests, response, tick} = env;
  requests[0].resolve(response(true, JSON.stringify({
    file: false, children: []
  })));
  requests[1].resolve(response(true, JSON.stringify({
    file: false, children: []
  })));
  await tick();
}

async function renderInto(env, body) {
  const {elements, requests, response, tick} = env;
  elements['#render'].listeners.click({});
  requests.at(-1).resolve(response(true, body));
  await tick();
  await tick();
  return elements['#preview'].children[0];
}

function docsRequests(env) {
  return env.requests.filter((request) => request.url === '/docs');
}

async function probeDocsFallback(env) {
  const request = docsRequests(env).at(-1);
  request.resolve(env.docsResponse('http://localhost:18080/login'));
  await env.tick();
}

// Reopen Help so the app retries /docs, then answer the table of contents.
async function loadDocsToc(env) {
  const {elements, requests, tick} = env;
  elements['#help'].listeners.click({});
  docsRequests(env).at(-1).resolve(env.docsResponse());
  await tick();
  const tocRequest = requests.find((request) => {
    return request.url === '/apps/graph-viz/doc.toc';
  });
  tocRequest.resolve(env.tocResponse());
  await tick();
  await tick();
  return tocRequest;
}

function explorerItems(env, className) {
  return env.descendants(env.elements['#explorer-tabs']).filter((item) => {
    return item.className === className;
  });
}

function docsPanels(env) {
  return env.descendants(env.elements['#explorer-pane']).filter((item) => {
    return item.className === 'explorer-panel docs-explorer-panel';
  });
}

function frameIn(env, panel) {
  return env.descendants(panel).find((item) => item.localName === 'iframe');
}

function docsHelpLinks(env) {
  return env.descendants(env.elements['#docs-help-nav']).filter((item) => {
    return item.className === 'docs-help-link';
  });
}

function docsHelpLink(env, path) {
  return docsHelpLinks(env).find((item) => item.dataset.docPath === path);
}

// Give an opened docs frame the content it would report once loaded.
function loadDocsFrame(frame, title, pathname) {
  frame.contentDocument = {title, querySelector: () => null};
  frame.contentWindow = {location: {pathname}};
  frame.listeners.load({});
  return frame;
}

const settle = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

module.exports = {
  settleFileTrees, renderInto, docsRequests, probeDocsFallback, loadDocsToc,
  explorerItems, docsPanels, frameIn, docsHelpLinks, docsHelpLink,
  loadDocsFrame, settle
};
