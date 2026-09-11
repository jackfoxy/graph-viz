const {test, expect} = require('@playwright/test');
const sessionV1 = require('../fixtures/session-v1.json');
const {installBackend, DEFER} = require('./fixtures/backend.js');

const claySource = 'digraph clay { Saved -> Reloaded }';
const editedSource = `${claySource}\n// edited`;
const renderedSvg = [
  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
  '<title>Rendered</title><circle cx="5" cy="5" r="4"/></svg>'
].join('');

function documentLabels(page, kind) {
  return page.locator(`#${kind}-document-tabs .document-tab`)
    .allTextContents();
}

test('v1 session restores and survives Clay edit, save, and reload', async ({
  context,
  page
}) => {
  const saves = [];
  let initialRender;
  await context.addInitScript((session) => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
    if (!localStorage.getItem('graph-viz.session.v1')) {
      localStorage.setItem('graph-viz.session.v1', JSON.stringify(session));
    }
  }, sessionV1);
  await installBackend(page, {
    docs: true,
    browse: ({kind, path}) => {
      if (kind !== 'dot') return {file: false, children: []};
      if (!path) return {file: false, children: ['clay']};
      if (path === 'clay') return {file: false, children: ['txt']};
      return {file: path === 'clay/txt', children: []};
    },
    dotLoad: claySource,
    save: (request) => saves.push(request),
    render: (_source, _request, route) => {
      if (!initialRender) {
        initialRender = route;
        return DEFER;
      }
      return renderedSvg;
    }
  });

  await page.goto('/apps/graph-viz/');
  await expect.poll(() => documentLabels(page, 'dot')).toEqual([
    'pipeline.dot',
    'overview.dot'
  ]);
  await expect(page.getByRole('tab', {name: 'overview.dot', exact: true}))
    .toHaveAttribute('aria-selected', 'true');
  await expect(page.locator('#dot-document-tabs .active .document-tab-close'))
    .toHaveText('O');
  await expect.poll(() => page.locator('#preview svg')
    .evaluate((svg) => svg.style.transform))
    .toBe('translate(-48px, 22px) scale(1.35)');
  await expect(page.locator('[data-explorer-view="docs-1"]'))
    .toHaveAttribute('aria-selected', 'true');

  await page.locator('#auto-render').evaluate((toggle) => {
    toggle.checked = false;
    toggle.dispatchEvent(new Event('change'));
  });
  await expect.poll(() => Boolean(initialRender)).toBe(true);
  await initialRender.fulfill({
    status: 200,
    contentType: 'image/svg+xml',
    body: renderedSvg
  });
  await page.locator('#dot-files-tab').click();
  await page.locator('[data-path="clay/txt"]').click();
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(claySource);

  await page.evaluate(() => {
    const editor = window.__GVIZ_EDITOR_TEST__;
    editor.replaceRange(
      editor.getSource().length,
      editor.getSource().length,
      '\n// edited'
    );
  });
  await expect(page.locator('#dot-document-tabs .active .document-tab-close'))
    .toHaveText('O');
  await page.locator('#save-dot').click();
  await expect.poll(() => saves.length).toBe(1);
  expect(saves[0]).toMatchObject({
    kind: 'dot',
    path: 'clay/txt',
    body: editedSource
  });
  await expect(page.locator('#dot-document-tabs .active .document-tab-close'))
    .toHaveText('X');
  await expect.poll(() => page.evaluate(() => {
    const session = JSON.parse(localStorage.getItem('graph-viz.session.v1'));
    return session.dotTabs.find((tab) => tab.path === 'clay/txt')?.source;
  })).toBe(editedSource);

  await page.reload();
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(editedSource);
  await expect.poll(() => documentLabels(page, 'dot')).toEqual([
    'pipeline.dot',
    'overview.dot',
    'clay.dot'
  ]);
  await expect(page.getByRole('tab', {name: 'clay.dot', exact: true}))
    .toHaveAttribute('aria-selected', 'true');
});
