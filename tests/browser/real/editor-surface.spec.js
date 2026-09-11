const {test, expect} = require('@playwright/test');
const {installBackend} = require('./fixtures/backend.js');

const svg = [
  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
  '<title>Rendered</title><circle cx="5" cy="5" r="4"/></svg>'
].join('');

async function installRoutes(page) {
  await installBackend(page, {
    browse: true,
    render: (source) => source.includes('INVALID')
      ? {
        status: 422,
        contentType: 'application/json',
        body: JSON.stringify({
          kind: 'parse',
          line: 35,
          column: 7,
          message: 'expected DOT statement'
        })
      }
      : svg
  });
}

test.beforeEach(async ({context, page}) => {
  await context.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
  });
  await installRoutes(page);
});

test('parse diagnostics use exact Ace annotations and markers', async ({
  page
}) => {
  await page.goto('/apps/graph-viz/');
  const lines = [
    'digraph diagnostics {',
    ...Array.from({length: 33}, (_, index) => `  node_${index}`),
    '      INVALID',
    '}'
  ];
  const source = lines.join('\n');
  await page.evaluate((nextSource) => {
    document.querySelector('#auto-render').checked = false;
    window.__GVIZ_EDITOR_TEST__.setSource(nextSource, {
      history: 'reset',
      notify: false
    });
  }, source);
  await page.locator('#render').click();
  await expect(page.locator('#error')).toContainText(
    'Line 35, column 7: expected DOT statement'
  );

  const diagnostic = await page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    const markers = Object.values(aceEditor.session.getMarkers(false));
    const marker = markers.find((item) => {
      return item.clazz === 'ace-error-marker';
    });
    return {
      annotations: aceEditor.session.getAnnotations(),
      marker: marker && {
        start: marker.range.start,
        end: marker.range.end,
        type: marker.type
      },
      cursor: aceEditor.getCursorPosition(),
      invalid: aceEditor.textInput.getElement()
        .getAttribute('aria-invalid')
    };
  });
  expect(diagnostic).toMatchObject({
    annotations: [{
      row: 34,
      column: 6,
      text: 'expected DOT statement',
      type: 'error'
    }],
    marker: {
      start: {row: 34, column: 6},
      end: {row: 34, column: 7},
      type: 'text'
    },
    cursor: {row: 34, column: 6},
    invalid: 'true'
  });
  await expect.poll(() => page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    return aceEditor.renderer.getFirstVisibleRow() <= 34
      && aceEditor.renderer.getLastVisibleRow() >= 34;
  })).toBe(true);

  await page.evaluate(() => {
    const adapter = window.__GVIZ_EDITOR_TEST__;
    adapter.replaceRange(
      adapter.getSource().length,
      adapter.getSource().length,
      '\n// edit'
    );
  });
  await expect.poll(() => page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    return {
      annotations: aceEditor.session.getAnnotations().length,
      marker: Object.values(aceEditor.session.getMarkers(false)).some(
        (item) => item.clazz === 'ace-error-marker'
      ),
      invalid: aceEditor.textInput.getElement()
        .getAttribute('aria-invalid')
    };
  })).toEqual({annotations: 0, marker: false, invalid: 'false'});
  await expect(page.locator('#error')).toBeHidden();

  await page.evaluate((nextSource) => {
    window.__GVIZ_EDITOR_TEST__.setSource(nextSource);
  }, source);
  await page.locator('#render').click();
  await expect(page.locator('#error')).toBeVisible();
  await page.evaluate(() => {
    window.__GVIZ_EDITOR_TEST__.setSource('digraph valid { a -> b }');
  });
  await page.locator('#render').click();
  await expect(page.locator('#error')).toBeHidden();
  await expect.poll(() => page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    return aceEditor.session.getAnnotations().length;
  })).toBe(0);
});

test('Clay load failure opens a modal and restores focus', async ({page}) => {
  await installBackend(page, {
    dotLoad: {
      status: 500,
      contentType: 'text/plain',
      body: 'Clay load failed'
    }
  });
  await page.addInitScript(() => {
    window.prompt = () => 'missing/txt';
  });
  await page.goto('/apps/graph-viz/');
  await page.locator('#load-dot').click();

  await expect(page.locator('#clay-error-modal')).toBeVisible();
  await expect(page.locator('#clay-error-message'))
    .toHaveText('Error: Clay load failed');
  await expect(page.locator('#close-clay-error')).toBeFocused();
  await page.keyboard.press('Escape');
  await expect(page.locator('#clay-error-modal')).toBeHidden();
  await expect(page.locator('#load-dot')).toBeFocused();
});
