const {test, expect} = require('@playwright/test');
const {installBackend} = require('./fixtures/backend.js');

function visualSvg(source) {
  const nodes = ['Alpha', 'Beta', 'Gamma'];
  if (source.includes('Delta')) nodes.push('Delta');
  const edges = [];
  if (/Alpha\s*->\s*Beta/.test(source)) edges.push('Alpha->Beta');
  if (/Alpha\s*->\s*Gamma/.test(source)) edges.push('Alpha->Gamma');
  if (/Beta\s*->\s*Gamma/.test(source)) edges.push('Beta->Gamma');
  const groups = [
    ...nodes.map((name, index) => [
      `<g class="node" transform="translate(${20 + index * 25} 20)">`,
      `<title>${name}</title><ellipse rx="8" ry="6"/>`,
      `<text>${name}</text></g>`
    ].join('')),
    ...edges.map((name, index) => [
      `<g class="edge" transform="translate(20 ${45 + index * 15})">`,
      `<title>${name}</title><path d="M0 0 L50 0" stroke="black"/>`,
      `<text>${name}</text></g>`
    ].join(''))
  ];
  return [
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 100">',
    '<title>Visual test</title>',
    ...groups,
    '</svg>'
  ].join('');
}

async function prepareSource(page, renderBodies, source) {
  await page.evaluate((nextSource) => {
    const toggle = document.querySelector('#auto-render');
    toggle.checked = false;
    toggle.dispatchEvent(new Event('change'));
    window.__GVIZ_EDITOR_TEST__.setSource(nextSource, {
      history: 'reset',
      notify: false
    });
  }, source);
  renderBodies.length = 0;
  await page.locator('#render').click();
  await expect.poll(() => renderBodies.at(-1)).toBe(source);
  await expect(page.locator('#preview .node').first()).toBeVisible();
  await page.waitForTimeout(200);
  renderBodies.length = 0;
  await page.evaluate(() => {
    document.querySelector('#auto-render').checked = true;
    window.__GVIZ_SESSION_WRITE_COUNT__ = 0;
    window.__GVIZ_VISUAL_CHANGE_COUNT__ = 0;
  });
}

async function verifyVisualAction(
  page,
  renderBodies,
  before,
  after,
  action
) {
  await prepareSource(page, renderBodies, before);
  await action();
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(after);
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_VISUAL_CHANGE_COUNT__;
  })).toBe(1);
  await expect.poll(() => renderBodies.length).toBe(1);
  expect(renderBodies[0]).toBe(after);
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_SESSION_WRITE_COUNT__;
  })).toBe(1);

  await page.locator('#dot').click();
  await page.keyboard.press('Control+Z');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(before);
  await page.keyboard.press('Control+Y');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(after);
}

test.beforeEach(async ({context, page}) => {
  await context.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
    window.__GVIZ_SESSION_WRITE_COUNT__ = 0;
    const setItem = Storage.prototype.setItem;
    Storage.prototype.setItem = function setItemWithCount(key, value) {
      if (key === 'graph-viz.session.v1') {
        window.__GVIZ_SESSION_WRITE_COUNT__ += 1;
      }
      return setItem.call(this, key, value);
    };
  });
  await installBackend(page, {browse: true});
});

test('clicking a node or edge reveals its attributes', async ({page}) => {
  const renderBodies = [];
  await installBackend(page, {
    render: (source) => {
      renderBodies.push(source);
      return visualSvg(source);
    }
  });
  await page.goto('/apps/graph-viz/');
  const inspector = page.locator('#inspector');
  const form = page.locator('#attribute-form');
  const nodeControls = page.locator('#node-controls');
  const edgeControls = page.locator('#edge-controls');

  // No expand control exists for either group.
  await expect(page.locator('#preview-pane-node-attributes')).toHaveCount(0);
  await expect(page.locator('#preview-pane-edge-attributes')).toHaveCount(0);
  await expect(inspector).toBeHidden();

  await prepareSource(
    page,
    renderBodies,
    'digraph pick { Alpha -> Beta }'
  );
  await expect(nodeControls).toBeHidden();
  await expect(edgeControls).toBeHidden();

  // A node click opens the node group and every shared control.
  await page.locator('#preview .node').filter({hasText: 'Alpha'}).click();
  await expect(inspector).toBeVisible();
  await expect(form).toBeVisible();
  await expect(nodeControls).toBeVisible();
  await expect(edgeControls).toBeHidden();
  for (const id of ['#attr-label', '#attr-color', '#attr-style',
    '#attr-shape', '#attr-fillcolor']) {
    await expect(page.locator(id)).toBeVisible();
  }

  // An edge click swaps to the edge group -- all of it, one display.
  await page.locator('#preview .edge')
    .filter({hasText: 'Alpha->Beta'}).click();
  await expect(nodeControls).toBeHidden();
  await expect(edgeControls).toBeVisible();
  for (const id of ['#attr-label', '#attr-color', '#attr-style',
    '#attr-penwidth', '#attr-arrowhead', '#attr-arrowtail',
    '#attr-arrowsize', '#attr-dir', '#attr-minlen', '#attr-weight',
    '#attr-fontname', '#attr-fontsize', '#attr-fontcolor']) {
    await expect(page.locator(id)).toBeVisible();
  }

  // Clicking inside the attributes keeps them open.
  await page.locator('#attr-label').click();
  await expect(edgeControls).toBeVisible();

  // Two selected nodes are the edge between them.  With none there yet,
  // the edge group opens blank for the edge Apply would create.
  await page.locator('#preview .node').filter({hasText: 'Beta'}).click();
  await page.locator('#preview .node')
    .filter({hasText: 'Gamma'}).click({modifiers: ['Shift']});
  await expect(page.locator('#selection-kind')).toHaveText('New edge');
  await expect(page.locator('#selection-id')).toHaveText('Beta->Gamma');
  await expect(form).toBeVisible();
  await expect(nodeControls).toBeHidden();
  await expect(edgeControls).toBeVisible();
  await expect(page.locator('#attr-penwidth')).toHaveValue('');

  // An edge that already joins them wins, whichever way it points and
  // whichever node was clicked first: Alpha -> Beta is in the source,
  // and Beta then Alpha still finds it.
  await page.locator('#preview .node').filter({hasText: 'Beta'}).click();
  await page.locator('#preview .node')
    .filter({hasText: 'Alpha'}).click({modifiers: ['Shift']});
  await expect(page.locator('#selection-kind')).toHaveText('Edge');
  await expect(page.locator('#selection-id')).toHaveText('Alpha->Beta');
  await expect(form).toBeVisible();
  await expect(nodeControls).toBeHidden();
  await expect(edgeControls).toBeVisible();

  // Dropping back to one node restores that node's group alone.
  await page.locator('#preview .node').filter({hasText: 'Gamma'}).click();
  await expect(form).toBeVisible();
  await expect(nodeControls).toBeVisible();
  await expect(edgeControls).toBeHidden();

  // Clicking outside closes them.
  await page.locator('#dot').click();
  await expect(inspector).toBeHidden();
  await expect(nodeControls).toBeHidden();
  await expect(edgeControls).toBeHidden();
});

test('Apply on two selected nodes creates that edge', async ({page}) => {
  const renderBodies = [];
  await installBackend(page, {
    render: (source) => {
      renderBodies.push(source);
      return visualSvg(source);
    }
  });
  await page.goto('/apps/graph-viz/');
  await page.evaluate(() => {
    window.__GVIZ_EDITOR_TEST__.onChange(() => {
      window.__GVIZ_VISUAL_CHANGE_COUNT__ += 1;
    });
  });
  await prepareSource(page, renderBodies, 'digraph make {\n  Alpha\n  Beta\n}');

  await page.locator('#preview .node').filter({hasText: 'Alpha'}).click();
  await page.locator('#preview .node')
    .filter({hasText: 'Beta'}).click({modifiers: ['Shift']});
  await expect(page.locator('#selection-kind')).toHaveText('New edge');
  await page.locator('#attr-label').fill('link');
  await page.locator('#attr-penwidth').fill('2');
  await page.locator('#apply-attributes').click();

  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toContain('Alpha -> Beta');
  const source = await page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  });
  expect(source).toContain('label="link"');
  expect(source).toContain('penwidth=2');

  // One undoable edit, one render -- not a draw followed by an edit.
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_VISUAL_CHANGE_COUNT__;
  })).toBe(1);
  await expect.poll(() => renderBodies.length).toBe(1);
});

test('SVG node and edge selections reveal exact Ace ranges', async ({page}) => {
  const renderBodies = [];
  await installBackend(page, {
    render: (source) => {
      renderBodies.push(source);
      return visualSvg(source);
    }
  });
  await page.goto('/apps/graph-viz/');
  const filler = Array.from({length: 45}, (_, index) => {
    return `  filler_${index}`;
  });
  const source = [
    'digraph select {',
    ...filler,
    '  Alpha [color=red];',
    '  Beta',
    '  Alpha -> Beta [label="route"];',
    '}'
  ].join('\n');
  await prepareSource(page, renderBodies, source);
  const undoRevision = await page.evaluate(() => {
    return window.ace.edit(document.querySelector('#dot')).session
      .getUndoManager().getRevision();
  });

  await page.locator('#preview .node').filter({hasText: 'Alpha'}).click();
  const nodeStart = source.indexOf('Alpha [color=red];');
  const nodeEnd = nodeStart + 'Alpha [color=red];'.length;
  const nodeSelection = await page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    const range = aceEditor.selection.getRange();
    return {
      offsets: window.__GVIZ_EDITOR_TEST__.getSelection(),
      start: {row: range.start.row, column: range.start.column},
      end: {row: range.end.row, column: range.end.column},
      focused: document.activeElement.classList.contains('ace_text-input'),
      revision: aceEditor.session.getUndoManager().getRevision()
    };
  });
  expect(source.slice(
    nodeSelection.offsets.start,
    nodeSelection.offsets.end
  )).toBe('Alpha [color=red];');
  expect(nodeSelection).toMatchObject({
    offsets: {start: nodeStart, end: nodeEnd},
    start: {row: 46, column: 2},
    end: {row: 46, column: 20},
    focused: true,
    revision: undoRevision
  });
  await expect.poll(() => page.evaluate(() => {
    const renderer = window.ace.edit(document.querySelector('#dot')).renderer;
    return renderer.getFirstVisibleRow() <= 46
      && renderer.getLastVisibleRow() >= 46;
  })).toBe(true);

  await page.locator('#preview .edge')
    .filter({hasText: 'Alpha->Beta'}).click();
  const edgeText = 'Alpha -> Beta [label="route"];';
  const edgeStart = source.indexOf(edgeText);
  const edgeSelection = await page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    const range = aceEditor.selection.getRange();
    return {
      offsets: window.__GVIZ_EDITOR_TEST__.getSelection(),
      start: {row: range.start.row, column: range.start.column},
      end: {row: range.end.row, column: range.end.column},
      revision: aceEditor.session.getUndoManager().getRevision()
    };
  });
  expect(source.slice(
    edgeSelection.offsets.start,
    edgeSelection.offsets.end
  )).toBe(edgeText);
  expect(edgeSelection).toEqual({
    offsets: {start: edgeStart, end: edgeStart + edgeText.length},
    start: {row: 48, column: 2},
    end: {row: 48, column: 32},
    revision: undoRevision
  });
});

test('visual actions are single edits with exact render and persistence', async ({
  page
}) => {
  const renderBodies = [];
  await installBackend(page, {
    render: (source) => {
      renderBodies.push(source);
      return visualSvg(source);
    }
  });
  await page.goto('/apps/graph-viz/');
  await page.evaluate(() => {
    window.__GVIZ_VISUAL_CHANGE_COUNT__ = 0;
    window.__GVIZ_EDITOR_TEST__.onChange(() => {
      window.__GVIZ_VISUAL_CHANGE_COUNT__ += 1;
    });
  });
  const base = [
    'digraph visual {',
    '  Alpha',
    '  Beta',
    '  Gamma',
    '  Alpha -> Beta',
    '}'
  ].join('\n');

  const added = base.replace('\n}', '\n  Delta [shape=ellipse]\n}');
  await verifyVisualAction(page, renderBodies, base, added, async () => {
    await page.locator('#new-node-name').fill('Delta');
    await page.locator('#add-node').click();
  });

  const drawn = base.replace('\n}', '\n  Alpha -> Gamma\n}');
  await verifyVisualAction(page, renderBodies, base, drawn, async () => {
    await page.locator('#preview .node').filter({hasText: 'Alpha'}).click();
    await page.locator('#preview .node').filter({hasText: 'Gamma'})
      .click({modifiers: ['Shift']});
    await page.locator('#draw-edge').click();
  });

  const deleted = base.replace('  Alpha -> Beta\n', '');
  await verifyVisualAction(page, renderBodies, base, deleted, async () => {
    await page.locator('#preview .edge')
      .filter({hasText: 'Alpha->Beta'}).click();
    await page.locator('#delete-selection').click();
  });

  const chain = [
    'digraph visual {',
    '  Alpha',
    '  Beta',
    '  Gamma',
    '  Alpha -> Beta -> Gamma [color=red]',
    '}'
  ].join('\n');
  const attributed = [
    'digraph visual {',
    '  Alpha',
    '  Beta',
    '  Gamma',
    '  Alpha -> Beta [color=red]',
    '  Beta -> Gamma [color="red", label="next"]',
    '}'
  ].join('\n');
  await verifyVisualAction(
    page,
    renderBodies,
    chain,
    attributed,
    async () => {
      await page.locator('#preview .edge')
        .filter({hasText: 'Beta->Gamma'}).click();
      await page.locator('#attr-label').fill('next');
      await page.locator('#apply-attributes').click();
    }
  );
});

test('keyboard and visual edits keep independent undo order', async ({page}) => {
  const renderBodies = [];
  await installBackend(page, {
    render: (source) => {
      renderBodies.push(source);
      return visualSvg(source);
    }
  });
  await page.goto('/apps/graph-viz/');
  const base = 'digraph mixed {\n  Alpha\n}\n// key: ';
  await prepareSource(page, renderBodies, base);
  await page.locator('#dot').click();
  await page.keyboard.press('Control+End');
  await page.keyboard.type('x');
  const keyboardSource = `${base}x`;
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(keyboardSource);

  await page.locator('#new-node-name').fill('Delta');
  await page.locator('#add-node').click();
  const visualSource = keyboardSource.replace(
    '\n}',
    '\n  Delta [shape=ellipse]\n}'
  );
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(visualSource);

  await page.locator('#dot').click();
  await page.keyboard.press('Control+Z');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(keyboardSource);
  await page.keyboard.press('Control+Z');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(base);
  await page.keyboard.press('Control+Y');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(keyboardSource);
  await page.keyboard.press('Control+Y');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(visualSource);
});
