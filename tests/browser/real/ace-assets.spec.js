const {test, expect} = require('@playwright/test');

const aceRoot = '/apps/graph-viz/ace';
const clayJavaScriptLineLimit = 32 * 1024;
const javascriptAssets = [
  `${aceRoot}/ace.js`,
  `${aceRoot}/graph-viz-config.js`,
  `${aceRoot}/mode-dot.js`,
  `${aceRoot}/theme-github.js`,
  `${aceRoot}/theme-monokai.js`,
  `${aceRoot}/ext-beautify.js`,
  `${aceRoot}/ext-prompt.js`,
  `${aceRoot}/ext-searchbox.js`,
  `${aceRoot}/ext-settings_menu.js`
];

function emptyDirectory(route) {
  return route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify({file: false, children: []})
  });
}

test('serves and initializes the pinned Ace modules without external requests', async ({
  baseURL,
  page,
  request
}) => {
  const requested = [];
  page.on('request', (item) => requested.push(item.url()));
  await page.route('**/apps/graph-viz/file/*/browse', emptyDirectory);
  await page.route('**/apps/graph-viz/render', (route) => route.fulfill({
    status: 200,
    contentType: 'image/svg+xml',
    body: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"/>'
  }));

  for (const asset of javascriptAssets) {
    const response = await request.get(asset);
    expect(response.status(), asset).toBe(200);
    expect(response.headers()['content-type'], asset)
      .toBe('text/javascript; charset=utf-8');
    const longestLine = (await response.text())
      .split('\n')
      .reduce((longest, line) => {
        return Math.max(longest, Buffer.byteLength(line));
      }, 0);
    expect(longestLine, `${asset} has a Clay-safe line length`)
      .toBeLessThan(clayJavaScriptLineLimit);
  }
  const license = await request.get(`${aceRoot}/license.txt`);
  expect(license.status()).toBe(200);
  expect(license.headers()['content-type'])
    .toBe('text/plain; charset=utf-8');
  expect(await license.text()).toContain('Copyright (c) 2010, Ajax.org B.V.');
  expect((await request.get(`${aceRoot}/not-shipped.js`)).status()).toBe(404);

  await page.goto('/apps/graph-viz/');
  const state = await page.evaluate(async () => {
    const load = (name) => new Promise((resolve, reject) => {
      window.ace.config.loadModule(name, (module) => {
        if (module) resolve(module);
        else reject(new Error(`Ace module did not load: ${name}`));
      });
    });
    const modules = await Promise.all([
      load('ace/mode/dot'),
      load('ace/theme/github'),
      load('ace/theme/monokai'),
      load('ace/ext/beautify'),
      load('ace/ext/prompt'),
      load('ace/ext/searchbox'),
      load('ace/ext/settings_menu')
    ]);
    const [DotMode, lightTheme, darkTheme] = modules;
    const host = document.createElement('div');
    host.style.cssText = 'position:fixed;width:320px;height:160px';
    document.body.append(host);
    const editor = window.ace.edit(host);
    editor.commands.platform = 'win';
    editor.session.setUseWorker(false);
    editor.session.setMode(new DotMode.Mode());
    editor.setTheme('ace/theme/github');
    editor.setValue('digraph { Alpha -> Beta }', -1);
    const result = {
      version: window.ace.version,
      assetConfig: window.graphVizAceAssets,
      paths: Object.fromEntries([
        'basePath',
        'modePath',
        'themePath',
        'workerPath',
        'loadWorkerFromBlob'
      ].map((name) => [name, window.ace.config.get(name)])),
      platform: editor.commands.platform,
      mode: editor.session.getMode().$id,
      source: editor.getValue(),
      worker: editor.session.getUseWorker(),
      lightIsDark: lightTheme.isDark,
      darkIsDark: darkTheme.isDark,
      extensions: modules.slice(3).map((module) => typeof module)
    };
    editor.destroy();
    host.remove();
    return result;
  });

  expect(state).toEqual({
    version: '1.44.0',
    assetConfig: {
      version: '1.44.0',
      basePath: aceRoot,
      mode: 'ace/mode/dot',
      lightTheme: 'ace/theme/github',
      darkTheme: 'ace/theme/monokai',
      extensions: [
        'ace/ext/beautify',
        'ace/ext/prompt',
        'ace/ext/searchbox',
        'ace/ext/settings_menu'
      ],
      useWorker: false
    },
    paths: {
      basePath: aceRoot,
      modePath: aceRoot,
      themePath: aceRoot,
      workerPath: aceRoot,
      loadWorkerFromBlob: false
    },
    platform: 'win',
    mode: 'ace/mode/dot',
    source: 'digraph { Alpha -> Beta }',
    worker: false,
    lightIsDark: false,
    darkIsDark: true,
    extensions: ['object', 'object', 'object', 'object']
  });

  const origin = new URL(baseURL).origin;
  expect(requested.every((url) => {
    return url.startsWith('data:') || new URL(url).origin === origin;
  })).toBe(true);
  const loadedAceAssets = requested
    .map((url) => new URL(url).pathname)
    .filter((pathname) => pathname.startsWith(`${aceRoot}/`));
  expect([...new Set(loadedAceAssets)].sort()).toEqual([
    `${aceRoot}/ace.js`,
    `${aceRoot}/graph-viz-config.js`,
    `${aceRoot}/mode-dot.js`,
    `${aceRoot}/theme-github.js`,
    `${aceRoot}/theme-monokai.js`,
    `${aceRoot}/ext-beautify.js`,
    `${aceRoot}/ext-prompt.js`,
    `${aceRoot}/ext-searchbox.js`,
    `${aceRoot}/ext-settings_menu.js`
  ].sort());
});
