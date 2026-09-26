'use strict';

const assert = require('node:assert/strict');

const {settleFileTrees} = require('./support.js');

// Render request, SVG delivery, clipboard, templates, and stale-response
// discard.

module.exports = async (env) => {
  const {
    elements, document, clipboardWrites, requests, response, tick,
    getDotSource, getSvgSource, setDotSource
  } = env;

  await settleFileTrees(env);

  elements['#render'].listeners.click({});
  requests.at(-1).resolve(response(true, '<svg id="initial"/>'));
  await tick();
  await tick();
  assert(elements['#preview'].children[0], elements['#error'].textContent);
  assert.equal(elements['#preview'].children[0].renderSource,
    '<svg id="initial"/>');
  assert.equal(elements['#copy-svg'].disabled, false);
  assert.equal(elements['#fullscreen-svg'].disabled, false);
  assert.equal(elements['#fullscreen-svg'].hidden, false);
  await elements['#copy-svg'].listeners.click({});
  assert.equal(clipboardWrites.at(-1), '<svg id="initial"/>');
  assert.equal(elements['#render-status'].textContent, 'SVG copied');
  assert.equal(elements['#preview'].children[0].style.transform,
    'translate(20px, 30px) scale(2)');
  const themedSvg = elements['#preview'].children[0];
  elements['#theme'].value = 'dark';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'dark');
  assert.equal(elements['#preview'].children[0], themedSvg);
  assert.equal(themedSvg.renderSource, '<svg id="initial"/>');
  elements['#theme'].value = 'system';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'light');

  elements['#template'].value = 'strict-digraph';
  elements['#template'].listeners.change({});
  assert(getDotSource().startsWith('strict digraph unique_edges'));
  assert(getDotSource().includes('last wins'));

  setDotSource('digraph old { Alpha -> Beta }');
  elements['#render'].listeners.click({});
  const oldRequest = requests.at(-1);
  setDotSource('digraph new { Alpha -> Beta }');
  elements['#render'].listeners.click({});
  const newRequest = requests.at(-1);
  newRequest.resolve(response(true, '<svg id="new"/>'));
  await tick();
  await tick();
  oldRequest.resolve(response(true, '<svg id="old"/>'));
  await tick();
  await tick();
  assert.equal(elements['#preview'].children[0].renderSource,
    '<svg id="new"/>');
  elements['#toggle-svg-source'].listeners.click({});
  assert.equal(getSvgSource(), '<svg id="new"/>');
  elements['#toggle-svg-source'].listeners.click({});
};
