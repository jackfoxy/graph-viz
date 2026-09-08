'use strict';

// Browser-doubles suite.  Each scenario boots its own copy of app.js in a
// fresh process; see scenarios/index.js for the inventory.

const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const {fork} = require('node:child_process');

const scenarios = require('./scenarios/index.js');

const application = process.argv[2];
if (!application) throw new Error('usage: node gviz-web.test.js APP_JS');

const runner = path.join(__dirname, 'run-scenario.js');

// Every scenario needs its own read of the bundle, so a piped bundle is
// materialized once up front.
let target = path.resolve(application);
let scratch;
if (application === '-') {
  scratch = fs.mkdtempSync(path.join(os.tmpdir(), 'gviz-web-'));
  target = path.join(scratch, 'app.js');
  fs.writeFileSync(target, fs.readFileSync(0, 'utf8'));
}

function runScenario(name) {
  return new Promise((resolve) => {
    const child = fork(runner, [target, name], {stdio: 'inherit'});
    child.on('exit', (code) => resolve(code === 0));
  });
}

(async () => {
  const failed = [];
  for (const name of scenarios.all) {
    if (!await runScenario(name)) failed.push(name);
  }
  if (scratch) fs.rmSync(scratch, {recursive: true, force: true});
  if (failed.length) {
    console.error(`browser smoke: failed ${failed.join(', ')}`);
    process.exitCode = 1;
    return;
  }
  console.log('browser smoke: ok');
})();
