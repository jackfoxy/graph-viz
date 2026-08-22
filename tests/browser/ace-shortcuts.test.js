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
  assert.equal(manifest.scope.status, 'conflicts-finalized');
  assert.match(manifest.source.revision, /^[0-9a-f]{40}$/);
});

test('manifest finalizes Graph Viz and Ace shortcut ownership', () => {
  assert.deepEqual(
    manifest.ownership.application.map((entry) => entry.binding),
    ['Ctrl-Enter', 'Ctrl-S', 'Ctrl-Shift-S', 'Ctrl-0', 'Ctrl-1']
  );
  for (const entry of manifest.ownership.application) {
    assert.ok(entry.action);
    assert.ok(entry.resolution);
  }
  assert.deepEqual(
    manifest.ownership.contextual.map((entry) => entry.binding),
    ['Delete', 'Backspace', 'Escape', 'Tab', 'Shift-Tab', 'Ctrl-Alt-S']
  );
  for (const entry of manifest.ownership.contextual) {
    assert.ok(entry.applicationContext || entry.aceContext);
    assert.ok(entry.aceAction);
  }
  assert.deepEqual(manifest.ownership.exceptions, [{
    binding: 'Ctrl-Enter',
    aceAction: 'Enter full screen',
    directCommandTest: 'not-applicable',
    reason: 'The pinned standalone Ace bundle exposes no fullscreen command; '
      + 'Graph Viz preview fullscreen remains button-driven.'
  }]);
});

test('manifest accounts for each resolved official conflict', () => {
  const official = new Map();
  for (const row of manifest.rows) {
    for (const binding of row.bindings) official.set(binding, row.action);
  }
  assert.equal(official.get('Ctrl-Enter'), 'Enter full screen');
  assert.equal(official.get('Delete'), 'Delete');
  assert.equal(official.get('Tab'), 'Indent');
  assert.equal(official.get('Shift-Tab'), 'Outdent');
  assert.equal(official.get('Ctrl-Alt-S'), 'Sort lines');
  assert.equal(official.has('Ctrl-S'), false);
  assert.equal(official.has('Ctrl-Shift-S'), false);
  assert.equal(official.has('Ctrl-0'), false);
  assert.equal(official.has('Ctrl-1'), false);
});

test('manifest records complete work unit 9 shortcut coverage', () => {
  assert.deepEqual(manifest.coverage.workUnit9, {
    status: 'real-browser',
    groups: ['Line Operations', 'Selection', 'Go to'],
    sourceRows: 51,
    bindingExecutions: 52,
    exclusions: [
      'Line Operations: Split line',
      'Go to: Scroll page down',
      'Go to: Scroll page up'
    ],
    duplicates: [{
      binding: 'Ctrl-Shift-P',
      rows: [
        'Selection: Select to matching bracket',
        'Selection: Select to matching'
      ]
    }, {
      binding: 'Ctrl-P',
      rows: [
        'Selection: Jump to matching',
        'Go to: Go to matching bracket'
      ]
    }]
  });
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
