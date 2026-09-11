const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const {test, expect} = require('@playwright/test');

const aceRoot = '/apps/graph-viz/ace';

test('generated config preserves the legacy object and Ace setup calls', async ({
  request
}) => {
  const legacy = fs.readFileSync(
    path.join(__dirname, 'fixtures/legacy-ace-config.js'), 'utf8'
  );
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
  expect(execute(generated)).toEqual(execute(legacy));
  expect(execute(generated).frozen).toBe(true);
  expect(execute(generated).extensionsFrozen).toBe(true);
});
