'use strict';

const assert = require('node:assert/strict');

const {settleFileTrees, renderInto} = require('./support.js');

// Parse failures surface as Ace annotations and markers without dropping
// the last good render.

module.exports = async (env) => {
  const {elements, requests, response, tick, getDotSource, setDotSource} = env;

  await settleFileTrees(env);
  const retained = await renderInto(env, '<svg id="initial"/>');

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
};
