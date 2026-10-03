'use strict';

const assert = require('node:assert/strict');

const {settleFileTrees, renderInto, showSvg} = require('./support.js');

// Preview surface: fullscreen, SVG source view, wheel zoom, and pan.

module.exports = async (env) => {
  const {elements, document, clipboardWrites, getSvgSource} = env;

  await settleFileTrees(env);
  await renderInto(env, '<svg id="initial"/>');

  await elements['#fullscreen-svg'].listeners.click({});
  assert.equal(document.fullscreenElement, elements['#preview-shell']);
  assert(elements['#preview-shell'].classes.has('is-fullscreen'));
  assert.equal(elements['#fullscreen-svg']['aria-pressed'], 'true');
  assert.equal(elements['#fullscreen-zoom-out'].disabled, false);
  assert.equal(elements['#fullscreen-zoom-in'].disabled, false);
  const beforeFullscreenZoom =
    elements['#preview'].children[0].style.transform;
  elements['#fullscreen-zoom-out'].listeners.click({});
  assert.notEqual(
    elements['#preview'].children[0].style.transform,
    beforeFullscreenZoom
  );
  const afterFullscreenZoomOut =
    elements['#preview'].children[0].style.transform;
  elements['#fullscreen-zoom-in'].listeners.click({});
  assert.notEqual(
    elements['#preview'].children[0].style.transform,
    afterFullscreenZoomOut
  );
  assert.equal(
    elements['#fullscreen-svg'].title,
    'Return SVG to preview panel'
  );
  await elements['#fullscreen-svg'].listeners.click({});
  assert.equal(document.fullscreenElement, null);
  assert(!elements['#preview-shell'].classes.has('is-fullscreen'));
  assert.equal(elements['#fullscreen-svg']['aria-pressed'], 'false');

  //  urui's toggle swaps the SVG source editor for the preview host
  const [sourceButton, previewButton] = elements['#svg-display'].children;
  showSvg(env, 'source');
  assert.equal(elements['#svg-preview'].hidden, true);
  assert.equal(elements['#svg-source'].hidden, false);
  assert.equal(getSvgSource(), '<svg id="initial"/>');
  assert.equal(sourceButton['aria-pressed'], 'true');
  assert.equal(previewButton['aria-pressed'], 'false');
  assert.equal(elements['#fullscreen-svg'].hidden, true);
  await elements['#svg-copy'].listeners.click({});
  assert.equal(clipboardWrites.at(-1), '<svg id="initial"/>');
  showSvg(env, 'preview');
  assert.equal(elements['#svg-preview'].hidden, false);
  assert.equal(elements['#svg-source'].hidden, true);
  assert.equal(previewButton['aria-pressed'], 'true');
  assert.equal(elements['#fullscreen-svg'].hidden, false);

  const svg = elements['#preview'].children[0];
  const beforeZoom = svg.style.transform;
  elements['#preview'].listeners.wheel({
    clientX: 400, clientY: 300, deltaY: -100, preventDefault() {}
  });
  assert.notEqual(svg.style.transform, beforeZoom);
  const beforePan = svg.style.transform;
  elements['#preview'].listeners.pointerdown({
    target: elements['#preview'], button: 0, pointerId: 7,
    clientX: 100, clientY: 100, preventDefault() {}
  });
  elements['#preview'].listeners.pointermove({
    pointerId: 7, clientX: 130, clientY: 120
  });
  elements['#preview'].listeners.pointerup({pointerId: 7});
  assert.notEqual(svg.style.transform, beforePan);
};
