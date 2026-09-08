'use strict';

const assert = require('node:assert/strict');

const {settleFileTrees} = require('./support.js');

// /docs probe and fallback, the table of contents, and docs explorer tabs.

module.exports = async (env) => {
  const {elements, descendants, requests, docsResponse, tocResponse, tick} =
    env;

  await settleFileTrees(env);

  const docsRequest = requests.find((request) => request.url === '/docs');
  assert(docsRequest);
  assert.equal(docsRequest.options.credentials, 'same-origin');
  assert.equal(docsRequest.options.cache, 'no-store');
  docsRequest.resolve(docsResponse('http://localhost:18080/login'));
  await tick();
  assert.equal(elements['#fallback-help-content'].hidden, false);
  assert.equal(elements['#docs-help-content'].hidden, true);

  elements['#help'].listeners.click({});
  const retryDocsRequest = requests.filter((request) => {
    return request.url === '/docs';
  }).at(-1);
  retryDocsRequest.resolve(docsResponse());
  await tick();
  const tocRequest = requests.find((request) => {
    return request.url === '/apps/graph-viz/doc.toc';
  });
  assert(tocRequest);
  assert.equal(tocRequest.options.credentials, 'same-origin');
  assert.equal(tocRequest.options.cache, 'no-store');
  tocRequest.resolve(tocResponse());
  await tick();
  await tick();
  assert.equal(elements['#fallback-help-content'].hidden, true);
  assert.equal(elements['#docs-help-content'].hidden, false);
  const docsGroups = descendants(elements['#docs-help-nav']).filter((item) => {
    return item.className === 'docs-help-group';
  });
  assert.equal(docsGroups.length, 2);
  assert.equal(docsGroups[0].open, undefined);
  assert.equal(docsGroups[1].open, undefined);
  const docsHelpLinks = descendants(elements['#docs-help-nav'])
    .filter((item) => {
      return item.className === 'docs-help-link';
    });
  const usersGuideLink = docsHelpLinks.find((item) => {
    return item.dataset.docPath === 'users-guide';
  });
  const referenceLink = docsHelpLinks.find((item) => {
    return item.dataset.docPath === 'reference';
  });
  const arrowheadLink = docsHelpLinks.find((item) => {
    return item.dataset.docPath === 'dot-language/attributes/arrowhead';
  });
  assert(usersGuideLink);
  assert(referenceLink);
  assert.equal(arrowheadLink.href,
    '/docs/d/graph-viz/dot-language/attributes/arrowhead');
  assert.equal(descendants(elements['#explorer-tabs']).filter((item) => {
    return item.className === 'docs-tab-control';
  }).length, 0);
  usersGuideLink.listeners.click({preventDefault() {}});
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
  assert.equal(docsFrame.src, '/docs/d/graph-viz/users-guide');
  docsFrame.contentDocument = {
    title: 'Docs / Graph Viz / Users Guide',
    querySelector: () => null
  };
  docsFrame.contentWindow = {
    location: {pathname: '/docs/d/graph-viz/users-guide'}
  };
  docsFrame.listeners.load({});
  assert.equal(docsControls[0].children[0].textContent, 'Users Guide');
  usersGuideLink.listeners.click({preventDefault() {}});
  assert.equal(descendants(elements['#explorer-tabs']).filter((item) => {
    return item.className === 'docs-tab-control';
  }).length, 1);
  referenceLink.listeners.click({preventDefault() {}});
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
};
