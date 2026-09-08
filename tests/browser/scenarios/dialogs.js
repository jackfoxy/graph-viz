'use strict';

const assert = require('node:assert/strict');

const {settleFileTrees, probeDocsFallback} = require('./support.js');

// Help panel focus handling and the Clay error modal.

module.exports = async (env) => {
  const {elements, document, requests, prompts, response, tick} = env;

  await settleFileTrees(env);
  await probeDocsFallback(env);

  elements['#help'].listeners.click({});
  assert.equal(elements['#help-panel'].hidden, false);
  assert.equal(elements['#help']['aria-expanded'], 'true');
  assert.equal(document.activeElement, elements['#close-help']);
  elements['#close-help'].listeners.click({});
  assert.equal(elements['#help-panel'].hidden, true);
  assert.equal(elements['#help']['aria-expanded'], 'false');
  assert.equal(document.activeElement, elements['#help']);
  elements['#help'].listeners.click({});
  assert.equal(elements['#help-panel'].hidden, false);
  elements['#help-panel'].listeners.click({target: elements['#help-panel']});
  assert.equal(elements['#help-panel'].hidden, true);

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
};
