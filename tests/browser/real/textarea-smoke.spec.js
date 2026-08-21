const {test, expect} = require('@playwright/test');

const smokeSource = 'digraph smoke {Alpha -> Beta}';

test.beforeEach(async ({context, page}) => {
  await context.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
  });
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({file: false, children: []})
    });
  });
  await page.route('**/apps/graph-viz/render', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: [
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
        '<title>Smoke</title><circle cx="5" cy="5" r="4"/></svg>'
      ].join('')
    });
  });
  await page.goto('/apps/graph-viz/');
});

test('current textarea accepts real keyboard input and exposes state', async ({page}) => {
  const editor = page.getByRole('textbox', {name: 'DOT source'});
  await expect(editor).toHaveJSProperty('localName', 'textarea');
  await editor.click();
  await page.keyboard.press('Control+A');
  await page.keyboard.type('digraph smoke ');
  await page.keyboard.type('{');
  await page.keyboard.type('Alpha -> Beta');
  await page.keyboard.type('}');

  await expect(editor).toHaveValue(smokeSource);
  await expect.poll(async () => page.evaluate(() => {
    const saved = JSON.parse(localStorage.getItem('graph-viz.session.v1'));
    return saved?.source;
  })).toBe(smokeSource);

  const state = await editor.evaluate((element) => ({
    active: document.activeElement === element,
    selectionStart: element.selectionStart,
    selectionEnd: element.selectionEnd,
    sourceStatus: document.querySelector('#source-status').textContent,
    testPlatform: window.__GVIZ_BROWSER_TEST__
  }));
  expect(state).toEqual({
    active: true,
    selectionStart: smokeSource.length,
    selectionEnd: smokeSource.length,
    sourceStatus: expect.stringMatching(/^(Waiting|Ready)$/),
    testPlatform: {acePlatform: 'win', keyboardLayout: 'en-US'}
  });
});

test('textarea editor adapter satisfies the source and range contract', async ({page}) => {
  const result = await page.evaluate(() => {
    const adapter = window.__GVIZ_EDITOR_TEST__;
    if (!adapter) throw new Error('editor adapter test hook is missing');
    document.querySelector('#auto-render').checked = false;
    let changes = 0;
    const unsubscribe = adapter.onChange(() => { changes += 1; });
    const source = 'A🙂\nβeta';
    adapter.setSource(source, {
      notify: false,
      selection: {start: 4, end: 5}
    });
    const positions = {
      emojiEnd: adapter.offsetToPosition(3),
      secondLine: adapter.offsetToPosition(4),
      secondLineOffset: adapter.positionToOffset({row: 1, column: 2}),
      clampedOffset: adapter.positionToOffset({row: 99, column: 99})
    };
    adapter.replaceRange(4, 5, 'γ\nδ', {selection: 'select'});
    const afterRange = {
      source: adapter.getSource(),
      selection: adapter.getSelection(),
      changes,
      gutterLines: document.querySelector('#line-numbers').children.length
    };
    const textarea = document.querySelector('#dot');
    textarea.value += 'λ';
    textarea.dispatchEvent(new Event('input', {bubbles: true}));
    const nativeChanges = changes;
    adapter.setSource('digraph {\n  α -> β\n}', {
      selection: {start: 12, end: 18}
    });
    adapter.selectRange(12, 18, {focus: true, reveal: true});
    const afterDocument = {
      source: adapter.getSource(),
      selection: adapter.getSelection(),
      focused: document.activeElement === document.querySelector('#dot'),
      changes
    };
    unsubscribe();
    adapter.setSource('digraph final {}');
    const finalSelection = adapter.getSelection();
    return {
      positions,
      afterRange,
      nativeChanges,
      afterDocument,
      changes,
      finalSelection
    };
  });

  expect(result).toEqual({
    positions: {
      emojiEnd: {row: 0, column: 3},
      secondLine: {row: 1, column: 0},
      secondLineOffset: 6,
      clampedOffset: 8
    },
    afterRange: {
      source: 'A🙂\nγ\nδeta',
      selection: {start: 4, end: 7},
      changes: 1,
      gutterLines: 3
    },
    nativeChanges: 2,
    afterDocument: {
      source: 'digraph {\n  α -> β\n}',
      selection: {start: 12, end: 18},
      focused: true,
      changes: 3
    },
    changes: 3,
    finalSelection: {start: 16, end: 16}
  });
});
