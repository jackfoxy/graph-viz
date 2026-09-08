'use strict';

const assert = require('node:assert/strict');

const {
  settleFileTrees, probeDocsFallback, loadDocsToc, explorerItems, docsPanels,
  frameIn, docsHelpLink, loadDocsFrame, settle
} = require('./support.js');

// The persisted session envelope, after the shell has been exercised.

module.exports = async (env) => {
  const {elements, descendants, saved, setDotSource, getDotSource} = env;

  await settleFileTrees(env);
  await probeDocsFallback(env);
  await loadDocsToc(env);

  // Two docs tabs opened, one closed by its control and one by a load
  // failure: the strip is empty again but the id counter has advanced.
  docsHelpLink(env, 'users-guide').listeners.click({preventDefault() {}});
  const docsFrame = loadDocsFrame(
    frameIn(env, docsPanels(env)[0]),
    'Docs / Graph Viz / Users Guide',
    '/docs/d/graph-viz/users-guide'
  );
  docsHelpLink(env, 'reference').listeners.click({preventDefault() {}});
  const referenceControl = explorerItems(env, 'docs-tab-control')[1];
  descendants(referenceControl).find((item) => {
    return item.className === 'docs-tab-close';
  }).listeners.click({});
  docsFrame.listeners.error({});

  setDotSource('digraph persisted { Alpha -> Beta }', true);
  elements['#dot-files-tab'].listeners.keydown({
    key: 'ArrowRight', currentTarget: elements['#dot-files-tab'],
    preventDefault() {}
  });
  elements['#svg-files-tab'].listeners.keydown({
    key: 'ArrowLeft', currentTarget: elements['#svg-files-tab'],
    preventDefault() {}
  });
  elements['#explorer-resizer'].listeners.keydown({
    key: 'ArrowRight', preventDefault() {}
  });
  elements['#explorer-resizer'].listeners.pointerdown({pointerId: 21});
  elements['#explorer-resizer'].listeners.pointermove({
    pointerId: 21,
    clientX: 2_000
  });
  await settle(200);
  const session = JSON.parse(saved.get('graph-viz.session.v1'));
  assert.equal(session.source, getDotSource());
  assert(Number.isFinite(session.view.scale));
  assert.equal(session.explorerWidth, 790);
  assert.equal(session.explorerOpen, true);
  assert.equal(session.explorerView, 'dot-files');
  assert.deepEqual(session.docsTabs, []);
  assert.equal(session.nextDocs, 3);
  assert.equal(session.preferences.theme, 'system');
};
