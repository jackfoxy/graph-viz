const {test, expect} = require('@playwright/test');
const sessionV2 = require('../fixtures/session-v2.json');
const {installBackend, DEFER} = require('./fixtures/backend.js');

const claySource = 'digraph clay { Saved -> Reloaded }';
const editedSource = `${claySource}\n// edited`;
const renderedSvg = [
  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
  '<title>Rendered</title><circle cx="5" cy="5" r="4"/></svg>'
].join('');

//  a kind's strip is the one its %documents level declared: graph-viz
//  puts the dot kind in the editor pane and the svg kind in the preview
const stripFor = (kind) => {
  return kind === 'dot'
    ? '#editor-pane-document-tabs'
    : '#preview-pane-document-tabs';
};

function documentLabels(page, kind) {
  return page.locator(`${stripFor(kind)} .document-tab`).allTextContents();
}

//  A record from before the document stores (version 1) is ignored by
//  design; this is the store-shaped record the application writes now.
test('v2 session restores and survives Clay edit, save, and reload', async ({
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
  }, sessionV2);
  await installBackend(page, {
    docs: true,
    browse: () => [['clay', 'txt']],
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
  //  scoped to the document strip: the restored session also puts a
  //  reference tab with this label in the explorer
  await expect(page.locator(stripFor('dot'))
    .getByRole('tab', {name: 'overview.dot', exact: true}))
    .toHaveAttribute('aria-selected', 'true');
  await expect(page.locator(
    `${stripFor('dot')} .active .document-tab-close`
  )).toHaveText('●');
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
  await expect(page.locator(
    '#editor-pane-document-tabs .active .document-tab-close'
  )).toHaveText('●');
  await page.locator('#dot-save').click();
  await expect.poll(() => saves.length).toBe(1);
  expect(saves[0]).toMatchObject({
    kind: 'dot',
    path: 'clay/txt',
    body: editedSource
  });
  expect(saves[0].overwrite).toBe(false);
  expect(saves[0].base).toMatch(/^0v/);
  await expect(page.locator(
    '#editor-pane-document-tabs .active .document-tab-close'
  )).toHaveText('×');
  await expect.poll(() => page.evaluate(() => {
    const session = JSON.parse(localStorage.getItem('graph-viz.session.v1'));
    return session.dotTabs.find((tab) => {
      return tab.path?.join('/') === 'clay/txt';
    })?.text;
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
