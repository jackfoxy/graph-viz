'use strict';

const assert = require('node:assert/strict');

const {settleFileTrees, renderInto} = require('./support.js');

// Shape catalogue, attribute form edits, bulk and default application,
// node/edge creation, and selection.

module.exports = async (env) => {
  const {
    elements, requests, response, tick, getDotSource, setDotSource,
    getDotSelection
  } = env;

  await settleFileTrees(env);

  assert.equal(elements['#new-node-category'].value, 'basic-shapes');
  assert.equal(elements['#new-node-shape'].value, 'ellipse');
  assert.equal(elements['#new-node-shape'].children.length, 16);
  elements['#new-node-category'].value = 'dna-construction-symbols';
  elements['#new-node-category'].listeners.change({});
  assert.equal(elements['#new-node-shape'].value, 'primersite');
  assert.equal(elements['#new-node-shape'].children.length, 11);
  assert(elements['#new-node-shape'].children.some((option) => {
    return option.value === 'lpromoter';
  }));
  for (const [category, first, count] of [
    ['basic-symbols', 'note', 7],
    ['special-shapes', 'doublecircle', 10],
    ['gene-expression-symbols', 'promoter', 9],
    ['other-shapes', 'polygon', 6]
  ]) {
    elements['#new-node-category'].value = category;
    elements['#new-node-category'].listeners.change({});
    assert.equal(elements['#new-node-shape'].value, first);
    assert.equal(elements['#new-node-shape'].children.length, count);
  }
  elements['#new-node-category'].value = 'basic-shapes';
  elements['#new-node-category'].listeners.change({});

  let svg = await renderInto(env, '<svg id="initial"/>');

  setDotSource([
    'digraph shapes {',
    '  Alpha [shape=doublecircle]',
    '  Alpha -> Beta',
    '}'
  ].join('\n'));
  elements['#preview'].listeners.click({target: svg.groups[0]});
  assert.equal(elements['#attr-shape'].value, 'doublecircle');
  assert.equal(
    elements['#attr-shape'].dataset.sourceShape,
    'doublecircle'
  );
  elements['#attr-style'].value = 'dashed';
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  assert(getDotSource().includes('shape=doublecircle'));
  assert(getDotSource().includes('style=\"dashed\"'));
  requests.at(-1).resolve(response(true, '<svg id="styled"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  setDotSource([
    'digraph bulk_nodes {',
    '  Alpha [shape=box]',
    '  Alpha -> Beta',
    '}'
  ].join('\n'));
  elements['#preview'].listeners.click({target: svg.groups[0]});
  assert.equal(elements['#attr-change-all'].checked, false);
  assert.equal(elements['#attr-use-default'].checked, false);
  elements['#attr-label'].value = '';
  elements['#attr-shape'].value = 'diamond';
  elements['#attr-color'].value = 'purple';
  elements['#attr-fillcolor'].value = 'yellow';
  elements['#attr-style'].value = 'bold';
  elements['#attr-change-all'].checked = true;
  elements['#attr-use-default'].checked = true;
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  for (const name of ['Alpha', 'Beta']) {
    const nodeLine = getDotSource().split('\n').find((line) => {
      return line.trimStart().startsWith(`${name} [`);
    });
    assert(nodeLine, name);
    assert(nodeLine.includes('shape=diamond'), nodeLine);
    assert(nodeLine.includes('color=\"purple\"'), nodeLine);
    assert(nodeLine.includes('fillcolor=\"yellow\"'), nodeLine);
    assert(nodeLine.includes('style=\"bold,filled\"'), nodeLine);
  }
  const nodeDefault = getDotSource().split('\n').find((line) => {
    return line.trimStart().startsWith('node [');
  });
  assert(nodeDefault);
  assert(nodeDefault.includes('shape=diamond'));
  assert.equal(elements['#new-node-shape'].value, 'diamond');
  requests.at(-1).resolve(response(true, '<svg id="bulk-nodes"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  elements['#new-node-name'].value = 'Gamma';
  elements['#add-node'].listeners.click({});
  assert(getDotSource().split('\n').some((line) => line.trim() === 'Gamma'));
  requests.at(-1).resolve(response(true, '<svg id="default-node"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  setDotSource([
    'digraph bulk_edges {',
    '  Alpha -> Beta',
    '  Beta -> Gamma',
    '}'
  ].join('\n'));
  elements['#preview'].listeners.click({target: svg.groups[3]});
  assert.equal(elements['#attr-change-all'].checked, false);
  assert.equal(elements['#attr-use-default'].checked, false);
  elements['#attr-label'].value = '';
  elements['#attr-color'].value = 'blue';
  elements['#attr-style'].value = 'dotted';
  elements['#attr-penwidth'].value = '2';
  elements['#attr-change-all'].checked = true;
  elements['#attr-use-default'].checked = true;
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  const edgeLines = getDotSource().split('\n').filter((line) => {
    return line.includes(' -> ');
  });
  assert.equal(edgeLines.length, 2);
  for (const line of edgeLines) {
    assert(line.includes('color=\"blue\"'), line);
    assert(line.includes('style=\"dotted\"'), line);
    assert(line.includes('penwidth=2'), line);
  }
  const edgeDefault = getDotSource().split('\n').find((line) => {
    return line.trimStart().startsWith('edge [');
  });
  assert(edgeDefault);
  assert(edgeDefault.includes('color=\"blue\"'));
  requests.at(-1).resolve(response(true, '<svg id="bulk-edges"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  elements['#preview'].listeners.click({target: svg.groups[0]});
  elements['#preview'].listeners.click({
    target: svg.groups[2], shiftKey: true
  });
  elements['#draw-edge'].listeners.click({});
  assert(getDotSource().split('\n').some((line) => {
    return line.trim() === 'Alpha -> Gamma';
  }));
  requests.at(-1).resolve(response(true, '<svg id="default-edge"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  setDotSource('digraph chain { Alpha -> Beta -> Gamma }');
  elements['#preview'].listeners.click({target: svg.groups[4]});
  assert.equal(elements['#selection-kind'].textContent, 'Edge');
  assert.equal(elements['#selection-id'].textContent, 'Beta->Gamma');
  assert.equal(elements['#attribute-form'].hidden, false);
  assert.equal(elements['#shape-control'].hidden, true);
  assert.equal(elements['#fill-control'].hidden, true);
  assert.equal(elements['#edge-controls'].hidden, false);
  elements['#attr-label'].value = 'next';
  elements['#attr-color'].value = 'blue';
  elements['#attr-style'].value = 'dashed';
  elements['#attr-penwidth'].value = '2';
  elements['#attr-arrowhead'].value = 'vee';
  elements['#attr-arrowtail'].value = 'dot';
  elements['#attr-arrowsize'].value = '1.5';
  elements['#attr-dir'].value = 'both';
  elements['#attr-minlen'].value = '2';
  elements['#attr-weight'].value = '3';
  elements['#attr-fontname'].value = 'Arial';
  elements['#attr-fontsize'].value = '12';
  elements['#attr-fontcolor'].value = 'green';
  elements['#attribute-form'].listeners.submit({preventDefault() {}});
  assert(getDotSource().includes('Alpha -> Beta'));
  const selectedEdgeLine = getDotSource().split('\n').find((line) => {
    return line.includes('Beta -> Gamma');
  });
  assert(selectedEdgeLine);
  assert(!getDotSource().includes(
    'Alpha -> Beta [label=\"next\"'
  ));
  for (const attribute of [
    'label=\"next\"',
    'color=\"blue\"',
    'style=\"dashed\"',
    'penwidth=2',
    'arrowhead=vee',
    'arrowtail=dot',
    'arrowsize=1.5',
    'dir=both',
    'minlen=2',
    'weight=3',
    'fontname=\"Arial\"',
    'fontsize=12',
    'fontcolor=\"green\"'
  ]) {
    assert(selectedEdgeLine.includes(attribute), attribute);
  }
  requests.at(-1).resolve(response(true, '<svg id="edge-styled"/>'));
  await tick();
  await tick();
  svg = elements['#preview'].children[0];

  elements['#preview'].listeners.click({target: svg.groups[0]});
  assert(svg.groups[0].classList.contains('is-selected'));
  assert.equal(elements['#selection-kind'].textContent, 'Node');
  assert.equal(elements['#selection-id'].textContent, 'Alpha');
  const selectedSource = getDotSelection();
  assert(getDotSource().slice(
    selectedSource.start,
    selectedSource.end
  ).includes('Alpha'));

  elements['#preview'].listeners.click({
    target: svg.groups[1], shiftKey: true
  });
  assert(svg.groups[0].classList.contains('is-selected'));
  assert(svg.groups[1].classList.contains('is-selected'));
  assert.equal(elements['#selection-id'].textContent, 'Alpha -> Beta');

  elements['#preview'].listeners.click({
    target: svg.groups[2], shiftKey: true
  });
  assert(svg.groups[0].classList.contains('is-selected'));
  assert(!svg.groups[1].classList.contains('is-selected'));
  assert(svg.groups[2].classList.contains('is-selected'));
  assert.equal(elements['#selection-id'].textContent, 'Alpha -> Gamma');
  assert.equal(elements['#draw-edge'].disabled, false);
};
