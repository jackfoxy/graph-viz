const {test, expect} = require('@playwright/test');

const svg = [
  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
  '<title>Rendered</title><circle cx="5" cy="5" r="4"/></svg>'
].join('');

async function installRoutes(page) {
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({file: false, children: []})
    });
  });
  await page.route('**/apps/graph-viz/render', async (route) => {
    const source = route.request().postData() || '';
    if (source.includes('INVALID')) {
      await route.fulfill({
        status: 422,
        contentType: 'application/json',
        body: JSON.stringify({
          kind: 'parse',
          line: 35,
          column: 7,
          message: 'expected DOT statement'
        })
      });
      return;
    }
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: svg
    });
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

test('explicit and system themes preserve complete editor state', async ({
  page
}) => {
  await page.emulateMedia({colorScheme: 'light'});
  await page.goto('/apps/graph-viz/');
  const base = [
    'digraph themes {',
    ...Array.from({length: 45}, (_, index) => `  node_${index}`),
    '}'
  ].join('\n');
  const edited = base.replace('  node_0', '  Xnode_0');
  await page.evaluate((source) => {
    const adapter = window.__GVIZ_EDITOR_TEST__;
    adapter.setSource(source, {history: 'reset', notify: false});
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    aceEditor.session.insert({row: 1, column: 2}, 'X');
    aceEditor.selection.setSelectionRange({
      start: {row: 31, column: 2},
      end: {row: 31, column: 9}
    });
    aceEditor.scrollToLine(31, true, true);
    aceEditor.focus();
  }, base);
  await page.waitForTimeout(100);

  const state = async () => page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    const range = aceEditor.selection.getRange();
    return {
      source: aceEditor.getValue(),
      selection: {start: range.start, end: range.end},
      scrollTop: aceEditor.session.getScrollTop(),
      scrollLeft: aceEditor.session.getScrollLeft(),
      revision: aceEditor.session.getUndoManager().getRevision(),
      focused: document.activeElement === aceEditor.textInput.getElement(),
      theme: aceEditor.getTheme()
    };
  });
  const before = await state();
  expect(before.source).toBe(edited);

  await page.evaluate(() => {
    const control = document.querySelector('#theme');
    control.value = 'dark';
    control.dispatchEvent(new Event('change'));
  });
  await expect.poll(async () => (await state()).theme)
    .toBe('ace/theme/monokai');
  expect(await state()).toEqual({...before, theme: 'ace/theme/monokai'});

  await page.evaluate(() => {
    const control = document.querySelector('#theme');
    control.value = 'system';
    control.dispatchEvent(new Event('change'));
  });
  await page.emulateMedia({colorScheme: 'dark'});
  await expect.poll(async () => (await state()).theme)
    .toBe('ace/theme/monokai');
  expect((await state()).source).toBe(edited);

  await page.evaluate(() => {
    const control = document.querySelector('#theme');
    control.value = 'light';
    control.dispatchEvent(new Event('change'));
  });
  await expect.poll(async () => (await state()).theme)
    .toBe('ace/theme/github');
  await page.emulateMedia({colorScheme: 'dark'});
  expect((await state()).theme).toBe('ace/theme/github');

  await page.keyboard.press('Control+Z');
  await expect.poll(async () => (await state()).source).toBe(base);
  await page.keyboard.press('Control+Y');
  await expect.poll(async () => (await state()).source).toBe(edited);
});

test('resize cycles preserve Ace geometry at divider extremes', async ({
  page
}) => {
  await page.setViewportSize({width: 1280, height: 850});
  await page.goto('/apps/graph-viz/');
  await page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    const resize = aceEditor.resize.bind(aceEditor);
    window.__GVIZ_WU7_RESIZES__ = 0;
    aceEditor.resize = (force) => {
      window.__GVIZ_WU7_RESIZES__ += 1;
      return resize(force);
    };
    aceEditor.gotoLine(4, 4, false);
  });

  await page.locator('#help').click();
  await expect(page.locator('#help-panel')).toBeVisible();
  await page.locator('#close-help').click();
  expect(await page.evaluate(() => {
    return window.__GVIZ_WU7_RESIZES__;
  })).toBe(0);

  for (let index = 0; index < 12; index += 1) {
    await page.locator('#splitter').press('ArrowRight');
  }
  for (let index = 0; index < 24; index += 1) {
    await page.locator('#splitter').press('ArrowLeft');
  }
  await expect.poll(() => page.evaluate(() => {
    return getComputedStyle(document.querySelector('#workspace'))
      .getPropertyValue('--editor-width').trim();
  })).toBe('25%');

  let divider = await page.locator('#explorer-resizer').boundingBox();
  await page.mouse.move(divider.x + divider.width / 2, divider.y + 20);
  await page.mouse.down();
  await page.mouse.move(1278, divider.y + 20, {steps: 4});
  await page.mouse.up();
  const maximum = await page.evaluate(() => {
    const workbench = document.querySelector('#workbench');
    return {
      actual: parseFloat(getComputedStyle(workbench)
        .getPropertyValue('--explorer-width')),
      expected: workbench.getBoundingClientRect().width - 10
    };
  });
  expect(Math.abs(maximum.actual - maximum.expected)).toBeLessThan(2);

  divider = await page.locator('#explorer-resizer').boundingBox();
  await page.mouse.move(divider.x + divider.width / 2, divider.y + 20);
  await page.mouse.down();
  await page.mouse.move(2, divider.y + 20, {steps: 4});
  await page.mouse.up();
  await expect.poll(() => page.evaluate(() => {
    return parseFloat(getComputedStyle(document.querySelector('#workbench'))
      .getPropertyValue('--explorer-width'));
  })).toBe(180);

  for (let cycle = 0; cycle < 2; cycle += 1) {
    await page.setViewportSize({width: 700, height: 900});
    await page.setViewportSize({width: 1280, height: 850});
  }
  await page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    aceEditor.gotoLine(4, 4, false);
    aceEditor.focus();
  });
  await expect.poll(() => page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    const host = document.querySelector('#dot').getBoundingClientRect();
    const container = aceEditor.renderer.container.getBoundingClientRect();
    const scroller = aceEditor.renderer.scroller.getBoundingClientRect();
    const cursor = document.querySelector('#dot .ace_cursor')
      .getBoundingClientRect();
    return {
      resizeCount: window.__GVIZ_WU7_RESIZES__,
      hostWidth: host.width,
      hostHeight: host.height,
      widthDifference: Math.abs(host.width - container.width),
      scrollerInside: scroller.left >= host.left
        && scroller.right <= host.right + 1,
      cursorVisible: cursor.left >= host.left && cursor.left <= host.right
        && cursor.top >= host.top && cursor.top <= host.bottom
    };
  })).toMatchObject({
    resizeCount: expect.any(Number),
    hostWidth: expect.any(Number),
    hostHeight: expect.any(Number),
    cursorVisible: true
  });
  const geometry = await page.evaluate(() => {
    const aceEditor = window.ace.edit(document.querySelector('#dot'));
    const host = document.querySelector('#dot').getBoundingClientRect();
    const container = aceEditor.renderer.container.getBoundingClientRect();
    const scroller = aceEditor.renderer.scroller.getBoundingClientRect();
    return {
      resizeCount: window.__GVIZ_WU7_RESIZES__,
      hostWidth: host.width,
      hostHeight: host.height,
      widthDifference: Math.abs(host.width - container.width),
      scrollerWidth: scroller.width,
      scrollerInside: scroller.left >= host.left
        && scroller.right <= host.right + 1
    };
  });
  expect(geometry.resizeCount).toBeGreaterThan(20);
  expect(geometry.hostWidth).toBeGreaterThan(100);
  expect(geometry.hostHeight).toBeGreaterThan(100);
  expect(geometry.widthDifference).toBeLessThan(2);
  expect(geometry.scrollerWidth).toBeGreaterThan(50);
  expect(geometry.scrollerInside).toBe(true);
});

test('explorer collapse toggles and persists', async ({page}) => {
  await page.setViewportSize({width: 1280, height: 850});
  await page.goto('/apps/graph-viz/');
  const collapse = page.getByRole('button', {name: 'Collapse explorer'});
  await expect(collapse).toHaveAttribute('aria-expanded', 'true');
  await expect(collapse).toHaveText('‹');
  await collapse.click();
  const expand = page.getByRole('button', {name: 'Expand explorer'});
  await expect(expand).toHaveAttribute('aria-expanded', 'false');
  await expect(expand).toHaveText('›');
  await expect(page.locator('#explorer-pane')).toHaveClass(/collapsed/);
  await expect(page.locator('#workbench')).toHaveClass(/explorer-collapsed/);
  await expect(page.locator('#explorer-resizer')).toBeDisabled();
  await expect(page.locator('#explorer-tabs')).toBeHidden();
  await expect.poll(() => page.evaluate(() => {
    const saved = JSON.parse(localStorage.getItem('graph-viz.session.v1'));
    return saved?.explorerOpen;
  })).toBe(false);

  await page.reload();
  await expect(page.getByRole('button', {name: 'Expand explorer'}))
    .toHaveAttribute('aria-expanded', 'false');
  await page.getByRole('button', {name: 'Expand explorer'}).click();
  await expect(page.getByRole('button', {name: 'Collapse explorer'}))
    .toHaveAttribute('aria-expanded', 'true');
  await expect(page.locator('#explorer-resizer')).toBeEnabled();
  await expect(page.getByRole('tab', {name: 'DOT Files'})).toBeVisible();
});

test('editor exposes label, keyboard focus, and failure semantics', async ({
  page
}) => {
  await page.goto('/apps/graph-viz/');
  await expect(page.getByRole('region', {name: 'DOT source'})).toBeVisible();
  const semantics = await page.evaluate(() => {
    const host = document.querySelector('#dot');
    const aceEditor = window.ace.edit(host);
    const input = aceEditor.textInput.getElement();
    input.focus();
    const style = getComputedStyle(host);
    return {
      labelledBy: host.getAttribute('aria-labelledby'),
      describedBy: host.getAttribute('aria-describedby'),
      inputLabelledBy: input.getAttribute('aria-labelledby'),
      inputDescribedBy: input.getAttribute('aria-describedby'),
      inputInvalid: input.getAttribute('aria-invalid'),
      inputTabIndex: input.tabIndex,
      focused: document.activeElement === input,
      outlineStyle: style.outlineStyle,
      outlineWidth: style.outlineWidth
    };
  });
  expect(semantics).toEqual({
    labelledBy: 'dot-source-heading',
    describedBy: 'error editor-load-error',
    inputLabelledBy: 'dot-source-heading',
    inputDescribedBy: 'error editor-load-error',
    inputInvalid: 'false',
    inputTabIndex: 0,
    focused: true,
    outlineStyle: 'solid',
    outlineWidth: '3px'
  });
  await expect(page.locator('#editor-load-error')).toHaveAttribute(
    'role',
    'alert'
  );
  await expect(page.locator('#error')).toHaveAttribute('role', 'alert');
  await expect(page.getByRole('separator', {
    name: 'Resize editor and preview'
  })).toHaveAttribute('tabindex', '0');
  await expect(page.getByRole('separator', {
    name: 'Resize explorer'
  })).toBeVisible();
});
