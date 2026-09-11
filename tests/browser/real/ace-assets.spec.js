const vm = require('node:vm');
const {test, expect} = require('@playwright/test');

const aceRoot = '/apps/graph-viz/ace';

test('generated config defines the Ace object and setup calls', async ({
  request
}) => {
  const response = await request.get(`${aceRoot}/graph-viz-config.js`);
  expect(response.status()).toBe(200);
  const generated = await response.text();
  const execute = (script) => {
    const calls = [];
    const context = vm.createContext({window: {
      ace: {config: {set: (name, value) => calls.push([name, value])}}
    }});
    vm.runInContext(script, context);
    const assets = context.window.graphVizAceAssets;
    return {
      assets: JSON.parse(JSON.stringify(assets)), calls,
      frozen: Object.isFrozen(assets),
      extensionsFrozen: Object.isFrozen(assets.extensions)
    };
  };
  expect(execute(generated)).toEqual({
    assets: {
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
    calls: [
      ['basePath', aceRoot],
      ['modePath', aceRoot],
      ['themePath', aceRoot],
      ['workerPath', aceRoot],
      ['loadWorkerFromBlob', false]
    ],
    frozen: true,
    extensionsFrozen: true
  });
});
