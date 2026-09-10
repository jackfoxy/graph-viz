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

module.exports = {settleFileTrees, renderInto};
