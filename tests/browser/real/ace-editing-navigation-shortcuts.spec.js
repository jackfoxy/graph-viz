const assert = require('node:assert/strict');
const {test, expect} = require('@playwright/test');
const manifest = require('../ace-win-linux-shortcuts.json');

const groups = ['Line Operations', 'Selection', 'Go to'];
const commandByAction = {
  'Remove line': 'removeline',
  'Copy lines down': 'copylinesdown',
  'Copy lines up': 'copylinesup',
  'Move lines down': 'movelinesdown',
  'Move lines up': 'movelinesup',
  'Remove to line end': 'removetolineend',
  'Remove to linestart': 'removetolinestart',
  'Remove word left': 'removewordleft',
  'Remove word right': 'removewordright',
  'Select all': 'selectall',
  'Select left': 'selectleft',
  'Select right': 'selectright',
  'Select word left': 'selectwordleft',
  'Select word right': 'selectwordright',
  'Select line start': 'selectlinestart',
  'Select line end': 'selectlineend',
  'Select to line end': 'selecttolineend',
  'Select to line start': 'selecttolinestart',
  'Select up': 'selectup',
  'Select down': 'selectdown',
  'Select page up': 'selectpageup',
  'Select page down': 'selectpagedown',
  'Select to start': 'selecttostart',
  'Select to end': 'selecttoend',
  'Duplicate selection': 'duplicateSelection',
  'Select to matching bracket': 'selecttomatching',
  'Expand to matching': 'expandToMatching',
  'Jump to matching': 'jumptomatching',
  'Select to matching': 'selecttomatching',
  'Expand to line': 'expandtoline',
  'Go to left': 'gotoleft',
  'Go to right': 'gotoright',
  'Go to word left': 'gotowordleft',
  'Go to word right': 'gotowordright',
  'Go line up': 'golineup',
  'Go line down': 'golinedown',
  'Go to line start': 'gotolinestart',
  'Go to line end': 'gotolineend',
  'Go to page up': 'gotopageup',
  'Go to page down': 'gotopagedown',
  'Go to start': 'gotostart',
  'Go to end': 'gotoend',
  'Go to line...': 'gotoline',
  'Scroll line down': 'scrolldown',
  'Scroll line up': 'scrollup',
  'Go to matching bracket': 'jumptomatching',
  'Go to next error': 'goToNextError',
  'Go to previous error': 'goToPreviousError'
};
const customActions = new Set([
  'Go to line...',
  'Go to next error',
  'Go to previous error'
]);

function rowsFor(group) {
  return manifest.rows.filter((row) => row.group === group);
}

function longSource() {
  return [
    'digraph pages {',
    ...Array.from({length: 80}, (_, index) => {
      return `  line_${String(index).padStart(2, '0')}`;
    }),
    '}'
  ].join('\n');
}

function matchingFixture() {
  return {
    source: [
      'digraph match {',
      '  subgraph cluster_a {',
      '    Alpha',
      '  }',
      '}'
    ].join('\n'),
    cursor: {row: 0, column: 15}
  };
}

function fixtureFor(group, action) {
  const source = 'zero\n  alpha beta\ngamma delta\nomega';
  if (group === 'Line Operations') {
    if (action === 'Remove to line end') {
      return {source, cursor: {row: 1, column: 4}};
    }
    if (action === 'Remove to linestart'
      || action === 'Remove word left') {
      return {source, cursor: {row: 1, column: 8}};
    }
    if (action === 'Remove word right') {
      return {source, cursor: {row: 1, column: 2}};
    }
    return {source, cursor: {row: 1, column: 4}};
  }
  if (action.includes('matching') || action === 'Expand to matching') {
    return matchingFixture();
  }
  if (action === 'Select page up' || action === 'Select page down'
    || action === 'Go to page up' || action === 'Go to page down') {
    return {source: longSource(), cursor: {row: 40, column: 4}};
  }
  if (action === 'Scroll line up' || action === 'Scroll line down') {
    return {
      source: longSource(),
      cursor: {row: 40, column: 4},
      scrollTop: 360
    };
  }
  if (action === 'Go to line...') {
    return {source: longSource(), cursor: {row: 2, column: 3}};
  }
  if (action === 'Go to next error') {
    return {
      source: longSource(),
      cursor: {row: 12, column: 0},
      annotations: [
        {row: 10, column: 2, text: 'first', type: 'error'},
        {row: 25, column: 3, text: 'second', type: 'warning'}
      ]
    };
  }
  if (action === 'Go to previous error') {
    return {
      source: longSource(),
      cursor: {row: 30, column: 0},
      annotations: [
        {row: 10, column: 2, text: 'first', type: 'error'},
        {row: 25, column: 3, text: 'second', type: 'warning'}
      ]
    };
  }
  if (action === 'Duplicate selection') {
    return {
      source,
      selection: {
        start: {row: 1, column: 2},
        end: {row: 1, column: 7}
      }
    };
  }
  if (action === 'Expand to line') {
    return {
      source,
      selection: {
        start: {row: 1, column: 3},
        end: {row: 1, column: 5}
      }
    };
  }
  if (action === 'Select left' || action === 'Go to left') {
    return {source, cursor: {row: 1, column: 7}};
  }
  if (action === 'Select right' || action === 'Go to right'
    || action === 'Select word right' || action === 'Go to word right') {
    return {source, cursor: {row: 1, column: 2}};
  }
  if (action === 'Select word left' || action === 'Go to word left'
    || action === 'Select line start' || action === 'Select to line start'
    || action === 'Go to line start') {
    return {source, cursor: {row: 1, column: 8}};
  }
  if (action === 'Select line end' || action === 'Select to line end'
    || action === 'Go to line end') {
    return {source, cursor: {row: 1, column: 4}};
  }
  if (action === 'Select up' || action === 'Select down'
    || action === 'Go line up' || action === 'Go line down') {
    return {source, cursor: {row: 1, column: 4}};
  }
  return {source, cursor: {row: 1, column: 4}};
}

function relevantFields(action) {
  if (action === 'Scroll line up' || action === 'Scroll line down') {
    return ['scrollTop'];
  }
  return ['source', 'cursor', 'selection'];
}

function pick(state, fields) {
  return Object.fromEntries(fields.map((field) => [field, state[field]]));
}

async function readState(page) {
  return page.evaluate(() => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    const range = editor.selection.getRange();
    return {
      source: editor.getValue(),
      cursor: editor.getCursorPosition(),
      selection: {
        start: {row: range.start.row, column: range.start.column},
        end: {row: range.end.row, column: range.end.column},
        backwards: editor.selection.isBackwards()
      },
      scrollTop: editor.session.getScrollTop()
    };
  });
}

async function configureEditor(page, fixture) {
  await page.evaluate((next) => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    const manager = editor.session.widgetManager;
    for (let row = 0; row < editor.session.getLength(); row += 1) {
      for (const widget of manager.getWidgetsAtRow(row).slice()) {
        if (widget.type === 'errorMarker') widget.destroy();
      }
    }
    window.__GVIZ_EDITOR_TEST__.setSource(next.source, {
      history: 'reset',
      notify: false
    });
    editor.session.setAnnotations(next.annotations || []);
    if (next.selection) {
      editor.selection.setSelectionRange(next.selection, false);
    } else {
      editor.moveCursorTo(next.cursor.row, next.cursor.column);
      editor.clearSelection();
    }
    editor.resize(true);
    editor.focus();
    if (typeof next.scrollTop === 'number') {
      editor.session.setScrollTop(next.scrollTop);
    }
  }, fixture);
  return readState(page);
}

async function pressBinding(page, binding) {
  const parts = binding.split('-');
  const keyName = parts.pop();
  const modifierNames = parts.map((part) => {
    return part === 'Ctrl' ? 'Control' : part;
  });
  const keys = {
    Left: 'ArrowLeft',
    Right: 'ArrowRight',
    Up: 'ArrowUp',
    Down: 'ArrowDown'
  };
  for (const modifier of modifierNames) {
    await page.keyboard.down(modifier);
  }
  try {
    await page.keyboard.press(keys[keyName] || keyName);
  } finally {
    for (const modifier of modifierNames.reverse()) {
      await page.keyboard.up(modifier);
    }
  }
}

async function exerciseBinding(page, row, binding) {
  const fixture = fixtureFor(row.group, row.action);
  if (row.action === 'Go to line...') {
    await configureEditor(page, fixture);
    await pressBinding(page, binding);
    await expect(page.locator('.ace_prompt_container')).toBeVisible();
    await page.keyboard.type('12');
    await page.keyboard.press('Enter');
    await expect(page.locator('.ace_prompt_container')).toHaveCount(0);
    await expect.poll(async () => pick(await readState(page), [
      'source',
      'cursor',
      'selection'
    ])).toEqual({
      source: fixture.source,
      cursor: {row: 11, column: 0},
      selection: {
        start: {row: 11, column: 0},
        end: {row: 11, column: 0},
        backwards: false
      }
    });
    return;
  }
  if (row.action === 'Go to next error'
    || row.action === 'Go to previous error') {
    await configureEditor(page, fixture);
    await pressBinding(page, binding);
    const cursor = row.action === 'Go to next error'
      ? {row: 25, column: 3}
      : {row: 25, column: 3};
    await expect.poll(async () => (await readState(page)).cursor)
      .toEqual(cursor);
    return;
  }

  const fields = relevantFields(row.action);
  const baseline = pick(await configureEditor(page, fixture), fields);
  const expected = pick(await page.evaluate((command) => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    editor.execCommand(command);
    const range = editor.selection.getRange();
    return {
      source: editor.getValue(),
      cursor: editor.getCursorPosition(),
      selection: {
        start: {row: range.start.row, column: range.start.column},
        end: {row: range.end.row, column: range.end.column},
        backwards: editor.selection.isBackwards()
      },
      scrollTop: editor.session.getScrollTop()
    };
  }, commandByAction[row.action]), fields);
  assert.notDeepEqual(expected, baseline, `${row.action} fixture must change`);

  const reset = pick(await configureEditor(page, fixture), fields);
  assert.deepEqual(reset, baseline, `${row.action} fixture must reset exactly`);
  await pressBinding(page, binding);
  await expect.poll(async () => pick(await readState(page), fields))
    .toEqual(expected);
}

async function openEditor(page) {
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({file: false, children: []})
    });
  });
  await page.route('**/apps/graph-viz/render', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'image/svg+xml',
      body: [
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">',
        '<title>Shortcut fixture</title><circle cx="5" cy="5" r="4"/>',
        '</svg>'
      ].join('')
    });
  });
  await page.goto('/apps/graph-viz/');
  await page.evaluate(() => {
    const toggle = document.querySelector('#auto-render');
    toggle.checked = false;
    toggle.dispatchEvent(new Event('change'));
  });
}

test.beforeEach(async ({context}) => {
  await context.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
  });
});

test('work unit 9 manifest rows are completely accounted', () => {
  const rows = manifest.rows.filter((row) => groups.includes(row.group));
  assert.equal(rows.length, 51);
  assert.equal(rows.reduce((count, row) => {
    return count + row.bindings.length;
  }, 0), 52);
  assert.deepEqual(rows.filter((row) => !row.bindings.length).map((row) => {
    return `${row.group}: ${row.action}`;
  }), [
    'Line Operations: Split line',
    'Go to: Scroll page down',
    'Go to: Scroll page up'
  ]);
  for (const row of rows.filter((item) => item.bindings.length)) {
    assert.ok(commandByAction[row.action], `${row.group}: ${row.action}`);
  }

  const uses = new Map();
  for (const row of rows) {
    for (const binding of row.bindings) {
      if (!uses.has(binding)) uses.set(binding, []);
      uses.get(binding).push(`${row.group}: ${row.action}`);
    }
  }
  assert.deepEqual([...uses].filter(([, actions]) => actions.length > 1), [
    ['Ctrl-Shift-P', [
      'Selection: Select to matching bracket',
      'Selection: Select to matching'
    ]],
    ['Ctrl-P', [
      'Selection: Jump to matching',
      'Go to: Go to matching bracket'
    ]]
  ]);
  assert.deepEqual([...customActions].sort(), [
    'Go to line...',
    'Go to next error',
    'Go to previous error'
  ]);
});

for (const group of groups) {
  test(`${group} bindings match their exact Ace command outcomes`, async ({
    page
  }) => {
    await openEditor(page);
    for (const row of rowsFor(group)) {
      for (const binding of row.bindings) {
        await test.step(`${binding}: ${row.action}`, async () => {
          await exerciseBinding(page, row, binding);
        });
      }
    }
  });
}
