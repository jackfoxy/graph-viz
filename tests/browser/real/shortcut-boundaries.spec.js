const {test, expect} = require('@playwright/test');

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

async function installRoutes(page, state) {
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    const kind = route.request().url().includes('/file/dot/')
      ? 'dot'
      : 'svg';
    const path = route.request().headers()['x-graph-viz-path'];
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(path
        ? {file: true, children: []}
        : {file: false, children: [`sample.${kind}`]})
    });
  });
  await page.route('**/apps/graph-viz/render', async (route) => {
    const source = route.request().postData() || '';
    state.renders.push(source);
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: visualSvg(source)
    });
  });
  await page.route('**/apps/graph-viz/file/*/save', async (route) => {
    const kind = route.request().url().includes('/file/dot/')
      ? 'dot'
      : 'svg';
    state.saves[kind].push(route.request().postData() || '');
    await route.fulfill({status: 200, contentType: 'text/plain', body: 'ok'});
  });
  await page.route('**/docs', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'text/html',
      body: '<!doctype html><title>Graph Viz Docs</title>'
    });
  });
  await page.route('**/docs/**', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'text/html',
      body: '<!doctype html><title>Graph Viz / Users Guide</title>'
    });
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

test('Ace retains displaced and destructive editor commands', async ({
  page
}) => {
  const state = {renders: [], saves: {dot: [], svg: []}};
  await installRoutes(page, state);
  await page.goto('/apps/graph-viz/');
  const sortable = 'digraph sort {\n  z\n  a\n}';
  await setSourceAndRender(page, state, sortable);
  await page.evaluate(() => {
    window.prompt = () => 'must-not-save.dot';
    const editor = window.ace.edit(document.querySelector('#dot'));
    editor.selection.setSelectionRange({
      start: {row: 1, column: 0},
      end: {row: 2, column: 3}
    });
    editor.focus();
  });
  await page.keyboard.press('Control+Alt+s');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe('digraph sort {\n  a\n  z\n}');
  expect(state.saves.dot).toHaveLength(0);

  await page.evaluate(() => {
    const adapter = window.__GVIZ_EDITOR_TEST__;
    adapter.setSource('digraph tabs {\nAlpha\n}', {
      history: 'reset',
      notify: false
    });
    const editor = window.ace.edit(document.querySelector('#dot'));
    editor.moveCursorTo(1, 0);
    editor.clearSelection();
    editor.focus();
  });
  await page.keyboard.press('Tab');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe('digraph tabs {\n  Alpha\n}');
  await page.keyboard.press('Shift+Tab');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe('digraph tabs {\nAlpha\n}');

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

test('focus boundaries cover explorer, Help, docs, forms, and preview', async ({
  page
}) => {
  const state = {renders: [], saves: {dot: [], svg: []}};
  await installRoutes(page, state);
  await page.goto('/apps/graph-viz/');
  const source = 'digraph focus {\n  Alpha\n  Beta\n}';
  await setSourceAndRender(page, state, source);

  await page.locator('#dot-files-tab').focus();
  await page.keyboard.press('ArrowRight');
  await expect(page.locator('#svg-files-tab')).toBeFocused();

  await page.locator('#help').click();
  await expect(page.locator('#close-help')).toBeFocused();
  await expect(page.locator('#help-panel')).toHaveAttribute('role', 'dialog');
  await expect(page.locator('#help-tab')).toHaveCount(0);
  await page.keyboard.press('Escape');
  await expect(page.locator('#help-panel')).toBeHidden();
  await expect(page.locator('#help')).toBeFocused();

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
  const keyboardShortcuts = page.locator('.docs-help-group');
  await expect(keyboardShortcuts).toHaveJSProperty('open', false);
  await keyboardShortcuts.locator('summary').click();
  await expect(keyboardShortcuts).toHaveJSProperty('open', true);
  await keyboardShortcuts.locator('summary').click();
  await expect(keyboardShortcuts).toHaveJSProperty('open', false);
  await page.getByRole('link', {name: 'Users Guide'}).click();
  const docsTab = page.locator('.docs-tab').filter({hasText: 'Users Guide'});
  await expect(docsTab).toBeFocused();
  await page.keyboard.press('Escape');
  await expect(docsTab).toBeFocused();
  await page.keyboard.press('ArrowLeft');
  await expect(page.locator('#svg-files-tab')).toBeFocused();

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

  await page.locator('#dot-files-tab').click();
  const action = page.locator('#dot-files-tree .file-tree-actions').first();
  await action.click();
  await expect(page.locator('#file-context-open')).toBeFocused();
  await page.keyboard.press('Escape');
  await expect(action).toBeFocused();
});

test('Clay dialog Escape restores the invoking control', async ({page}) => {
  const state = {renders: [], saves: {dot: [], svg: []}};
  await installRoutes(page, state);
  await page.route('**/apps/graph-viz/file/dot/load', async (route) => {
    await route.fulfill({
      status: 500,
      contentType: 'text/plain',
      body: 'forced load failure'
    });
  });
  await page.goto('/apps/graph-viz/');
  await page.evaluate(() => {
    window.prompt = () => 'broken.dot';
  });
  await page.locator('#load-dot').click();
  await expect(page.locator('#clay-error-modal')).toBeVisible();
  await expect(page.locator('#close-clay-error')).toBeFocused();
  await page.keyboard.press('Escape');
  await expect(page.locator('#clay-error-modal')).toBeHidden();
  await expect(page.locator('#load-dot')).toBeFocused();
});
