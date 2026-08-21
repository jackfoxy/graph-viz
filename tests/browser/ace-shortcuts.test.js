const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const manifestPath = path.join(
  __dirname,
  'ace-win-linux-shortcuts.json'
);
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));

test('manifest pins the Windows/Linux test environment', () => {
  assert.equal(manifest.scope.acePlatform, 'win');
  assert.equal(manifest.scope.hostPlatform, 'linux');
  assert.equal(manifest.scope.keyboardLayout, 'en-US');
  assert.equal(manifest.scope.status, 'inventory-only');
  assert.match(manifest.source.revision, /^[0-9a-f]{40}$/);
});

test('manifest accounts for every official source row', () => {
  const expectedGroups = new Map([
    ['Line Operations', 10],
    ['Selection', 21],
    ['Multicursor', 10],
    ['Go to', 20],
    ['Find/Replace', 7],
    ['Folding', 7],
    ['Other', 25]
  ]);
  const actualGroups = new Map();
  for (const row of manifest.rows) {
    actualGroups.set(row.group, (actualGroups.get(row.group) || 0) + 1);
    const expectedBindings = row.windowsLinux === '---'
      ? []
      : row.windowsLinux.split(', ').map((binding) => binding.trim());
    assert.deepEqual(row.bindings, expectedBindings, row.action);
    assert.ok(row.action, 'every row has an action');
  }
  assert.deepEqual(actualGroups, expectedGroups);
  assert.equal(manifest.rows.length, 100);
});

test('manifest preserves exclusions, alternate keys, and duplicate bindings', () => {
  const exclusions = manifest.rows.filter((row) => {
    return row.windowsLinux === '---';
  });
  assert.deepEqual(exclusions.map((row) => row.action), [
    'Split line',
    'Scroll page down',
    'Scroll page up',
    'Fold all comments',
    'Center selection'
  ]);

  const alternates = manifest.rows.filter((row) => row.bindings.length > 1);
  assert.deepEqual(alternates.map((row) => row.action), [
    'Jump to matching',
    'Select to matching',
    'Go to line start',
    'Go to line end',
    'Fold selection',
    'Unfold',
    'Redo'
  ]);

  const uses = new Map();
  for (const row of manifest.rows) {
    for (const binding of row.bindings) {
      if (!uses.has(binding)) uses.set(binding, []);
      uses.get(binding).push(`${row.group}: ${row.action}`);
    }
  }
  assert.deepEqual(uses.get('Ctrl-U'), [
    'Other: Change to upper case',
    'Other: To uppercase'
  ]);
  assert.deepEqual(uses.get('Ctrl-Shift-U'), [
    'Other: Change to lower case',
    'Other: To lowercase'
  ]);
  assert.deepEqual(uses.get('Ctrl-Shift-L'), [
    'Selection: Expand to line',
    'Multicursor: Select all from multi-selection'
  ]);
});
