const {test, expect} = require('@playwright/test');

const starter = [
  'digraph flow {',
  '  rankdir=LR',
  '  node [shape=box]',
  '  Start -> Plan -> Build -> Done',
  '}'
].join('\n');

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

async function installCommonRoutes(page, render = async (route) => {
  await route.fulfill({
    status: 200,
    contentType: 'image/svg+xml',
    body: renderedSvg('Rendered')
  });
}) {
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({file: false, children: []})
    });
  });
  await page.route('**/apps/graph-viz/render', render);
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

test('startup sources round-trip exactly and start clean history', async ({
  page
}) => {
  await installCommonRoutes(page);
  await page.goto('/apps/graph-viz/');
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(starter);

  const restored = 'digraph restored {\n  α -> β\n}\n';
  await page.evaluate((source) => {
    localStorage.setItem('graph-viz.session.v1', JSON.stringify({
      version: 1,
      source,
      paneWidth: 44,
      preferences: {autoRender: false, theme: 'system'}
    }));
    window.removeEventListener(
      'beforeunload',
      window.__GVIZ_BEFOREUNLOAD_TEST__
    );
  }, restored);
  await page.reload();
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(restored);

  const shared = 'strict digraph shared {\n  "🙂" -> β\n}\n';
  const encoded = Buffer.from(shared, 'utf8').toString('base64url');
  await page.goto(`/apps/graph-viz/?dot=${encoded}`);
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(shared);
  await page.locator('#dot').click();
  await page.keyboard.press('Control+Z');
  expect(await page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(shared);

  await expect.poll(() => page.evaluate(() => {
    return JSON.parse(localStorage.getItem('graph-viz.session.v1'))?.source;
  })).toBe(shared);
  expect(await page.evaluate(() => {
    return JSON.parse(localStorage.getItem('graph-viz.session.v1')).version;
  })).toBe(1);
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

test('DOT explorer opens reset history and SVG opens preserve DOT', async ({
  page
}) => {
  let renderCount = 0;
  await installCommonRoutes(page, async (route) => {
    renderCount += 1;
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: renderedSvg(`Render ${renderCount}`)
    });
  });
  await page.unroute('**/apps/graph-viz/file/*/browse');
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    const request = route.request();
    const kind = request.url().includes('/dot/') ? 'dot' : 'svg';
    const path = request.headers()['x-graph-viz-path'] || '';
    const children = path === ''
      ? (kind === 'dot' ? ['left', 'menu'] : ['preview'])
      : path.endsWith('/txt') || path.endsWith('/svg')
        ? []
        : [kind === 'dot' ? 'txt' : 'svg'];
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        file: path.endsWith('/txt') || path.endsWith('/svg'),
        children
      })
    });
  });
  const dotSources = {
    'left/txt': 'digraph left {\n  A -> B\n}\n',
    'menu/txt': 'digraph menu {\n  C -> D\n}\n'
  };
  await page.route('**/apps/graph-viz/file/dot/load', async (route) => {
    const path = route.request().headers()['x-graph-viz-path'];
    await route.fulfill({
      status: 200,
      contentType: 'text/plain',
      body: dotSources[path]
    });
  });
  const loadedSvg = renderedSvg('Loaded SVG');
  await page.route('**/apps/graph-viz/file/svg/load', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: loadedSvg
    });
  });
  await page.goto('/apps/graph-viz/');
  await expect(page.locator('[data-path="left/txt"]')).toBeVisible();

  await page.locator('[data-path="left/txt"]').click();
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(dotSources['left/txt']);
  await page.locator('#dot').click();
  await page.keyboard.press('Control+Z');
  expect(await page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(dotSources['left/txt']);

  await page.locator('[data-path="menu/txt"]').click({button: 'right'});
  await page.locator('#file-context-open').click();
  await expect.poll(() => page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(dotSources['menu/txt']);
  await page.locator('#dot').click();
  await page.keyboard.press('Control+Z');
  expect(await page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(dotSources['menu/txt']);

  await page.evaluate(() => {
    const editor = window.__GVIZ_EDITOR_TEST__;
    document.querySelector('#auto-render').checked = true;
    editor.replaceRange(editor.getSource().length, editor.getSource().length,
      '\n// queued');
  });
  await page.locator('#svg-files-tab').click();
  await expect(page.locator('[data-path="preview/svg"]')).toBeVisible();
  const dotBeforeSvg = await page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  });
  const rendersBeforeSvg = renderCount;
  await page.locator('[data-path="preview/svg"]').click();
  await expect(page.locator('#auto-render')).not.toBeChecked();
  expect(await page.evaluate(() => {
    return window.__GVIZ_EDITOR_TEST__.getSource();
  })).toBe(dotBeforeSvg);
  await page.waitForTimeout(450);
  expect(renderCount).toBe(rendersBeforeSvg);
});

test('DOT and SVG save retries preserve exact action-time bodies', async ({
  page
}) => {
  const previewSource = renderedSvg('Exact preview');
  await installCommonRoutes(page, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: previewSource
    });
  });
  const saves = {dot: [], svg: []};
  for (const kind of ['dot', 'svg']) {
    await page.route(`**/apps/graph-viz/file/${kind}/save`, async (route) => {
      saves[kind].push({
        body: route.request().postData(),
        headers: route.request().headers()
      });
      await route.fulfill({
        status: saves[kind].length === 1 ? 409 : 200,
        contentType: 'text/plain',
        body: saves[kind].length === 1 ? 'exists' : 'saved'
      });
    });
  }
  page.on('dialog', async (dialog) => {
    if (dialog.type() === 'prompt') {
      await dialog.accept(dialog.message().startsWith('DOT')
        ? 'exact/source'
        : 'exact/preview');
    } else {
      await dialog.accept();
    }
  });
  await page.goto('/apps/graph-viz/');
  const dotSource = 'digraph exact {\n  "🙂" -> β\n}\n';
  await page.evaluate((source) => {
    window.__GVIZ_EDITOR_TEST__.setSource(source, {
      history: 'reset',
      notify: false
    });
  }, dotSource);

  await page.locator('#save-dot').click();
  await expect.poll(() => saves.dot.length).toBe(2);
  await page.locator('#save-svg').click();
  await expect.poll(() => saves.svg.length).toBe(2);

  expect(saves.dot.map((request) => request.body))
    .toEqual([dotSource, dotSource]);
  expect(saves.svg.map((request) => request.body))
    .toEqual([previewSource, previewSource]);
  expect(saves.dot[0].headers['x-graph-viz-path']).toBe('exact/source');
  expect(saves.svg[0].headers['x-graph-viz-path']).toBe('exact/preview');
  expect(saves.dot[1].headers['x-graph-viz-overwrite']).toBe('true');
  expect(saves.svg[1].headers['x-graph-viz-overwrite']).toBe('true');
});

test('Auto-render debounces, cancels, and suppresses stale responses', async ({
  page
}) => {
  const pending = [];
  let initial = true;
  await installCommonRoutes(page, async (route) => {
    if (initial) {
      initial = false;
      await route.fulfill({
        status: 200,
        contentType: 'image/svg+xml',
        body: renderedSvg('Initial')
      });
      return;
    }
    pending.push(route);
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
