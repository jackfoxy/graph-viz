'use strict';

const assert = require('node:assert/strict');

const {settleFileTrees, settle} = require('./support.js');

// Session-restored shell chrome and the theme switcher.

module.exports = async (env) => {
  const {elements, document, themeMedia, saved, getDotSource} = env;

  assert.equal(getDotSource(), 'digraph saved { Alpha -> Beta }');
  assert.equal(elements['#workspace'].values['--editor-width'], '62%');
  assert.equal(elements['#workbench'].values['--explorer-width'], '288px');
  assert.equal(elements['#theme'].value, 'system');
  assert.equal(document.documentElement.dataset.theme, 'system');
  assert.equal(document.documentElement.dataset.effectiveTheme, 'light');
  assert.equal(document.documentElement.style.colorScheme, 'light');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/github');

  await settleFileTrees(env);
  assert.equal(elements['#auto-render'].checked, false);

  elements['#theme'].value = 'dark';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.theme, 'dark');
  assert.equal(document.documentElement.dataset.effectiveTheme, 'dark');
  assert.equal(document.documentElement.style.colorScheme, 'dark');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/monokai');
  await settle(200);
  assert.equal(JSON.parse(saved.get('graph-viz.session.v1'))
    .preferences.theme, 'dark');
  themeMedia.matches = true;
  elements['#theme'].value = 'light';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'light');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/github');
  elements['#theme'].value = 'system';
  elements['#theme'].listeners.change({});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'dark');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/monokai');
  themeMedia.matches = false;
  themeMedia.listeners.change({matches: false});
  assert.equal(document.documentElement.dataset.effectiveTheme, 'light');
  assert.equal(elements['#dot'].aceTheme, 'ace/theme/github');
};
