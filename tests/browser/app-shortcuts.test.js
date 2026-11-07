const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

// Graph Viz's own chords, and the proof they do not collide with the
// pinned Ace baseline in ace-win-linux-shortcuts.json.

const manifestPath = path.join(
  __dirname,
  'app-shortcuts.json'
);
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
const baseline = JSON.parse(fs.readFileSync(
  path.join(__dirname, manifest.baseline),
  'utf8'
));

test('synced baseline retains complete shortcut accounting', () => {
  const bindings = baseline.rows.flatMap((row) => row.bindings);
  const uses = new Map();
  for (const binding of bindings) {
    uses.set(binding, (uses.get(binding) || 0) + 1);
  }
  const applicationBindings = new Set(
    manifest.application.map((entry) => entry.binding)
  );
  assert.equal(baseline.rows.length, 100);
  assert.equal(bindings.length, 102);
  assert.equal(uses.size, 97);
  assert.equal(baseline.rows.filter((row) => !row.bindings.length).length, 5);
  assert.equal([...uses.values()].filter((count) => count > 1).length, 5);
  assert.deepEqual(
    [...applicationBindings].filter((binding) => uses.has(binding)),
    ['F1', 'F2', 'Ctrl-Enter']
  );
});

test('the manifest mirrors the chord table it describes', () => {
  //  The `application` array was hand-maintained and went stale the
  //  moment the table changed, with nothing to notice.  It is derived
  //  from ++shortcuts now, and this is what keeps it so.
  const {table, claims} = require('./chords.js');
  const {chords} = table(path.join(__dirname, '../..'));
  assert.deepEqual(
    manifest.application.map((entry) => entry.binding),
    chords.map((chord) => chord.binding)
  );
  for (const [index, chord] of chords.entries()) {
    const entry = manifest.application[index];
    assert.equal(entry.action, chord.label, chord.binding);
    const ace = claims(chord.binding).find((row) => row.keymap === 'ace');
    assert.equal(entry.aceAction, ace ? ace.action : null, chord.binding);
    assert.match(entry.resolution, chord.policy === 'override'
      ? /override/ : /command/, chord.binding);
  }
});

test('manifest finalizes Graph Viz and Ace shortcut ownership', () => {
  assert.deepEqual(
    manifest.application.map((entry) => entry.binding),
    [
      'F1', 'F2', 'Ctrl-Enter', 'Ctrl-S', 'Ctrl-Shift-S', 'Alt-O', 'Alt-C',
      'Ctrl-Alt-V', 'Ctrl-0', 'Ctrl-1', 'Ctrl-Shift-0'
    ]
  );
  for (const entry of manifest.application) {
    assert.ok(entry.action);
    assert.ok(entry.resolution);
  }
  assert.deepEqual(
    manifest.contextual.map((entry) => entry.binding),
    ['Delete', 'Backspace', 'Escape', 'Tab', 'Shift-Tab', 'Ctrl-Alt-S']
  );
  for (const entry of manifest.contextual) {
    assert.ok(entry.applicationContext || entry.aceContext);
    assert.ok(entry.aceAction);
  }
  assert.deepEqual(manifest.exceptions, [{
    binding: 'Ctrl-Enter',
    aceAction: 'Enter full screen',
    directCommandTest: 'not-applicable',
    reason: 'The pinned standalone Ace bundle exposes no fullscreen command; '
      + 'Graph Viz preview fullscreen remains button-driven.'
  }]);
});

test('manifest accounts for each resolved official conflict', () => {
  const official = new Map();
  for (const row of baseline.rows) {
    for (const binding of row.bindings) official.set(binding, row.action);
  }
  assert.equal(official.get('Ctrl-Enter'), 'Enter full screen');
  assert.equal(official.get('F1'), 'Open command palette');
  assert.equal(official.get('F2'), 'Toggle fold widget');
  assert.equal(official.get('Delete'), 'Delete');
  assert.equal(official.get('Tab'), 'Indent');
  assert.equal(official.get('Shift-Tab'), 'Outdent');
  assert.equal(official.get('Ctrl-Alt-S'), 'Sort lines');
  assert.equal(official.has('Ctrl-S'), false);
  assert.equal(official.has('Ctrl-Shift-S'), false);
  assert.equal(official.has('Ctrl-0'), false);
  assert.equal(official.has('Ctrl-1'), false);
});
