const {test, expect} = require('@playwright/test');
const {installBackend} = require('./fixtures/backend.js');

function visualSvg(source) {
  const nodes = ['Alpha', 'Beta'].filter((name) => source.includes(name));
  return [
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 80">',
    '<title>Shortcut test</title>',
    ...nodes.map((name, index) => [
      `<g class="node" transform="translate(${25 + index * 50} 30)">`,
      `<title>${name}</title><ellipse rx="16" ry="10"/>`,
      `<text>${name}</text></g>`
    ].join('')),
    '</svg>'
  ].join('');
}

async function installRoutes(page, state, options = {}) {
  await installBackend(page, {
    browse: ({kind, path}) => path
      ? {file: true, children: []}
      : {file: false, children: [`sample.${kind}`]},
    render: (source) => {
      state.renders.push(source);
      return visualSvg(source);
    },
    save: ({kind, body}) => {
      state.saves[kind].push(body || '');
    },
    docs: true,
    ...options
  });
}

async function setSourceAndRender(page, state, source) {
  await page.evaluate((nextSource) => {
    const toggle = document.querySelector('#auto-render');
    toggle.checked = false;
    toggle.dispatchEvent(new Event('change'));
    window.__GVIZ_EDITOR_TEST__.setSource(nextSource, {
      history: 'reset',
      notify: false
    });
  }, source);
  state.renders.length = 0;
  await page.locator('#render').click();
  await expect.poll(() => state.renders.length).toBe(1);
  await expect(page.locator('#preview svg')).toBeVisible();
  await page.waitForTimeout(100);
  state.renders.length = 0;
}

test.beforeEach(async ({context}) => {
  await context.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
  });
});

test('application chords fire exactly once while Ace is focused', async ({
  page
}) => {
  const state = {renders: [], saves: {dot: [], svg: []}};
  await installRoutes(page, state);
  await page.goto('/apps/graph-viz/');
  const source = 'digraph shortcuts {\n  Alpha\n  Beta\n}';
  await setSourceAndRender(page, state, source);
  await page.evaluate(() => {
    window.prompt = (label) => label.startsWith('DOT')
      ? 'shortcut.dot'
      : 'shortcut.svg';
    window.ace.edit(document.querySelector('#dot')).focus();
  });

  await page.keyboard.press('Control+Enter');
  await expect.poll(() => state.renders.length).toBe(1);
  await page.waitForTimeout(100);
  expect(state.renders).toEqual([source]);
  expect(await page.evaluate(() => document.fullscreenElement)).toBeNull();

  await page.keyboard.press('Control+s');
  await expect.poll(() => state.saves.dot.length).toBe(1);
  expect(state.saves.dot).toEqual([source]);
  await page.keyboard.press('Control+Shift+s');
  await expect.poll(() => state.saves.svg.length).toBe(1);
  expect(state.saves.svg).toHaveLength(1);
  expect(state.saves.svg[0]).toContain('<svg');

  await page.locator('#zoom-in').click();
  await page.waitForTimeout(50);
  await page.evaluate(() => {
    const svg = document.querySelector('#preview svg');
    window.__GVIZ_VIEW_MUTATIONS__ = 0;
    window.__GVIZ_VIEW_OBSERVER__ = new MutationObserver((records) => {
      window.__GVIZ_VIEW_MUTATIONS__ += records.length;
    });
    window.__GVIZ_VIEW_OBSERVER__.observe(svg, {
      attributes: true,
      attributeFilter: ['style']
    });
    window.ace.edit(document.querySelector('#dot')).focus();
  });
  await page.keyboard.press('Control+0');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_VIEW_MUTATIONS__;
  })).toBe(1);
  await page.evaluate(() => window.__GVIZ_VIEW_OBSERVER__.disconnect());

  await page.locator('#zoom-in').click();
  await page.waitForTimeout(50);
  await page.evaluate(() => {
    const svg = document.querySelector('#preview svg');
    window.__GVIZ_VIEW_MUTATIONS__ = 0;
    window.__GVIZ_VIEW_OBSERVER__ = new MutationObserver((records) => {
      window.__GVIZ_VIEW_MUTATIONS__ += records.length;
    });
    window.__GVIZ_VIEW_OBSERVER__.observe(svg, {
      attributes: true,
      attributeFilter: ['style']
    });
    window.ace.edit(document.querySelector('#dot')).focus();
  });
  await page.keyboard.press('Control+1');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_VIEW_MUTATIONS__;
  })).toBe(1);
  await page.evaluate(() => window.__GVIZ_VIEW_OBSERVER__.disconnect());
});

//  Ace's own displaced and destructive commands are urui's to prove; what
//  remains here is what only this application can show: a keystroke that
//  reaches a selected preview node instead of the editor.
test('preview selection routes destructive keys away from Ace', async ({
  page
}) => {
  const state = {renders: [], saves: {dot: [], svg: []}};
  await installRoutes(page, state);
  await page.goto('/apps/graph-viz/');
  const source = 'digraph edit {\n  Alpha\n  Beta\n}';
  await setSourceAndRender(page, state, source);
  const alpha = page.locator('#preview .node').filter({hasText: 'Alpha'});
  await alpha.click();
  await page.keyboard.press('Escape');
  await expect(alpha).toHaveClass(/is-selected/);
  expect(await page.evaluate(() => {
    return document.activeElement.classList.contains('ace_text-input');
  })).toBe(true);

  await page.evaluate(() => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    editor.moveCursorTo(1, 2);
    editor.clearSelection();
    editor.focus();
  });
  await page.keyboard.press('Delete');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe('digraph edit {\n  lpha\n  Beta\n}');

  await setSourceAndRender(page, state, source);
  await alpha.click();
  await page.evaluate(() => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    editor.moveCursorTo(1, 3);
    editor.clearSelection();
    editor.focus();
  });
  await page.keyboard.press('Backspace');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe('digraph edit {\n  lpha\n  Beta\n}');

  await setSourceAndRender(page, state, source);
  await alpha.click();
  await alpha.focus();
  await page.keyboard.press('Delete');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe('digraph edit {\n  Beta\n}');
});

//  The generic half of this boundary set — explorer tabs, the Help panel,
//  the docs tree's own nesting, the file-tree context menu — is urui's.
//  What stays is this application's own help links and preview surface.
test('help links, the node form, and the preview keep focus', async ({
  page
}) => {
  const state = {renders: [], saves: {dot: [], svg: []}};
  await installRoutes(page, state);
  await page.goto('/apps/graph-viz/');
  const source = 'digraph focus {\n  Alpha\n  Beta\n}';
  await setSourceAndRender(page, state, source);

  await page.locator('#help').click();
  await expect(page.locator('#docs-help-content')).toBeVisible();
  for (const [name, path] of [
    ['DOT Syntax LLM Skill', 'gviz-dot-syntax'],
    ['Gall API LLM Skill', 'gviz-gall-api'],
    ['Common Patterns LLM Skill', 'gviz-patterns']
  ]) {
    const link = page.getByRole('link', {name, exact: true});
    await expect(link).toHaveAttribute('href', new RegExp(`${path}$`));
    await expect(link).toHaveAttribute('target', '_blank');
  }
  //  this application's documentation tree names its own groups
  const dotLanguage = page.locator('.docs-help-group').filter({
    has: page.locator('summary').filter({hasText: /^DOT Language Reference$/})
  });
  await dotLanguage.locator('summary').first().click();
  await expect(dotLanguage).toHaveJSProperty('open', true);
  await page.keyboard.press('Escape');

  await page.locator('#preview .node').filter({hasText: 'Alpha'}).click();
  await page.locator('#new-node-name').fill('Draft');
  await page.keyboard.press('Escape');
  await page.keyboard.press('Backspace');
  await page.keyboard.press('Delete');
  await expect(page.locator('#new-node-name')).toHaveValue('Draf');
  await expect(page.locator('#preview .node').filter({hasText: 'Alpha'}))
    .toHaveClass(/is-selected/);
  const selectedAlpha = page.locator('#preview .node')
    .filter({hasText: 'Alpha'});
  await selectedAlpha.focus();
  await page.keyboard.press('Escape');
  await expect(selectedAlpha).not.toHaveClass(/is-selected/);
  await expect(page.locator('#preview')).toBeFocused();

  await page.locator('#zoom-in').focus();
  const before = await page.locator('#preview svg').getAttribute('style');
  await page.keyboard.press('Enter');
  await expect(page.locator('#zoom-in')).toBeFocused();
  await expect.poll(async () => {
    return page.locator('#preview svg').getAttribute('style');
  }).not.toBe(before);
});
