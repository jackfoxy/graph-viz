const {test, expect} = require('@playwright/test');
const {installBackend, DEFER} = require('./fixtures/backend.js');

const strictTemplate = [
  'strict digraph unique_edges {',
  '  rankdir=LR',
  '  node [shape=box]',
  '  Start -> Validate [label=first]',
  '  Start -> Validate [label="last wins", color=blue]',
  '  Validate -> Done',
  '}'
].join('\n');

function renderedSvg(title) {
  return [
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
    `<title>${title}</title><circle cx="5" cy="5" r="4"/></svg>`
  ].join('');
}

async function installCommonRoutes(page, options = {}) {
  await installBackend(page, {
    browse: true,
    render: renderedSvg('Rendered'),
    ...options
  });
}

test.beforeEach(async ({context}) => {
  await context.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
    const addEventListener = window.addEventListener.bind(window);
    window.addEventListener = (type, listener, options) => {
      if (type === 'beforeunload') {
        window.__GVIZ_BEFOREUNLOAD_TEST__ = listener;
      }
      return addEventListener(type, listener, options);
    };
  });
});

test('template replacement is one undoable whole-document edit', async ({
  page
}) => {
  await installCommonRoutes(page);
  await page.goto('/apps/graph-viz/');
  const before = 'digraph before {\n  α -> β\n}\n';
  await page.evaluate((source) => {
    document.querySelector('#auto-render').checked = false;
    window.__GVIZ_EDITOR_TEST__.setSource(source, {
      history: 'reset',
      notify: false
    });
  }, before);

  await page.locator('#template').selectOption('strict-digraph');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(strictTemplate);
  await page.keyboard.press('Control+Z');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(before);
  await page.keyboard.press('Control+Y');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(strictTemplate);
});

test('Auto-render debounces, cancels, and suppresses stale responses', async ({
  page
}) => {
  const pending = [];
  let initial = true;
  await installCommonRoutes(page, {
    render: (source, request, route) => {
      if (initial) {
        initial = false;
        return renderedSvg('Initial');
      }
      pending.push(route);
      return DEFER;
    }
  });
  await page.goto('/apps/graph-viz/');
  await page.evaluate(() => {
    const editor = window.__GVIZ_EDITOR_TEST__;
    editor.setSource('digraph debounce {}', {
      history: 'reset',
      notify: false
    });
    editor.replaceRange(17, 17, ' A');
    editor.replaceRange(19, 19, ' -> B');
    editor.replaceRange(24, 24, ' ');
  });
  await expect.poll(() => pending.length).toBe(1);
  expect(pending[0].request().postData()).toBe('digraph debounce  A -> B {}');
  await pending.shift().fulfill({
    status: 200,
    contentType: 'image/svg+xml',
    body: renderedSvg('Debounced')
  });

  await page.evaluate(() => {
    const editor = window.__GVIZ_EDITOR_TEST__;
    editor.replaceRange(editor.getSource().length, editor.getSource().length,
      '\n// cancel');
    const toggle = document.querySelector('#auto-render');
    toggle.checked = false;
    toggle.dispatchEvent(new Event('change'));
  });
  await page.waitForTimeout(450);
  expect(pending).toHaveLength(0);

  await page.evaluate(() => {
    const toggle = document.querySelector('#auto-render');
    toggle.checked = true;
    toggle.dispatchEvent(new Event('change'));
  });
  await expect.poll(() => pending.length).toBe(1);
  const first = pending.shift();
  await page.evaluate(() => {
    window.__GVIZ_EDITOR_TEST__.setSource('digraph newest {}');
  });
  await expect.poll(() => pending.length).toBe(1);
  const newest = pending.shift();
  expect(newest.request().postData()).toBe('digraph newest {}');
  await newest.fulfill({
    status: 200,
    contentType: 'image/svg+xml',
    body: renderedSvg('Newest')
  });
  await expect(page.locator('#preview title')).toHaveText('Newest');
  await first.fulfill({
    status: 200,
    contentType: 'image/svg+xml',
    body: renderedSvg('Stale')
  });
  await expect(page.locator('#preview title')).toHaveText('Newest');
});
