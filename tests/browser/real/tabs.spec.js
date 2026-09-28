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
    browse: () => [['left', 'txt'], ['menu', 'txt'], ['preview', 'svg']],
    dotLoad: (path) => {
      state.dotLoads.push(path);
      return dotSources[path];
    },
    svgLoad: () => {
      state.svgLoads += 1;
      return renderedSvg('Loaded file');
    },
    save: ({path, body, overwrite, base}) => {
      state.saves.push({path, body, overwrite, base});
    },
    render: (source, request) => {
      state.renders.push(request.postData());
      return renderedSvg(`Render ${state.renders.length}`);
    }
  });
}

//  a store's strip is the one its %documents level declared: graph-viz
//  puts the dot store in the editor pane and the svg store in the preview
const stripFor = (kind) => {
  return kind === 'dot'
    ? '#editor-pane-document-tabs'
    : '#preview-pane-document-tabs';
};

function tabControl(page, kind, label) {
  return page.locator(`${stripFor(kind)} .document-tab-control`)
    .filter({has: page.getByRole('tab', {name: label, exact: true})});
}

//  the svg store's source/preview toggle, urui's
const display = (page, which) => {
  return page.locator(`#svg-display [data-display="${which}"]`);
};

async function useStoredSession(page) {
  await page.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
    if (!localStorage.getItem('graph-viz.session.v1')) {
      localStorage.setItem('graph-viz.session.v1', JSON.stringify({
        version: 2,
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
  await expect(svgTab.locator('.document-tab-close')).toHaveText('×');
  await page.locator('#svg-ref').click();
  const ref = page.locator('.ref-explorer-panel').last();

  await expect(display(page, 'preview')).toHaveAttribute('aria-pressed', 'true');
  await display(page, 'source').click();
  await expect(display(page, 'source')).toHaveAttribute('aria-pressed', 'true');
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
  await expect(svgTab.locator('.document-tab-close')).toHaveText('●');
  await expect(ref).toContainText('Edited file');
  await page.keyboard.press('Control+z');
  await expect(svgTab.locator('.document-tab-close')).toHaveText('×');
  await expect(ref).toContainText('Loaded file');

  await page.evaluate(() => {
    const svg = window.__GVIZ_SVG_EDITOR_TEST__;
    const source = svg.getSource();
    const start = source.indexOf('Loaded file');
    svg.replaceRange(start, start + 'Loaded file'.length, 'Edited file');
  });
  await display(page, 'preview').click();
  await expect(page.locator('#preview title')).toHaveText('Edited file');

  //  an invalid edit previews as its error, and the source is kept
  await display(page, 'source').click();
  await page.evaluate(() => {
    const svg = window.__GVIZ_SVG_EDITOR_TEST__;
    svg.replaceRange(0, svg.getSource().length, '<svg');
  });
  await display(page, 'preview').click();
  await expect(page.locator('#error')).toContainText('Invalid SVG');
  await display(page, 'source').click();
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_SVG_EDITOR_TEST__.getSource();
  })).toBe('<svg');
});

test('DOT re-render confirms before replacing edited SVG', async ({page}) => {
  const state = {dotLoads: [], svgLoads: 0, saves: [], renders: []};
  await installRoutes(page, state);
  await useStoredSession(page);
  await page.goto('/apps/graph-viz/');
  await page.locator('#render').click();
  await expect.poll(() => state.renders.length).toBe(1);
  await display(page, 'source').click();
  await page.evaluate(() => {
    const svg = window.__GVIZ_SVG_EDITOR_TEST__;
    svg.replaceRange(svg.getSource().length, svg.getSource().length,
      '\n<!-- edited -->');
  });

  //  urui's confirm dialog asks before the edits are replaced
  await page.locator('#render').click();
  await expect(page.locator('#urui-confirm')).toBeVisible();
  await page.locator('#urui-confirm-cancel').click();
  await page.waitForTimeout(100);
  expect(state.renders).toHaveLength(1);
  await expect(display(page, 'source')).toHaveAttribute('aria-pressed', 'true');

  await page.locator('#render').click();
  await expect(page.locator('#urui-confirm')).toBeVisible();
  await page.locator('#urui-confirm-ok').click();
  await expect.poll(() => state.renders.length).toBe(2);
  await expect(display(page, 'preview')).toHaveAttribute('aria-pressed', 'true');
});
