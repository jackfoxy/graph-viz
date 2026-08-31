const {test, expect} = require('@playwright/test');

function renderedSvg(title) {
  return [
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
    `<title>${title}</title><circle cx="5" cy="5" r="4"/></svg>`
  ].join('');
}

async function installRoutes(page, state) {
  await page.route('**/docs', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'text/html',
      body: '<html><title>Docs</title></html>'
    });
  });
  await page.route('**/docs/d/**', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'text/html',
      body: '<html><title>Graph Viz > Users Guide</title></html>'
    });
  });
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    const request = route.request();
    const kind = request.url().includes('/dot/') ? 'dot' : 'svg';
    const path = request.headers()['x-graph-viz-path'] || '';
    const leaf = kind === 'dot' ? 'txt' : 'svg';
    let children = [];
    if (!path) children = kind === 'dot' ? ['left', 'menu'] : ['preview'];
    else if (!path.endsWith(`/${leaf}`)) children = [leaf];
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({file: path.endsWith(`/${leaf}`), children})
    });
  });
  const dotSources = {
    'left/txt': 'digraph left { A -> B }',
    'menu/txt': 'digraph menu { C -> D }'
  };
  await page.route('**/apps/graph-viz/file/dot/load', async (route) => {
    const path = route.request().headers()['x-graph-viz-path'];
    state.dotLoads.push(path);
    await route.fulfill({
      status: 200,
      contentType: 'text/plain',
      body: dotSources[path]
    });
  });
  await page.route('**/apps/graph-viz/file/svg/load', async (route) => {
    state.svgLoads += 1;
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: renderedSvg('Loaded file')
    });
  });
  await page.route('**/apps/graph-viz/file/*/save', async (route) => {
    state.saves.push({
      url: route.request().url(),
      headers: route.request().headers(),
      body: route.request().postData()
    });
    await route.fulfill({status: 200, contentType: 'text/plain', body: 'ok'});
  });
  await page.route('**/apps/graph-viz/render', async (route) => {
    state.renders.push(route.request().postData());
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: renderedSvg(`Render ${state.renders.length}`)
    });
  });
}

function tabControl(page, kind, label) {
  return page.locator(`#${kind}-document-tabs .document-tab-control`)
    .filter({has: page.getByRole('tab', {name: label, exact: true})});
}

async function useStoredSession(page) {
  await page.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
    if (!localStorage.getItem('graph-viz.session.v1')) {
      localStorage.setItem('graph-viz.session.v1', JSON.stringify({
        version: 1,
        source: 'digraph initial {}',
        paneWidth: 44,
        preferences: {autoRender: false, theme: 'system'}
      }));
    }
  });
}

test('DOT tabs focus, render conditionally, save, and guard close', async ({
  page
}) => {
  const state = {dotLoads: [], svgLoads: 0, saves: [], renders: []};
  await installRoutes(page, state);
  await useStoredSession(page);
  await page.goto('/apps/graph-viz/');
  await expect(page.locator('[data-path="left/txt"]')).toBeVisible();
  await expect(page.locator('#close-dot-files')).toHaveCount(0);
  await expect(page.locator('#close-svg-files')).toHaveCount(0);
  const initialTabCount = await page.locator(
    '#dot-document-tabs [role="tab"]'
  ).count();
  await page.getByRole('button', {name: 'Add empty DOT tab'}).click();
  await expect(page.locator('#dot-document-tabs [role="tab"]'))
    .toHaveCount(initialTabCount + 1);
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe('');
  const addedTab = page.locator(
    '#dot-document-tabs [role="tab"][aria-selected="true"]'
  );
  await expect(addedTab).toHaveText('Untitled');
  await addedTab.locator('..').locator('.document-tab-close').click();
  await expect(page.locator('#dot-document-tabs [role="tab"]'))
    .toHaveCount(initialTabCount);

  await page.locator('[data-path="left/txt"]').click();
  await page.locator('#render').click();
  await expect.poll(() => state.renders.length).toBe(1);
  await expect(page.locator('#preview title')).toHaveText('Render 1');
  await expect(tabControl(page, 'svg', 'left.svg')
    .locator('.document-tab-close')).toHaveText('O');
  page.once('dialog', (dialog) => dialog.accept('rendered/output'));
  await page.evaluate(() => document.querySelector('#save-svg').click());
  await expect.poll(() => state.saves.length).toBe(1);
  await expect(tabControl(page, 'svg', 'output')
    .locator('.document-tab-close')).toHaveText('X');
  await page.locator('[data-path="menu/txt"]').click();
  await expect(page.getByRole('tab', {name: 'menu.dot'}))
    .toHaveAttribute('aria-selected', 'true');
  expect(state.renders).toHaveLength(1);
  await expect(page.locator('#preview title')).toHaveText('Render 1');

  await page.locator('[data-path="left/txt"]').click();
  expect(state.dotLoads).toEqual(['left/txt', 'menu/txt']);
  await expect(page.getByRole('tab', {name: 'left.dot'}))
    .toHaveAttribute('aria-selected', 'true');

  await page.evaluate(() => {
    const editor = window.__GVIZ_EDITOR_TEST__;
    editor.replaceRange(editor.getSource().length, editor.getSource().length,
      '\n// changed');
  });
  await expect(tabControl(page, 'dot', 'left.dot')
    .locator('.document-tab-close')).toHaveText('O');

  await page.evaluate(() => document.querySelector('#save-dot').click());
  await expect.poll(() => state.saves.length).toBe(2);
  expect(state.saves[1].headers['x-graph-viz-path']).toBe('left/txt');
  expect(state.saves[1].headers['x-graph-viz-overwrite']).toBe('true');
  await expect(tabControl(page, 'dot', 'left.dot')
    .locator('.document-tab-close')).toHaveText('X');

  await page.evaluate(() => {
    const editor = window.__GVIZ_EDITOR_TEST__;
    editor.replaceRange(editor.getSource().length, editor.getSource().length,
      '\n// dirty');
  });
  page.once('dialog', (dialog) => dialog.dismiss());
  await tabControl(page, 'dot', 'left.dot')
    .locator('.document-tab-close').click();
  await expect(page.getByRole('tab', {name: 'left.dot'})).toBeVisible();
  page.once('dialog', (dialog) => dialog.accept());
  await tabControl(page, 'dot', 'left.dot')
    .locator('.document-tab-close').click();
  await expect(page.getByRole('tab', {name: 'left.dot'})).toHaveCount(0);

  for (const label of ['menu.dot', 'Untitled']) {
    await tabControl(page, 'dot', label)
      .locator('.document-tab-close').click();
  }
  await expect(page.getByRole('tab', {name: 'Untitled'})).toHaveCount(1);
  await expect(page.getByRole('tab', {name: 'Untitled'}))
    .toHaveAttribute('aria-selected', 'true');
});

test('tab strips show thin horizontal scrollbars only on overflow', async ({
  page
}) => {
  const state = {dotLoads: [], svgLoads: 0, saves: [], renders: []};
  await installRoutes(page, state);
  await useStoredSession(page);
  await page.goto('/apps/graph-viz/');
  const metrics = await page.evaluate(() => {
    const selectors = [
      '#explorer-tabs',
      '#dot-document-tabs',
      '#svg-document-tabs'
    ];
    return selectors.map((selector) => {
      const strip = document.querySelector(selector);
      const initialOverflow = strip.scrollWidth > strip.clientWidth;
      const source = strip.firstElementChild;
      let copies = 0;
      while (strip.scrollWidth <= strip.clientWidth && copies < 20) {
        const clone = source.cloneNode(true);
        clone.dataset.scrollTest = 'true';
        clone.removeAttribute('id');
        clone.querySelectorAll('[id]').forEach((node) => {
          node.removeAttribute('id');
        });
        strip.append(clone);
        copies += 1;
      }
      const overflow = strip.scrollWidth > strip.clientWidth;
      const overflowX = getComputedStyle(strip).overflowX;
      const scrollbarHeight = parseFloat(
        getComputedStyle(strip, '::-webkit-scrollbar').height
      );
      strip.querySelectorAll('[data-scroll-test]').forEach((node) => {
        node.remove();
      });
      return {
        initialOverflow,
        overflow,
        overflowX,
        restoredOverflow: strip.scrollWidth > strip.clientWidth,
        scrollbarHeight
      };
    });
  });
  for (const strip of metrics) {
    expect(strip.initialOverflow).toBe(false);
    expect(strip.overflow).toBe(true);
    expect(strip.overflowX).toBe('auto');
    expect(strip.restoredOverflow).toBe(false);
    expect(strip.scrollbarHeight).toBeGreaterThan(0);
    expect(strip.scrollbarHeight).toBeLessThanOrEqual(6);
  }
});

test('DOT, SVG, and explorer tab order and content persist', async ({page}) => {
  const state = {dotLoads: [], svgLoads: 0, saves: [], renders: []};
  await installRoutes(page, state);
  await useStoredSession(page);
  await page.goto('/apps/graph-viz/');
  await expect(page.locator('[data-path="left/txt"]')).toBeVisible();
  await page.locator('[data-path="left/txt"]').click();
  await page.locator('[data-path="menu/txt"]').click();

  await page.evaluate(() => {
    const autoRender = document.querySelector('#auto-render');
    autoRender.checked = true;
    autoRender.dispatchEvent(new Event('change'));
  });
  await expect.poll(() => state.renders.length).toBeGreaterThan(0);
  const rendersBeforeLeft = state.renders.length;
  await page.getByRole('tab', {name: 'left.dot'}).click();
  await expect.poll(() => state.renders.length).toBe(rendersBeforeLeft + 1);
  const rendersBeforeMenu = state.renders.length;
  await page.getByRole('tab', {name: 'menu.dot'}).click();
  await expect.poll(() => state.renders.length).toBe(rendersBeforeMenu + 1);
  await page.evaluate(() => {
    const autoRender = document.querySelector('#auto-render');
    autoRender.checked = false;
    autoRender.dispatchEvent(new Event('change'));
  });

  await page.locator('#svg-files-tab').click();
  await expect(page.locator('[data-path="preview/svg"]')).toBeVisible();
  await page.locator('[data-path="preview/svg"]').click();
  await expect(page.getByRole('tab', {name: 'preview.svg'}))
    .toHaveAttribute('aria-selected', 'true');
  expect(state.renders).toHaveLength(rendersBeforeMenu + 1);
  await expect(page.locator('#auto-render')).not.toBeChecked();

  await tabControl(page, 'dot', 'menu.dot').dragTo(
    tabControl(page, 'dot', 'left.dot'),
    {targetPosition: {x: 1, y: 10}}
  );
  await tabControl(page, 'svg', 'preview.svg').dragTo(
    tabControl(page, 'svg', 'left.svg'),
    {targetPosition: {x: 1, y: 10}}
  );

  await page.locator('#help').click();
  await page.getByRole('link', {name: 'Users Guide'}).click();
  await expect(page.getByRole('tab', {name: 'Users Guide'})).toBeVisible();
  await expect(page.getByRole('tab', {name: 'Users Guide'})
    .locator('..').locator('.docs-tab-close')).toHaveText('X');
  const tabHeights = await page.evaluate(() => {
    const explorerTabs = document.querySelector('#explorer-tabs');
    const referenceTab = document.querySelector('.docs-tab');
    const referenceControl = referenceTab.parentElement;
    const labelRange = document.createRange();
    labelRange.selectNodeContents(referenceTab);
    const labelBounds = labelRange.getBoundingClientRect();
    const controlBounds = referenceControl.getBoundingClientRect();
    const permanentTab = document.querySelector('#dot-files-tab');
    const permanentRange = document.createRange();
    permanentRange.selectNodeContents(permanentTab);
    const permanentLabel = permanentRange.getBoundingClientRect();
    const permanentControl = permanentTab.getBoundingClientRect();
    return {
      explorer: explorerTabs.getBoundingClientRect().height,
      explorerOverflow: explorerTabs.scrollWidth > explorerTabs.clientWidth,
      documents: document.querySelector('#dot-document-tabs')
        .getBoundingClientRect().height,
      reference: document.querySelector('.docs-tab-control')
        .getBoundingClientRect().height,
      editor: document.querySelector(
        '#dot-document-tabs .document-tab-control'
      ).getBoundingClientRect().height,
      labelCenter: labelBounds.left + labelBounds.width / 2,
      controlCenter: controlBounds.left + controlBounds.width / 2,
      permanentLabelCenter:
        permanentLabel.top + permanentLabel.height / 2,
      permanentControlCenter:
        permanentControl.top + permanentControl.height / 2
    };
  });
  expect(tabHeights.explorerOverflow).toBe(true);
  expect(tabHeights.explorer).toBeGreaterThan(tabHeights.documents);
  expect(tabHeights.explorer - tabHeights.documents).toBeLessThanOrEqual(20);
  expect(Math.abs(
    tabHeights.reference - tabHeights.editor
  )).toBeLessThanOrEqual(1);
  expect(Math.abs(
    tabHeights.labelCenter - tabHeights.controlCenter
  )).toBeLessThanOrEqual(1);
  expect(Math.abs(
    tabHeights.permanentLabelCenter - tabHeights.permanentControlCenter
  )).toBeLessThanOrEqual(1);
  await page.locator('#svg-files-tab').locator('..').dragTo(
    page.locator('#dot-files-tab').locator('..'),
    {targetPosition: {x: 1, y: 10}}
  );
  await page.getByRole('tab', {name: 'Users Guide'}).locator('..').dragTo(
    page.locator('#svg-files-tab').locator('..'),
    {targetPosition: {x: 1, y: 10}}
  );

  await page.getByRole('tab', {name: 'menu.dot'}).click();
  await page.evaluate(() => {
    const editor = window.__GVIZ_EDITOR_TEST__;
    editor.replaceRange(editor.getSource().length, editor.getSource().length,
      '\n// persisted dirty');
  });
  await page.getByRole('tab', {name: 'preview.svg'}).click();
  await page.waitForTimeout(250);

  const dotOrder = await page.locator('#dot-document-tabs .document-tab')
    .allTextContents();
  const svgOrder = await page.locator('#svg-document-tabs .document-tab')
    .allTextContents();
  const explorerOrder = await page.locator('#explorer-tabs [role="tab"]')
    .allTextContents();
  await page.reload();

  await expect(page.getByRole('tab', {name: 'menu.dot'}))
    .toHaveAttribute('aria-selected', 'true');
  expect(await page.locator('#dot-document-tabs .document-tab')
    .allTextContents()).toEqual(dotOrder);
  expect(await page.locator('#svg-document-tabs .document-tab')
    .allTextContents()).toEqual(svgOrder);
  expect(await page.locator('#explorer-tabs [role="tab"]')
    .allTextContents()).toEqual(explorerOrder);
  await expect(tabControl(page, 'dot', 'menu.dot')
    .locator('.document-tab-close')).toHaveText('O');
  await expect(page.locator('#preview title')).toHaveText('Loaded file');
});
