'use strict';

const assert = require('node:assert/strict');

const {settleFileTrees} = require('./support.js');

// Explorer pane: collapse, permanent tab strip, keyboard tab navigation,
// and the resizer.

module.exports = async (env) => {
  const {elements, descendants} = env;

  assert.equal(elements['#explorer-collapse']['aria-expanded'], 'true');
  assert.equal(elements['#explorer-collapse'].textContent, '‹');
  elements['#explorer-collapse'].listeners.click({});
  assert(elements['#explorer-pane'].classes.has('collapsed'));
  assert(elements['#workbench'].classes.has('explorer-collapsed'));
  assert.equal(elements['#explorer-resizer'].disabled, true);
  assert.equal(elements['#explorer-collapse']['aria-expanded'], 'false');
  assert.equal(elements['#explorer-collapse'].textContent, '›');
  elements['#explorer-collapse'].listeners.click({});
  assert.equal(elements['#explorer-resizer'].disabled, false);
  assert.equal(elements['#explorer-collapse']['aria-expanded'], 'true');

  await settleFileTrees(env);

  assert.deepEqual(
    descendants(elements['#explorer-tabs'])
      .filter((item) => item.role === 'tab')
      .map((item) => item.dataset.explorerView),
    ['dot-files', 'svg-files']
  );

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
};
