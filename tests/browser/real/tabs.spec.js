const {test, expect} = require('@playwright/test');
const {installBackend} = require('./fixtures/backend.js');

function renderedSvg(title) {
  return [
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
    `<title>${title}</title><circle cx="5" cy="5" r="4"/></svg>`
  ].join('');
}

const dotSources = {
  'left/txt': 'digraph left { A -> B }',
  'menu/txt': 'digraph menu { C -> D }'
};

async function installRoutes(page, state) {
  await installBackend(page, {
    docs: {
      index: '<html><title>Docs</title></html>',
      pagesGlob: '**/docs/d/**',
      pages: '<html><title>Graph Viz > Users Guide</title></html>'
    },
    browse: ({kind, path}) => {
      const leaf = kind === 'dot' ? 'txt' : 'svg';
      let children = [];
      if (!path) children = kind === 'dot' ? ['left', 'menu'] : ['preview'];
      else if (!path.endsWith(`/${leaf}`)) children = [leaf];
      return {file: path.endsWith(`/${leaf}`), children};
    },
    dotLoad: (path) => {
      state.dotLoads.push(path);
      return dotSources[path];
    },
    svgLoad: () => {
      state.svgLoads += 1;
      return renderedSvg('Loaded file');
    },
    save: ({body, request}) => {
      state.saves.push({
        url: request.url(),
        headers: request.headers(),
        body
      });
    },
    render: (source, request) => {
      state.renders.push(request.postData());
      return renderedSvg(`Render ${state.renders.length}`);
    }
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

test('SVG Ace editing tracks dirty state, undo, validation, and Ref', async ({
  page
}) => {
  const state = {dotLoads: [], svgLoads: 0, saves: [], renders: []};
  await installRoutes(page, state);
  await useStoredSession(page);
  await page.goto('/apps/graph-viz/');
  await page.locator('#svg-files-tab').click();
  await page.locator('[data-path="preview/svg"]').click();
  const svgTab = tabControl(page, 'svg', 'preview.svg');
  await expect(svgTab.locator('.document-tab-close')).toHaveText('X');
  await page.locator('#add-svg-ref').click();

  const toggle = page.locator('#toggle-svg-source');
  await expect(toggle).toHaveText('Edit SVG');
  await toggle.click();
  await expect(toggle).toHaveText('View rendered');
  await expect(page.locator('#svg-source')).toHaveClass(/ace_editor/);
  await expect.poll(() => page.evaluate(() => {
    return window.ace.edit(document.querySelector('#svg-source'))
      .session.getMode().$id;
  })).toBe('ace/mode/text');

  await page.evaluate(() => {
    const svg = window.__GVIZ_SVG_EDITOR_TEST__;
    const source = svg.getSource();
    const start = source.indexOf('Loaded file');
    svg.replaceRange(start, start + 'Loaded file'.length, 'Edited file');
    svg.focus();
  });
  await expect(svgTab.locator('.document-tab-close')).toHaveText('O');
  await expect(page.locator('.ref-source')).toContainText('Edited file');
  await page.keyboard.press('Control+z');
  await expect(svgTab.locator('.document-tab-close')).toHaveText('X');
  await expect(page.locator('.ref-source')).toContainText('Loaded file');

  await page.evaluate(() => {
    const svg = window.__GVIZ_SVG_EDITOR_TEST__;
    const source = svg.getSource();
    const start = source.indexOf('Loaded file');
    svg.replaceRange(start, start + 'Loaded file'.length, 'Edited file');
  });
  await toggle.click();
  await expect(page.locator('#preview title')).toHaveText('Edited file');

  await toggle.click();
  await page.evaluate(() => {
    const svg = window.__GVIZ_SVG_EDITOR_TEST__;
    svg.replaceRange(0, svg.getSource().length, '<svg');
  });
  await toggle.click();
  await expect(toggle).toHaveAttribute('aria-pressed', 'true');
  await expect(page.locator('#svg-source')).toBeVisible();
  await expect(page.locator('#error')).toContainText('Invalid SVG');
});

test('DOT re-render confirms before replacing edited SVG', async ({page}) => {
  const state = {dotLoads: [], svgLoads: 0, saves: [], renders: []};
  await installRoutes(page, state);
  await useStoredSession(page);
  await page.goto('/apps/graph-viz/');
  await page.locator('#render').click();
  await expect.poll(() => state.renders.length).toBe(1);
  await page.locator('#toggle-svg-source').click();
  await page.evaluate(() => {
    const svg = window.__GVIZ_SVG_EDITOR_TEST__;
    svg.replaceRange(svg.getSource().length, svg.getSource().length,
      '\n<!-- edited -->');
  });

  page.once('dialog', (dialog) => dialog.dismiss());
  await page.locator('#render').click();
  await page.waitForTimeout(100);
  expect(state.renders).toHaveLength(1);
  await expect(page.locator('#toggle-svg-source'))
    .toHaveText('View rendered');

  page.once('dialog', (dialog) => dialog.accept());
  await page.locator('#render').click();
  await expect.poll(() => state.renders.length).toBe(2);
  await expect(page.locator('#toggle-svg-source')).toHaveText('Edit SVG');
});
