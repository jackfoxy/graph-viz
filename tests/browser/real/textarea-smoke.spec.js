const {test, expect} = require('@playwright/test');

const smokeSource = 'digraph smoke {Alpha -> Beta}';

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

test('Ace accepts real keyboard input and updates the application once', async ({page}) => {
  const host = page.locator('#dot');
  const renderRequests = [];
  page.on('request', (request) => {
    if (request.url().endsWith('/apps/graph-viz/render')) {
      renderRequests.push(request);
    }
  });
  await expect(host).toHaveClass(/ace_editor/);
  await page.evaluate(() => {
    document.querySelector('#auto-render').checked = false;
    window.__GVIZ_SESSION_WRITE_COUNT__ = 0;
  });
  await host.click();
  await page.keyboard.press('Control+A');
  await page.keyboard.type('digraph smoke ');
  await page.keyboard.type('{');
  await page.keyboard.type('Alpha -> Beta');
  await page.keyboard.type('}');

  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(smokeSource);
  await expect.poll(async () => page.evaluate(() => {
    const saved = JSON.parse(localStorage.getItem('graph-viz.session.v1'));
    return saved?.source;
  })).toBe(smokeSource);
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_SESSION_WRITE_COUNT__;
  })).toBe(1);
  expect(renderRequests).toHaveLength(0);

  await page.evaluate(() => {
    document.querySelector('#auto-render').checked = true;
  });
  await page.keyboard.type(' ');
  await expect.poll(() => renderRequests.length).toBe(1);
  const finalSource = `${smokeSource} `;

  const state = await page.evaluate(() => ({
    active: document.activeElement.classList.contains('ace_text-input'),
    selection: window.__GVIZ_EDITOR_TEST__.getSelection(),
    sourceStatus: document.querySelector('#source-status').textContent,
    testPlatform: window.__GVIZ_BROWSER_TEST__,
    platform: window.ace.edit(document.querySelector('#dot')).commands.platform,
    mode: window.ace.edit(document.querySelector('#dot')).session.getMode().$id,
    worker: window.ace.edit(document.querySelector('#dot')).session
      .getUseWorker(),
    options: {
      printMargin: window.ace.edit(document.querySelector('#dot'))
        .getShowPrintMargin(),
      softTabs: window.ace.edit(document.querySelector('#dot')).session
        .getUseSoftTabs(),
      tabSize: window.ace.edit(document.querySelector('#dot')).session
        .getTabSize(),
      wrap: window.ace.edit(document.querySelector('#dot')).session
        .getUseWrapMode()
    }
  }));
  expect(state).toEqual({
    active: true,
    selection: {start: finalSource.length, end: finalSource.length},
    sourceStatus: expect.stringMatching(/^(Rendering|Waiting|Ready)$/),
    testPlatform: {acePlatform: 'win', keyboardLayout: 'en-US'},
    platform: 'win',
    mode: 'ace/mode/dot',
    worker: false,
    options: {printMargin: false, softTabs: true, tabSize: 2, wrap: true}
  });
});

test('Ace adapter preserves Unicode and multiline absolute offsets', async ({page}) => {
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
      changes
    };
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    aceEditor.session.insert({row: 2, column: 4}, 'λ');
    const nativeChanges = changes;
    adapter.setSource('digraph {\n  α -> β\n}', {
      selection: {start: 12, end: 18}
    });
    adapter.selectRange(12, 18, {focus: true, reveal: true});
    const afterDocument = {
      source: adapter.getSource(),
      selection: adapter.getSelection(),
      focused: document.activeElement.classList.contains('ace_text-input'),
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
      changes: 1
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

test('Ace accepts clipboard paste and exposes exact multiline source', async ({
  context,
  page
}) => {
  await context.grantPermissions(['clipboard-read', 'clipboard-write']);
  const pasted = 'digraph pasted {\n  α -> β\n  β -> γ\n}';
  await page.evaluate(async (source) => {
    const adapter = window.__GVIZ_EDITOR_TEST__;
    document.querySelector('#auto-render').checked = false;
    adapter.setSource('', {notify: false});
    adapter.focus();
    await navigator.clipboard.writeText(source);
  }, pasted);
  await page.keyboard.press('Control+V');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(pasted);
});
