'use strict';

// Runs one scenario against a freshly booted application.  The application
// is a plain script that owns the global scope, so each scenario gets its
// own process; the parent runner in run-scenarios.js forks this file.

const fs = require('node:fs');

const {createEnvironment, bootApplication} = require('./doubles/index.js');

const [application, name] = process.argv.slice(2);
if (!application || !name) {
  throw new Error('usage: node run-scenario.js APP_JS SCENARIO');
}

const applicationSource = fs.readFileSync(application, 'utf8');
const scenario = require(`./scenarios/${name}.js`);

(async () => {
  const env = createEnvironment({profile: 'graph-viz'});
  bootApplication(env, applicationSource, application);
  env.editor = global.window.__GVIZ_EDITOR_TEST__;
  env.svgEditor = global.window.__GVIZ_SVG_EDITOR_TEST__;
  env.getDotSource = () => env.editor.getSource();
  env.getSvgSource = () => env.svgEditor.getSource();
  env.setDotSource = (source, notify = false) => {
    env.editor.setSource(source, {history: 'reset', notify});
  };
  env.getDotSelection = () => env.editor.getSelection();
  await scenario(env);
})().then(() => {
  process.exit(0);
}, (cause) => {
  console.error(cause);
  process.exit(1);
});
