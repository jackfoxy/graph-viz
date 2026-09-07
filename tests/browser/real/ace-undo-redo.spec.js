const assert = require('node:assert/strict');
const {test, expect} = require('@playwright/test');

function renderedSvg(source, title = 'Undo test') {
  const nodes = ['Alpha', 'Beta', 'Gamma', 'Delta']
    .filter((name) => source.includes(name));
  const edgeNames = ['Alpha->Beta', 'Alpha->Gamma', 'Beta->Gamma'];
  const edges = edgeNames.filter((name) => {
    const [tail, head] = name.split('->');
    return new RegExp(`${tail}\\s*->\\s*${head}`).test(source);
  });
  return [
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 140 110">',
    `<title>${title}</title>`,
    ...nodes.map((name, index) => [
      `<g class="node" transform="translate(${20 + index * 28} 20)">`,
      `<title>${name}</title><ellipse rx="8" ry="6"/>`,
      `<text>${name}</text></g>`
    ].join('')),
    ...edges.map((name, index) => [
      `<g class="edge" transform="translate(20 ${50 + index * 18})">`,
      `<title>${name}</title><path d="M0 0 L50 0"/>`,
      `<text>${name}</text></g>`
    ].join('')),
    '</svg>'
  ].join('');
}

async function installRoutes(page, observations) {
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    const request = route.request();
    const isSvg = request.url().includes('/svg/');
    const path = request.headers()['x-graph-viz-path'] || '';
    const children = !isSvg ? []
      : path === '' ? ['history']
        : path === 'history' ? ['svg'] : [];
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        file: isSvg && path === 'history/svg',
        children
      })
    });
  });
  await page.route('**/apps/graph-viz/file/svg/load', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: renderedSvg('digraph loaded { Alpha }', 'Loaded history SVG')
    });
  });
  await page.route('**/apps/graph-viz/render', async (route) => {
    const source = route.request().postData() || '';
    observations.renderBodies.push(source);
    if (observations.failNextRender) {
      observations.failNextRender = false;
      await route.fulfill({
        status: 422,
        contentType: 'application/json',
        body: JSON.stringify({kind: 'parse', message: 'history failure'})
      });
      return;
    }
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: renderedSvg(source)
    });
  });
}

async function openEditor(page) {
  const observations = {renderBodies: [], failNextRender: false};
  const pageErrors = [];
  page.on('pageerror', (error) => pageErrors.push(String(error)));
  await installRoutes(page, observations);
  await page.goto('/apps/graph-viz/');
  await expect.poll(async () => ({
    ready: await page.evaluate(() => Boolean(window.__GVIZ_EDITOR_TEST__)),
    problem: await page.locator('#editor-load-error').evaluate((node) => {
      return node.title;
    }),
    pageErrors
  }), {timeout: 10_000}).toEqual({
    ready: true,
    problem: '',
    pageErrors: []
  });
  await page.evaluate(() => {
    const toggle = document.querySelector('#auto-render');
    toggle.checked = false;
    toggle.dispatchEvent(new Event('change'));
  });
  await page.waitForTimeout(200);
  observations.renderBodies.length = 0;
  await page.evaluate(() => {
    window.__GVIZ_SESSION_WRITE_COUNT__ = 0;
    window.__GVIZ_PERSISTED_SOURCES__ = [];
  });
  return observations;
}

async function readDocument(page) {
  return page.evaluate(() => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    const doc = editor.session.doc;
    const index = (position) => doc.positionToIndex(position, 0);
    return {
      source: editor.getValue(),
      anchor: index(editor.selection.getSelectionAnchor()),
      lead: index(editor.selection.getSelectionLead()),
      ranges: editor.selection.getAllRanges().map((range) => ({
        start: index(range.start),
        end: index(range.end)
      }))
    };
  });
}

async function readHistory(page) {
  return page.evaluate(() => {
    const manager = window.ace.edit(document.querySelector('#dot')).session
      .getUndoManager();
    return {
      revision: manager.getRevision(),
      hasUndo: manager.hasUndo(),
      hasRedo: manager.hasRedo()
    };
  });
}

async function settleEditor(page) {
  await expect.poll(() => page.evaluate(() => {
    return window.ace.edit(document.querySelector('#dot')).session.curOp
      === null;
  })).toBe(true);
}

async function expectDocument(page, expected) {
  await settleEditor(page);
  await expect.poll(() => readDocument(page)).toEqual(expected);
}

async function configureEditor(page, fixture) {
  await page.evaluate((next) => {
    const adapter = window.__GVIZ_EDITOR_TEST__;
    const editor = window.ace.edit(document.querySelector('#dot'));
    adapter.setSource(next.source, {
      history: 'reset',
      notify: false,
      selection: next.selection || {
        start: next.source.length,
        end: next.source.length
      }
    });
    if (next.ranges) {
      const Range = window.ace.require('ace/range').Range;
      const doc = editor.session.doc;
      const makeRange = (range) => {
        const start = doc.indexToPosition(range.start, 0);
        const end = doc.indexToPosition(range.end, 0);
        return new Range(start.row, start.column, end.row, end.column);
      };
      editor.selection.setSelectionRange(makeRange(next.ranges[0]), false);
      for (const range of next.ranges.slice(1)) {
        editor.selection.addRange(makeRange(range), false);
      }
    }
    editor.focus();
  }, fixture);
  await settleEditor(page);
  return readDocument(page);
}

async function press(page, binding) {
  const parts = binding.split('-');
  const key = parts.pop();
  const aliases = {Up: 'ArrowUp', Down: 'ArrowDown'};
  const modifiers = parts.map((part) => {
    return part === 'Ctrl' ? 'Control' : part;
  });
  for (const modifier of modifiers) await page.keyboard.down(modifier);
  try {
    await page.keyboard.press(aliases[key] || key);
  } finally {
    for (const modifier of modifiers.reverse()) {
      await page.keyboard.up(modifier);
    }
  }
}

async function verifyUndoRedo(page, before, after) {
  await page.evaluate(() => window.__GVIZ_EDITOR_TEST__.focus());
  await page.keyboard.press('Control+z');
  await settleEditor(page);
  const undone = await readDocument(page);
  expect(undone.source).toBe(before.source);
  await page.keyboard.press('Control+y');
  await settleEditor(page);
  const redone = await readDocument(page);
  expect(redone.source).toBe(after.source);
  await page.keyboard.press('Control+z');
  await expectDocument(page, undone);
  await page.keyboard.press('Control+Shift+z');
  await expectDocument(page, redone);
}

async function verifyAction(page, fixture, expectedSource, action) {
  const before = await configureEditor(page, fixture);
  await action();
  await expect.poll(async () => (await readDocument(page)).source)
    .toBe(expectedSource);
  await settleEditor(page);
  const after = await readDocument(page);
  await verifyUndoRedo(page, before, after);
}

async function commandOutcome(page, fixture, command) {
  await configureEditor(page, fixture);
  await page.evaluate((name) => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    editor.execCommand(name);
  }, command);
  await settleEditor(page);
  return readDocument(page);
}

async function verifyCommandHistory(page, item) {
  const expected = await commandOutcome(page, item.fixture, item.command);
  assert.notEqual(expected.source, item.fixture.source, item.name);
  const before = await configureEditor(page, item.fixture);
  await press(page, item.binding);
  await expectDocument(page, expected);
  await verifyUndoRedo(page, before, expected);
}

async function renderCurrent(page, observations) {
  observations.renderBodies.length = 0;
  await page.locator('#render').click();
  await expect.poll(() => observations.renderBodies.length).toBe(1);
  await expect(page.locator('#preview .node').first()).toBeVisible();
  observations.renderBodies.length = 0;
}

async function resetObservations(page, observations) {
  await page.waitForTimeout(450);
  observations.renderBodies.length = 0;
  await page.evaluate(() => {
    window.__GVIZ_SESSION_WRITE_COUNT__ = 0;
    window.__GVIZ_PERSISTED_SOURCES__ = [];
  });
}

async function expectOnePropagation(page, observations, source) {
  await expect.poll(() => observations.renderBodies).toEqual([source]);
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_PERSISTED_SOURCES__;
  })).toEqual([source]);
  await page.waitForTimeout(450);
  expect(observations.renderBodies).toEqual([source]);
  expect(await page.evaluate(() => {
    return window.__GVIZ_PERSISTED_SOURCES__;
  })).toEqual([source]);
}

test.beforeEach(async ({context}) => {
  await context.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
    window.__GVIZ_SESSION_WRITE_COUNT__ = 0;
    window.__GVIZ_PERSISTED_SOURCES__ = [];
    const setItem = Storage.prototype.setItem;
    Storage.prototype.setItem = function countedSetItem(key, value) {
      if (key === 'graph-viz.session.v1') {
        window.__GVIZ_SESSION_WRITE_COUNT__ += 1;
        const previous = JSON.parse(this.getItem(key) || 'null')?.source;
        const next = JSON.parse(value)?.source;
        if (previous !== next) window.__GVIZ_PERSISTED_SOURCES__.push(next);
      }
      return setItem.call(this, key, value);
    };
  });
});

test('character, typing, deletion, multiline, paste, and replacement history',
  async ({context, page}) => {
    await context.grantPermissions(['clipboard-read', 'clipboard-write']);
    await openEditor(page);
    const cases = [{
      name: 'character insertion',
      fixture: {source: 'abc', selection: {start: 3, end: 3}},
      expected: 'abcx',
      action: () => page.keyboard.type('x')
    }, {
      name: 'coalesced typing',
      fixture: {source: 'abc', selection: {start: 3, end: 3}},
      expected: 'abcxyz',
      action: () => page.keyboard.type('xyz')
    }, {
      name: 'backward deletion',
      fixture: {source: 'abcd', selection: {start: 2, end: 2}},
      expected: 'acd',
      action: () => page.keyboard.press('Backspace')
    }, {
      name: 'forward deletion',
      fixture: {source: 'abcd', selection: {start: 2, end: 2}},
      expected: 'abd',
      action: () => page.keyboard.press('Delete')
    }, {
      name: 'multiline change',
      fixture: {source: 'alphabeta', selection: {start: 5, end: 5}},
      expected: 'alpha\nbeta',
      action: () => page.keyboard.press('Enter')
    }, {
      name: 'selection replacement',
      fixture: {source: 'alpha beta', selection: {start: 6, end: 10}},
      expected: 'alpha B',
      action: () => page.keyboard.type('B')
    }, {
      name: 'multiline paste',
      fixture: {source: 'digraph {}', selection: {start: 9, end: 9}},
      expected: 'digraph {\n  Alpha\n  Beta}',
      action: async () => {
        await page.evaluate(async () => {
          await navigator.clipboard.writeText('\n  Alpha\n  Beta');
        });
        await page.keyboard.press('Control+v');
      }
    }];
    for (const item of cases) {
      await test.step(item.name, async () => {
        await verifyAction(page, item.fixture, item.expected, item.action);
      });
    }
  });

test('command edits preserve exact source and selection through both redos',
  async ({page}) => {
    await openEditor(page);
    const lines = 'one two\nthree four\nfive six';
    const cases = [{
      name: 'indent', binding: 'Tab', command: 'indent',
      fixture: {source: lines, selection: {start: 8, end: 24}}
    }, {
      name: 'outdent', binding: 'Shift-Tab', command: 'outdent',
      fixture: {
        source: 'one\n  two\n  three',
        selection: {start: 4, end: 18}
      }
    }, {
      name: 'remove line', binding: 'Ctrl-D', command: 'removeline',
      fixture: {source: lines, selection: {start: 12, end: 12}}
    }, {
      name: 'copy line down', binding: 'Alt-Shift-Down',
      command: 'copylinesdown',
      fixture: {source: lines, selection: {start: 12, end: 12}}
    }, {
      name: 'copy line up', binding: 'Alt-Shift-Up',
      command: 'copylinesup',
      fixture: {source: lines, selection: {start: 12, end: 12}}
    }, {
      name: 'move line down', binding: 'Alt-Down', command: 'movelinesdown',
      fixture: {source: lines, selection: {start: 12, end: 12}}
    }, {
      name: 'move line up', binding: 'Alt-Up', command: 'movelinesup',
      fixture: {source: lines, selection: {start: 12, end: 12}}
    }, {
      name: 'remove to line end', binding: 'Alt-Delete',
      command: 'removetolineend',
      fixture: {source: lines, selection: {start: 13, end: 13}}
    }, {
      name: 'remove to line start', binding: 'Alt-Backspace',
      command: 'removetolinestart',
      fixture: {source: lines, selection: {start: 17, end: 17}}
    }, {
      name: 'remove word left', binding: 'Ctrl-Backspace',
      command: 'removewordleft',
      fixture: {source: lines, selection: {start: 17, end: 17}}
    }, {
      name: 'remove word right', binding: 'Ctrl-Delete',
      command: 'removewordright',
      fixture: {source: lines, selection: {start: 10, end: 10}}
    }, {
      name: 'upper case', binding: 'Ctrl-U', command: 'touppercase',
      fixture: {source: 'alpha beta', selection: {start: 0, end: 5}}
    }, {
      name: 'lower case', binding: 'Ctrl-Shift-U', command: 'tolowercase',
      fixture: {source: 'ALPHA beta', selection: {start: 0, end: 5}}
    }, {
      name: 'number up', binding: 'Ctrl-Shift-Up',
      command: 'modifyNumberUp',
      fixture: {source: 'value=41', selection: {start: 8, end: 8}}
    }, {
      name: 'number down', binding: 'Ctrl-Shift-Down',
      command: 'modifyNumberDown',
      fixture: {source: 'value=41', selection: {start: 8, end: 8}}
    }, {
      name: 'line comment', binding: 'Ctrl-/', command: 'togglecomment',
      fixture: {
        source: 'digraph {\n  Alpha\n  Beta\n}',
        selection: {start: 10, end: 26}
      }
    }, {
      name: 'block comment', binding: 'Ctrl-Shift-/',
      command: 'toggleBlockComment',
      fixture: {
        source: 'digraph {\n  Alpha -> Beta\n}',
        selection: {start: 12, end: 25}
      }
    }];
    for (const item of cases) {
      await test.step(item.name, async () => {
        await verifyCommandHistory(page, item);
      });
    }
  });

test('multi-cursor edits restore every range through undo and redo',
  async ({page}) => {
    await openEditor(page);
    const fixture = {
      source: 'alpha\nbeta\ngamma',
      ranges: [{start: 6, end: 6}, {start: 11, end: 11}]
    };
    const before = await configureEditor(page, fixture);
    await page.keyboard.type('x');
    await expect.poll(async () => (await readDocument(page)).source)
      .toBe('alpha\nxbeta\nxgamma');
    await settleEditor(page);
    const after = await readDocument(page);
    expect(after.ranges).toHaveLength(2);
    await verifyUndoRedo(page, before, after);
  });

test('all visual mutations remain one exact undo unit', async ({page}) => {
  const observations = await openEditor(page);
  const base = [
    'digraph visual {',
    '  Alpha',
    '  Beta',
    '  Gamma',
    '  Alpha -> Beta',
    '}'
  ].join('\n');
  const scenarios = [{
    name: 'add node',
    before: base,
    after: base.replace('\n}', '\n  Delta [shape=ellipse]\n}'),
    prepare: async () => {
      await page.locator('#new-node-name').fill('Delta');
    },
    mutate: () => page.locator('#add-node').click()
  }, {
    name: 'draw edge',
    before: base,
    after: base.replace('\n}', '\n  Alpha -> Gamma\n}'),
    prepare: async () => {
      await page.locator('#preview .node').filter({hasText: 'Alpha'}).click();
      await page.locator('#preview .node').filter({hasText: 'Gamma'})
        .click({modifiers: ['Shift']});
    },
    mutate: () => page.locator('#draw-edge').click()
  }, {
    name: 'delete selection',
    before: base,
    after: base.replace('  Alpha -> Beta\n', ''),
    prepare: async () => {
      await page.locator('#preview .edge')
        .filter({hasText: 'Alpha->Beta'}).click();
    },
    mutate: () => page.locator('#delete-selection').click()
  }, {
    name: 'apply attributes',
    before: base,
    after: base.replace(
      'Alpha -> Beta',
      'Alpha -> Beta [label="route"]'
    ),
    prepare: async () => {
      await page.locator('#preview .edge')
        .filter({hasText: 'Alpha->Beta'}).click();
      await page.locator('#attr-label').fill('route');
    },
    mutate: () => page.locator('#apply-attributes').click()
  }];
  for (const scenario of scenarios) {
    await test.step(scenario.name, async () => {
      await configureEditor(page, {source: scenario.before});
      await renderCurrent(page, observations);
      await scenario.prepare();
      const before = await readDocument(page);
      await scenario.mutate();
      await expect.poll(async () => (await readDocument(page)).source)
        .toBe(scenario.after);
      await settleEditor(page);
      const after = await readDocument(page);
      await verifyUndoRedo(page, before, after);
    });
  }
});

test('keyboard and visual histories interleave and invalidate redo',
  async ({page}) => {
    const observations = await openEditor(page);
    const base = 'digraph mixed {\n  Alpha\n}\n// keys: ';
    const initial = await configureEditor(page, {source: base});
    await page.keyboard.type('x');
    await settleEditor(page);
    const keyboard = await readDocument(page);
    expect(keyboard.source).toBe(`${base}x`);
    await renderCurrent(page, observations);
    await page.locator('#new-node-name').fill('Delta');
    await page.locator('#add-node').click();
    await settleEditor(page);
    const visual = await readDocument(page);
    expect(visual.source).toBe(
      `${base.replace('\n}', '\n  Delta [shape=ellipse]\n}')}x`
    );
    await page.locator('#dot').click();
    await page.keyboard.press('Control+End');
    await page.keyboard.type('y');
    await settleEditor(page);
    const final = await readDocument(page);
    expect(final.source).toBe(`${visual.source}y`);

    const sources = [visual.source, keyboard.source, initial.source];
    const undoStates = [];
    for (const source of sources) {
      await page.keyboard.press('Control+z');
      await settleEditor(page);
      const state = await readDocument(page);
      expect(state.source).toBe(source);
      undoStates.push(state);
    }
    const redoSources = [keyboard.source, visual.source, final.source];
    const redoKeys = ['Control+y', 'Control+Shift+z', 'Control+y'];
    const redoStates = [];
    for (let index = 0; index < redoSources.length; index += 1) {
      await page.keyboard.press(redoKeys[index]);
      await settleEditor(page);
      const state = await readDocument(page);
      expect(state.source).toBe(redoSources[index]);
      redoStates.push(state);
    }
    await page.keyboard.press('Control+z');
    await expectDocument(page, undoStates[0]);
    await page.keyboard.press('Control+Shift+z');
    await expectDocument(page, redoStates[2]);
    await page.keyboard.press('Control+z');
    await expectDocument(page, undoStates[0]);
    await page.keyboard.type('!');
    await settleEditor(page);
    const replacement = await readDocument(page);
    expect(replacement.source).not.toBe(final.source);
    expect((await readHistory(page)).hasRedo).toBe(false);
    await page.keyboard.press('Control+y');
    await expectDocument(page, replacement);
    await page.keyboard.press('Control+Shift+z');
    await expectDocument(page, replacement);
  });

test('whole-document replacement respects undoable and reset boundaries',
  async ({page}) => {
    await openEditor(page);
    const base = 'digraph before {\n  Alpha -> Beta\n}';
    const before = await configureEditor(page, {
      source: base,
      selection: {start: 9, end: 15}
    });
    await page.locator('#template').selectOption('strict-digraph');
    await settleEditor(page);
    const template = await readDocument(page);
    expect(template.source).toContain('strict digraph unique_edges');
    expect(template.anchor).toBe(0);
    expect(template.lead).toBe(0);
    await verifyUndoRedo(page, before, template);

    const reset = 'digraph loaded {\n  Gamma\n}';
    await page.evaluate((source) => {
      window.__GVIZ_EDITOR_TEST__.setSource(source, {history: 'reset'});
    }, reset);
    const resetState = await readDocument(page);
    expect(resetState.source).toBe(reset);
    expect(await readHistory(page)).toEqual({
      revision: 0,
      hasUndo: false,
      hasRedo: false
    });
    await page.keyboard.press('Control+z');
    await expectDocument(page, resetState);
  });

test('rendering, theme, resize, tabs, and SVG load do not enter history',
  async ({page}) => {
    const observations = await openEditor(page);
    const base = 'digraph passive {\n  Alpha\n}';
    await configureEditor(page, {source: base});
    await page.keyboard.type('x');
    await settleEditor(page);
    const edited = await readDocument(page);
    const history = await readHistory(page);

    await page.locator('#render').click();
    await expect.poll(() => observations.renderBodies.length).toBe(1);
    observations.failNextRender = true;
    await page.locator('#render').click();
    await expect(page.locator('#error')).toContainText('history failure');
    await page.locator('#theme').selectOption('dark');
    await page.locator('#splitter').press('ArrowRight');
    await page.locator('#svg-files-tab').click();
    await expect(page.locator('[data-path="history/svg"]')).toBeVisible();
    await page.locator('[data-path="history/svg"]').click();
    await page.locator('#help').click();
    await expect(page.locator('#help-panel')).toBeVisible();
    await page.locator('#close-help').click();

    await expectDocument(page, edited);
    expect(await readHistory(page)).toEqual(history);
    await page.locator('#dot').click();
    await page.keyboard.press('Control+z');
    await expect.poll(async () => (await readDocument(page)).source)
      .toBe(base);
  });

test('long histories and repeated cycles preserve source and selection',
  async ({page}) => {
    await openEditor(page);
    const count = 80;
    const sources = ['seed:'];
    for (let index = 0; index < count; index += 1) {
      sources.push(`${sources.at(-1)}${String(index).padStart(2, '0')}`);
    }
    await configureEditor(page, {source: sources[0]});
    await page.evaluate((tokens) => {
      const adapter = window.__GVIZ_EDITOR_TEST__;
      for (const token of tokens) {
        const end = adapter.getSource().length;
        adapter.replaceRange(end, end, token, {notify: false});
      }
      adapter.focus();
    }, Array.from({length: count}, (_, index) => {
      return String(index).padStart(2, '0');
    }));
    await settleEditor(page);
    for (let index = count - 1; index >= 0; index -= 1) {
      await page.keyboard.press('Control+z');
      await settleEditor(page);
      const state = await readDocument(page);
      expect(state.source).toBe(sources[index]);
      const start = sources[index].length;
      expect(state).toEqual({
        source: sources[index],
        anchor: start,
        lead: sources[index].length,
        ranges: [{start, end: sources[index].length}]
      });
    }
    for (let index = 1; index <= count; index += 1) {
      await page.keyboard.press('Control+y');
      await settleEditor(page);
      const state = await readDocument(page);
      expect(state.source).toBe(sources[index]);
      const start = sources[index].length - 2;
      expect(state).toEqual({
        source: sources[index],
        anchor: start,
        lead: sources[index].length,
        ranges: [{start, end: sources[index].length}]
      });
    }
    const complete = await readDocument(page);
    for (let cycle = 0; cycle < 5; cycle += 1) {
      await page.keyboard.press('Control+z');
      await settleEditor(page);
      expect((await readDocument(page)).source).toBe(sources[count - 1]);
      await page.keyboard.press('Control+Shift+z');
      await expectDocument(page, complete);
    }
  });

test('undo and redo propagate one exact render and persistence update',
  async ({page}) => {
    const observations = await openEditor(page);
    const base = 'digraph notify {\n  Alpha\n}';
    await configureEditor(page, {source: base});
    await page.evaluate(() => {
      const toggle = document.querySelector('#auto-render');
      toggle.checked = true;
      toggle.dispatchEvent(new Event('change'));
    });
    await resetObservations(page, observations);

    await page.keyboard.type('x');
    const edited = `${base}x`;
    await expectOnePropagation(page, observations, edited);
    await resetObservations(page, observations);
    await page.keyboard.press('Control+z');
    await expectOnePropagation(page, observations, base);
    await resetObservations(page, observations);
    await page.keyboard.press('Control+y');
    await expectOnePropagation(page, observations, edited);

    await configureEditor(page, {source: base});
    await renderCurrent(page, observations);
    await resetObservations(page, observations);
    await page.locator('#new-node-name').fill('Delta');
    await page.locator('#add-node').click();
    const visual = base.replace('\n}', '\n  Delta [shape=ellipse]\n}');
    await expectOnePropagation(page, observations, visual);
    await resetObservations(page, observations);
    await page.locator('#dot').click();
    await page.keyboard.press('Control+z');
    await expectOnePropagation(page, observations, base);
    await resetObservations(page, observations);
    await page.keyboard.press('Control+Shift+z');
    await expectOnePropagation(page, observations, visual);
  });
