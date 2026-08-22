const {test, expect} = require('@playwright/test');

function renderedSvg(source) {
  const nodes = ['Alpha', 'Beta', 'Delta']
    .filter((name) => source.includes(name));
  return [
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 80">',
    '<title>Macro test</title>',
    ...nodes.map((name, index) => [
      `<g class="node" transform="translate(${20 + index * 30} 20)">`,
      `<title>${name}</title><ellipse rx="8" ry="6"/>`,
      `<text>${name}</text></g>`
    ].join('')),
    '</svg>'
  ].join('');
}

async function installRoutes(page, observations) {
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({file: false, children: []})
    });
  });
  await page.route('**/apps/graph-viz/render', async (route) => {
    const source = route.request().postData() || '';
    observations.renderBodies.push(source);
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: renderedSvg(source)
    });
  });
}

async function openEditor(page) {
  const observations = {renderBodies: []};
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
    window.__GVIZ_PERSISTED_SOURCES__ = [];
  });
  return observations;
}

async function settleEditor(page) {
  await expect.poll(() => page.evaluate(() => {
    return window.ace.edit(document.querySelector('#dot')).session.curOp
      === null;
  })).toBe(true);
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

function collapsed(source, position = source.length) {
  return {
    source,
    anchor: position,
    lead: position,
    ranges: [{start: position, end: position}]
  };
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

async function readMacro(page) {
  return page.evaluate(() => {
    const commands = window.ace.edit(document.querySelector('#dot')).commands;
    return {
      recording: Boolean(commands.recording),
      replaying: Boolean(commands.$inReplay),
      commands: commands.macro === undefined ? null
        : commands.macro.map(([command, args]) => ({
          name: typeof command === 'string' ? command : command.name,
          args: args === undefined ? null : args
        }))
    };
  });
}

async function startRecording(page) {
  await page.keyboard.press('Control+Alt+e');
  await expect.poll(async () => (await readMacro(page)).recording).toBe(true);
}

async function stopRecording(page) {
  await page.keyboard.press('Control+Alt+e');
  await expect.poll(async () => (await readMacro(page)).recording).toBe(false);
  await settleEditor(page);
}

async function record(page, action) {
  await startRecording(page);
  await action();
  await stopRecording(page);
}

async function replay(page) {
  await page.keyboard.press('Control+Shift+e');
  await settleEditor(page);
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
    window.__GVIZ_PERSISTED_SOURCES__ = [];
    const setItem = Storage.prototype.setItem;
    Storage.prototype.setItem = function macroSetItem(key, value) {
      if (key === 'graph-viz.session.v1') {
        const previous = JSON.parse(this.getItem(key) || 'null')?.source;
        const next = JSON.parse(value)?.source;
        if (previous !== next) window.__GVIZ_PERSISTED_SOURCES__.push(next);
      }
      return setItem.call(this, key, value);
    };
  });
});

test('macro controls handle pre-record replay, empty recording, and recursion',
  async ({page}) => {
    await openEditor(page);
    await configureEditor(page, {
      source: 'abc',
      selection: {start: 3, end: 3}
    });

    await replay(page);
    await expectDocument(page, collapsed('abc'));
    expect(await readMacro(page)).toEqual({
      recording: false,
      replaying: false,
      commands: null
    });

    await startRecording(page);
    expect(await readMacro(page)).toEqual({
      recording: true,
      replaying: false,
      commands: []
    });
    await stopRecording(page);
    expect(await readMacro(page)).toEqual({
      recording: false,
      replaying: false,
      commands: null
    });

    await record(page, () => page.keyboard.type('x'));
    await expectDocument(page, collapsed('abcx'));
    const recorded = await readMacro(page);
    expect(recorded).toEqual({
      recording: false,
      replaying: false,
      commands: [{name: 'insertstring', args: 'x'}]
    });
    for (const source of ['abcxx', 'abcxxx', 'abcxxxx']) {
      await replay(page);
      await expectDocument(page, collapsed(source));
      expect(await readMacro(page)).toEqual(recorded);
    }
  });

test('macros replay text, navigation, selection, deletion, indent, and lines',
  async ({page}) => {
    await openEditor(page);
    const source = 'Alpha tail\nBeta tail';
    await configureEditor(page, {
      source,
      selection: {start: 0, end: 0}
    });
    await record(page, async () => {
      await page.keyboard.press('End');
      await page.keyboard.press('Control+Shift+ArrowLeft');
      await page.keyboard.press('Backspace');
      await page.keyboard.type('node');
      await page.keyboard.press('Home');
      await page.keyboard.press('Tab');
      await page.keyboard.press('End');
      await page.keyboard.press('Enter');
      await page.keyboard.type('edge -> Ω;');
    });
    const first = '  Alpha node\n  edge -> Ω;\nBeta tail';
    await expectDocument(page, collapsed(first, 25));
    const commands = (await readMacro(page)).commands;
    const names = commands.map((entry) => entry.name);
    expect(names).toContain('gotolineend');
    expect(names).toContain('selectwordleft');
    expect(names).toContain('backspace');
    expect(names).toContain('indent');
    expect(commands.some((entry) => {
      return entry.args === '\n'
        || entry.name === 'newline'
        || entry.name === 'splitline';
    })).toBe(true);
    expect(names).not.toContain('togglerecording');
    expect(names).not.toContain('replaymacro');

    await page.evaluate(() => {
      const editor = window.ace.edit(document.querySelector('#dot'));
      editor.moveCursorTo(2, 0);
      editor.clearSelection();
      editor.focus();
    });
    await replay(page);
    const expected = [
      '  Alpha node',
      '  edge -> Ω;',
      '  Beta node',
      '  edge -> Ω;'
    ].join('\n');
    await expectDocument(page, collapsed(expected));
  });

test('replay works at multiple positions and replacement survives empty record',
  async ({page}) => {
    await openEditor(page);
    await configureEditor(page, {source: ''});
    await record(page, () => page.keyboard.type('A -> B;'));

    let source = 'digraph {\n  \n  \n}';
    await configureEditor(page, {
      source,
      selection: {start: 12, end: 12}
    });
    await replay(page);
    source = 'digraph {\n  A -> B;\n  \n}';
    await expectDocument(page, collapsed(source, 19));
    await page.evaluate(() => {
      const editor = window.ace.edit(document.querySelector('#dot'));
      editor.moveCursorTo(2, 2);
      editor.clearSelection();
      editor.focus();
    });
    await replay(page);
    source = 'digraph {\n  A -> B;\n  A -> B;\n}';
    await expectDocument(page, collapsed(source, 29));
    await replay(page);
    source = 'digraph {\n  A -> B;\n  A -> B;A -> B;\n}';
    await expectDocument(page, collapsed(source, 36));

    await configureEditor(page, {source: ''});
    await record(page, () => page.keyboard.type('β;'));
    const replacement = await readMacro(page);
    expect(replacement.commands).toEqual([
      {name: 'insertstring', args: 'β'},
      {name: 'insertstring', args: ';'}
    ]);
    await startRecording(page);
    await stopRecording(page);
    expect(await readMacro(page)).toEqual(replacement);
    await configureEditor(page, {source: 'digraph { }'});
    await replay(page);
    await expectDocument(page, collapsed('digraph { }β;'));
  });

test('selection and multi-cursor macros replay exact Unicode punctuation',
  async ({page}) => {
    await openEditor(page);
    await configureEditor(page, {
      source: 'ONE TWO',
      selection: {start: 0, end: 3}
    });
    await record(page, () => page.keyboard.type('λ'));
    await expectDocument(page, collapsed('λ TWO', 1));
    await configureEditor(page, {
      source: 'RED BLUE',
      selection: {start: 0, end: 3}
    });
    await replay(page);
    await expectDocument(page, collapsed('λ BLUE', 1));

    await configureEditor(page, {
      source: 'A\nB',
      ranges: [{start: 1, end: 1}, {start: 3, end: 3}]
    });
    await record(page, () => page.keyboard.type(';'));
    expect((await readMacro(page)).commands).toEqual([
      {name: 'insertstring', args: ';'}
    ]);
    await configureEditor(page, {
      source: 'C\nD\nE',
      ranges: [
        {start: 1, end: 1},
        {start: 3, end: 3},
        {start: 5, end: 5}
      ]
    });
    await replay(page);
    expect(await readDocument(page)).toEqual({
      source: 'C;\nD;\nE;',
      anchor: 8,
      lead: 8,
      ranges: [
        {start: 2, end: 2},
        {start: 5, end: 5},
        {start: 8, end: 8}
      ]
    });
  });

test('playback history and recording after undo-redo follow pinned Ace',
  async ({page}) => {
    await openEditor(page);
    await configureEditor(page, {source: ''});
    await record(page, () => page.keyboard.type('xy'));
    await configureEditor(page, {source: 'A'});
    const before = await readDocument(page);
    await replay(page);
    const played = await readDocument(page);
    expect(played).toEqual(collapsed('Axy'));

    await page.keyboard.press('Control+z');
    await expect.poll(async () => (await readDocument(page)).source)
      .toBe(before.source);
    const undone = await readDocument(page);
    await page.keyboard.press('Control+y');
    await expect.poll(async () => (await readDocument(page)).source)
      .toBe(played.source);
    const redone = await readDocument(page);
    await page.keyboard.press('Control+z');
    await expectDocument(page, undone);
    await page.keyboard.press('Control+Shift+z');
    await expectDocument(page, redone);

    await record(page, async () => {
      await page.keyboard.press('Control+z');
      await page.keyboard.press('Control+y');
    });
    const historyMacro = await readMacro(page);
    expect(historyMacro.commands.map((entry) => entry.name))
      .toEqual(['undo', 'redo']);
    const beforeHistoryReplay = await readDocument(page);
    await replay(page);
    expect(await readDocument(page)).toEqual(beforeHistoryReplay);

    await record(page, () => page.keyboard.type('z'));
    expect((await readMacro(page)).commands).toEqual([
      {name: 'insertstring', args: 'z'}
    ]);
    await configureEditor(page, {source: 'B'});
    await replay(page);
    await expectDocument(page, collapsed('Bz'));
  });

test('macro playback persists and auto-renders each resulting source once',
  async ({page}) => {
    const observations = await openEditor(page);
    await configureEditor(page, {source: ''});
    await record(page, () => page.keyboard.type('Alpha -> β;'));
    const base = 'digraph macro {\n  \n}';
    await configureEditor(page, {
      source: base,
      selection: {start: 18, end: 18}
    });
    await page.evaluate(() => {
      const toggle = document.querySelector('#auto-render');
      toggle.checked = true;
      toggle.dispatchEvent(new Event('change'));
    });
    await resetObservations(page, observations);

    await replay(page);
    const first = 'digraph macro {\n  Alpha -> β;\n}';
    await expectDocument(page, collapsed(first, 29));
    await expectOnePropagation(page, observations, first);
    await resetObservations(page, observations);
    await replay(page);
    const second = 'digraph macro {\n  Alpha -> β;Alpha -> β;\n}';
    await expectOnePropagation(page, observations, second);
  });

test('application shortcuts and visual widgets cannot corrupt a macro',
  async ({page}) => {
    const observations = await openEditor(page);
    const base = 'digraph safe {\n  Alpha\n}';
    await configureEditor(page, {source: base});
    await renderCurrent(page, observations);
    await page.evaluate(() => window.__GVIZ_EDITOR_TEST__.focus());
    await startRecording(page);
    await page.keyboard.type('x');
    await page.keyboard.press('Control+Enter');
    await expect.poll(() => observations.renderBodies.length).toBe(1);
    await page.keyboard.press('Control+0');
    await page.keyboard.press('Control+1');
    await page.locator('#new-node-name').fill('Delta');
    await page.locator('#add-node').click();
    await page.evaluate(() => window.__GVIZ_EDITOR_TEST__.focus());
    await stopRecording(page);

    const macro = await readMacro(page);
    expect(macro.commands).toEqual([{name: 'insertstring', args: 'x'}]);
    const changed = base.replace(
      '\n}',
      '\n  Delta [shape=ellipse]\n}'
    ) + 'x';
    await expect.poll(async () => (await readDocument(page)).source)
      .toBe(changed);
    await configureEditor(page, {source: 'digraph target {\n}'});
    await replay(page);
    await expectDocument(page, collapsed('digraph target {\n}x'));
    expect(await readMacro(page)).toEqual(macro);
  });
