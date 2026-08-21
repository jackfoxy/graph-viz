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
