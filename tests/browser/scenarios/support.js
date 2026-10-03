'use strict';

// Setup helpers shared by scenarios.  These drive the doubles only; every
// assertion stays in the scenario that owns it.

//  urui's store module loads the DOT and SVG trees at start: one browse
//  each on the json file wire.
async function settleFileTrees(env) {
  const {requests, response, tick} = env;
  const empty = JSON.stringify({ok: true, entries: []});
  requests[0].resolve(response(true, empty));
  requests[1].resolve(response(true, empty));
  await tick();
  await tick();
}

//  urui's Source/Preview toggle for the svg store.
function showSvg(env, display) {
  const buttons = env.elements['#svg-display'].children;
  buttons.find((button) => button.dataset.display === display)
    .listeners.click({});
}

async function renderInto(env, body) {
  const {elements, requests, response, tick} = env;
  elements['#render'].listeners.click({});
  requests.at(-1).resolve(response(true, body));
  await tick();
  await tick();
  return elements['#preview'].children[0];
}

module.exports = {settleFileTrees, renderInto, showSvg};
