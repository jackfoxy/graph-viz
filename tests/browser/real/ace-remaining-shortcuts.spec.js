const assert = require('node:assert/strict');
const {test, expect} = require('@playwright/test');
const manifest = require('../ace-win-linux-shortcuts.json');

const groups = ['Multicursor', 'Find/Replace', 'Folding', 'Other'];
const commandByAction = {
  'Add cursor above': 'addCursorAbove',
  'Add cursor below': 'addCursorBelow',
  'Add next occurrence to multi-selection': 'selectMoreAfter',
  'Add previous occurrence to multi-selection': 'selectMoreBefore',
  'Move multicursor from current line to the line above':
    'addCursorAboveSkipCurrent',
  'Move multicursor from current line to the line below':
    'addCursorBelowSkipCurrent',
  'Remove current occurrence from multi-selection and move to next':
    'selectNextAfter',
  'Remove current occurrence from multi-selection and move to previous':
    'selectNextBefore',
  'Select all from multi-selection': 'expandtoline',
  'Align cursors': 'alignCursors',
  'Find next': 'findnext',
  'Find previous': 'findprevious',
  'Find all': 'findAll',
  'Select or find next': 'selectOrFindNext',
  'Select or find previous': 'selectOrFindPrevious',
  'Toggle fold widget': 'toggleFoldWidget',
  'Toggle parent fold widget': 'toggleParentFoldWidget',
  'Fold selection': 'fold',
  Unfold: 'unfold',
  'Fold all': 'foldOther',
  'Unfold all': 'unfoldall',
  Indent: 'indent',
  'Block indent': 'blockindent',
  Outdent: 'outdent',
  'Block outdent': 'blockoutdent',
  'Toggle comment': 'togglecomment',
  'Toggle block comment': 'toggleBlockComment',
  'Transpose letters': 'transposeletters',
  'Change to lower case': 'tolowercase',
  'Change to upper case': 'touppercase',
  Delete: 'del',
  'To uppercase': 'touppercase',
  'To lowercase': 'tolowercase',
  'Sort lines': 'sortlines',
  'Modify number up': 'modifyNumberUp',
  'Modify number down': 'modifyNumberDown',
  'Format selection (Beautify)': 'beautify'
};
const customActions = new Set([
  'Find',
  'Replace',
  'Open command palette',
  'Undo',
  'Redo',
  'Show the settings menu',
  'Enter full screen',
  'Overwrite',
  'Macros replay',
  'Macros recording'
]);

function rowsFor(group) {
  return manifest.rows.filter((row) => row.group === group);
}

function selection(startRow, startColumn, endRow, endColumn) {
  return {
    start: {row: startRow, column: startColumn},
    end: {row: endRow, column: endColumn}
  };
}

function occurrenceFixture(action) {
  const source = 'Alpha one Alpha two Alpha';
  if (action.includes('previous')) {
    return {source, selection: selection(0, 20, 0, 25)};
  }
  return {source, selection: selection(0, 0, 0, 5)};
}

function multiFixture(action) {
  if (action === 'Add next occurrence to multi-selection'
    || action === 'Add previous occurrence to multi-selection') {
    return occurrenceFixture(action);
  }
  if (action.startsWith('Remove current occurrence')) {
    const source = 'Alpha one Alpha two Alpha';
    const ranges = action.endsWith('next')
      ? [selection(0, 0, 0, 5), selection(0, 10, 0, 15)]
      : [selection(0, 10, 0, 15), selection(0, 20, 0, 25)];
    return {source, ranges};
  }
  if (action === 'Select all from multi-selection') {
    return {
      source: 'zero\nalpha\nbeta\ngamma',
      ranges: [selection(1, 2, 1, 2), selection(2, 3, 2, 3)]
    };
  }
  if (action === 'Align cursors') {
    return {
      source: 'a\nbbb\ncc',
      ranges: [selection(0, 1, 0, 1), selection(1, 3, 1, 3),
        selection(2, 2, 2, 2)]
    };
  }
  return {
    source: 'zero\nalpha\nbeta\ngamma',
    cursor: {row: 2, column: 3}
  };
}

function findFixture(action) {
  const source = 'Alpha one Alpha two Alpha';
  if (action === 'Find previous' || action === 'Select or find previous') {
    return {
      source,
      selection: selection(0, 10, 0, 15),
      searchNeedle: 'Alpha'
    };
  }
  return {
    source,
    selection: selection(0, 0, 0, 5),
    searchNeedle: 'Alpha'
  };
}

function foldSource() {
  return [
    'digraph folds {',
    '  subgraph cluster_a {',
    '    Alpha',
    '    Beta',
    '  }',
    '  subgraph cluster_b {',
    '    Gamma',
    '  }',
    '}'
  ].join('\n');
}

function foldFixture(action) {
  if (action === 'Fold selection') {
    return {
      source: foldSource(),
      selection: selection(1, 0, 4, 3)
    };
  }
  if (action === 'Unfold' || action === 'Unfold all') {
    return {
      source: foldSource(),
      cursor: {row: 0, column: 0},
      preFoldAll: true
    };
  }
  if (action === 'Toggle parent fold widget' || action === 'Fold all') {
    return {source: foldSource(), cursor: {row: 2, column: 4}};
  }
  return {source: foldSource(), cursor: {row: 0, column: 0}};
}

function otherFixture(action) {
  if (action === 'Outdent' || action === 'Block outdent') {
    return {
      source: 'digraph indent {\n    Alpha\n    Beta\n}',
      selection: selection(1, 0, 2, 8)
    };
  }
  if (action === 'Indent' || action === 'Block indent') {
    return {
      source: 'digraph indent {\n  Alpha\n  Beta\n}',
      selection: selection(1, 0, 2, 6)
    };
  }
  if (action === 'Toggle comment') {
    return {
      source: 'digraph comments {\n  Alpha\n  Beta\n}',
      selection: selection(1, 0, 2, 6)
    };
  }
  if (action === 'Toggle block comment') {
    return {
      source: 'digraph comments {\n  Alpha -> Beta\n}',
      selection: selection(1, 2, 1, 15)
    };
  }
  if (action === 'Transpose letters') {
    return {source: 'abcd', cursor: {row: 0, column: 2}};
  }
  if (action.includes('lower case') || action === 'To lowercase') {
    return {source: 'ALPHA', selection: selection(0, 0, 0, 5)};
  }
  if (action.includes('upper case') || action === 'To uppercase') {
    return {source: 'alpha', selection: selection(0, 0, 0, 5)};
  }
  if (action === 'Delete') {
    return {source: 'Alpha', cursor: {row: 0, column: 0}};
  }
  if (action === 'Sort lines') {
    return {
      source: 'zeta\nalpha\nbeta',
      selection: selection(0, 0, 2, 4)
    };
  }
  if (action === 'Modify number up' || action === 'Modify number down') {
    return {source: 'value=41', cursor: {row: 0, column: 7}};
  }
  if (action === 'Format selection (Beautify)') {
    return {
      source: 'digraph{Alpha->Beta;Beta->Gamma}',
      selection: selection(0, 0, 0, 34)
    };
  }
  return {source: 'digraph other {\n  Alpha\n}', cursor: {row: 1, column: 4}};
}

function fixtureFor(group, action) {
  if (group === 'Multicursor') return multiFixture(action);
  if (group === 'Find/Replace') return findFixture(action);
  if (group === 'Folding') return foldFixture(action);
  return otherFixture(action);
}

function relevantFields(group) {
  if (group === 'Folding') return ['folds'];
  return ['source', 'cursor', 'ranges', 'inMultiSelectMode'];
}

function pick(state, fields) {
  return Object.fromEntries(fields.map((field) => [field, state[field]]));
}

async function readState(page) {
  return page.evaluate(() => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    const ranges = editor.selection.getAllRanges().map((range) => ({
      start: {row: range.start.row, column: range.start.column},
      end: {row: range.end.row, column: range.end.column}
    }));
    return {
      source: editor.getValue(),
      cursor: editor.getCursorPosition(),
      ranges,
      inMultiSelectMode: Boolean(editor.inMultiSelectMode),
      folds: editor.session.getAllFolds().map((fold) => ({
        start: {row: fold.start.row, column: fold.start.column},
        end: {row: fold.end.row, column: fold.end.column},
        placeholder: fold.placeholder
      })),
      overwrite: editor.getOverwrite(),
      recording: Boolean(editor.commands.recording)
    };
  });
}

async function configureEditor(page, fixture) {
  await page.evaluate((next) => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    if (editor.commands.recording) editor.commands.toggleRecording(editor);
    editor.commands.macro = undefined;
    editor.exitMultiSelectMode();
    editor.session.unfold();
    window.__GVIZ_EDITOR_TEST__.setSource(next.source, {
      history: 'reset',
      notify: false
    });
    if (next.searchNeedle) editor.find(next.searchNeedle);
    const AceRange = window.ace.require('ace/range').Range;
    const makeRange = (range) => new AceRange(
      range.start.row,
      range.start.column,
      range.end.row,
      range.end.column
    );
    if (next.ranges) {
      editor.selection.setSelectionRange(makeRange(next.ranges[0]), false);
      for (const range of next.ranges.slice(1)) {
        editor.selection.addRange(makeRange(range), false);
      }
    } else if (next.selection) {
      editor.selection.setSelectionRange(makeRange(next.selection), false);
    } else {
      editor.moveCursorTo(next.cursor.row, next.cursor.column);
      editor.clearSelection();
    }
    if (next.preFoldAll) editor.session.foldAll();
    editor.resize(true);
    editor.focus();
  }, fixture);
  return readState(page);
}

async function pressBinding(page, binding) {
  const parts = binding.split('-');
  const keyName = parts.pop();
  const modifiers = parts.map((part) => {
    return part === 'Ctrl' ? 'Control' : part;
  });
  const aliases = {
    Left: 'ArrowLeft',
    Right: 'ArrowRight',
    Up: 'ArrowUp',
    Down: 'ArrowDown'
  };
  for (const modifier of modifiers) await page.keyboard.down(modifier);
  try {
    await page.keyboard.press(aliases[keyName] || keyName);
  } finally {
    for (const modifier of modifiers.reverse()) {
      await page.keyboard.up(modifier);
    }
  }
}

async function compareWithCommand(page, row, binding) {
  const fixture = fixtureFor(row.group, row.action);
  const fields = relevantFields(row.group);
  const baseline = pick(await configureEditor(page, fixture), fields);
  const expected = pick(await page.evaluate((command) => {
    const editor = window.ace.edit(document.querySelector('#dot'));
    editor.execCommand(command);
    const ranges = editor.selection.getAllRanges().map((range) => ({
      start: {row: range.start.row, column: range.start.column},
      end: {row: range.end.row, column: range.end.column}
    }));
    return {
      source: editor.getValue(),
      cursor: editor.getCursorPosition(),
      ranges,
      inMultiSelectMode: Boolean(editor.inMultiSelectMode),
      folds: editor.session.getAllFolds().map((fold) => ({
        start: {row: fold.start.row, column: fold.start.column},
        end: {row: fold.end.row, column: fold.end.column},
        placeholder: fold.placeholder
      }))
    };
  }, commandByAction[row.action]), fields);
  assert.notDeepEqual(expected, baseline, `${row.action} fixture must change`);

  const reset = pick(await configureEditor(page, fixture), fields);
  assert.deepEqual(reset, baseline, `${row.action} fixture must reset exactly`);
  await pressBinding(page, binding);
  await expect.poll(async () => pick(await readState(page), fields))
    .toEqual(expected);
}

async function exerciseCustom(page, state, row, binding) {
  const fixture = fixtureFor(row.group, row.action);
  if (row.action === 'Find' || row.action === 'Replace') {
    await configureEditor(page, fixture);
    await pressBinding(page, binding);
    const search = page.locator('#dot .ace_search');
    await expect(search).toBeVisible();
    const fields = search.locator('.ace_search_field');
    await expect(fields).toHaveCount(2);
    if (row.action === 'Replace') {
      await expect(search.locator('.ace_replace_form')).toBeVisible();
      await expect(fields.nth(1)).toBeVisible();
      await expect(fields.first()).toBeFocused();
    } else {
      await expect(fields.first()).toBeFocused();
    }
    await page.keyboard.press('Escape');
    await expect(search).toBeHidden();
    return;
  }
  if (row.action === 'Open command palette') {
    await configureEditor(page, fixture);
    await pressBinding(page, binding);
    const palette = page.locator('.ace_prompt_container');
    await expect(palette).toBeVisible();
    await expect.poll(() => page.evaluate(() => {
      const prompt = document.querySelector('.ace_prompt_container');
      return prompt?.contains(document.activeElement);
    })).toBe(true);
    await page.keyboard.press('Escape');
    await expect(palette).toHaveCount(0);
    return;
  }
  if (row.action === 'Show the settings menu') {
    await configureEditor(page, fixture);
    await pressBinding(page, binding);
    const settings = page.locator('#ace_settingsmenu');
    await expect(settings).toBeVisible();
    await expect(settings.locator('.ace_optionsMenuEntry').first())
      .toBeVisible();
    await page.keyboard.press('Escape');
    await expect(settings).toHaveCount(0);
    return;
  }
  if (row.action === 'Undo') {
    await configureEditor(page, fixture);
    await page.keyboard.type('x');
    await expect.poll(async () => (await readState(page)).source)
      .not.toBe(fixture.source);
    await pressBinding(page, binding);
    await expect.poll(async () => (await readState(page)).source)
      .toBe(fixture.source);
    return;
  }
  if (row.action === 'Redo') {
    await configureEditor(page, fixture);
    await page.keyboard.type('x');
    const edited = (await readState(page)).source;
    await page.keyboard.press('Control+z');
    await expect.poll(async () => (await readState(page)).source)
      .toBe(fixture.source);
    await pressBinding(page, binding);
    await expect.poll(async () => (await readState(page)).source).toBe(edited);
    return;
  }
  if (row.action === 'Enter full screen') {
    await configureEditor(page, fixture);
    state.renders.length = 0;
    await pressBinding(page, binding);
    await expect.poll(() => state.renders.length).toBe(1);
    expect(await page.evaluate(() => document.fullscreenElement)).toBeNull();
    return;
  }
  if (row.action === 'Overwrite') {
    await configureEditor(page, fixture);
    expect((await readState(page)).overwrite).toBe(false);
    await pressBinding(page, binding);
    await expect.poll(async () => (await readState(page)).overwrite)
      .toBe(true);
    return;
  }
  if (row.action === 'Macros recording') {
    await configureEditor(page, fixture);
    await pressBinding(page, binding);
    await expect.poll(async () => (await readState(page)).recording).toBe(true);
    await pressBinding(page, binding);
    await expect.poll(async () => (await readState(page)).recording)
      .toBe(false);
    return;
  }
  if (row.action === 'Macros replay') {
    await configureEditor(page, fixture);
    await page.keyboard.press('Control+Alt+e');
    await page.keyboard.type('x');
    await page.keyboard.press('Control+Alt+e');
    const recorded = (await readState(page)).source;
    await pressBinding(page, binding);
    await expect.poll(async () => {
      const replayed = (await readState(page)).source;
      return {
        changed: replayed !== recorded,
        additions: replayed.split('x').length - recorded.split('x').length
      };
    }).toEqual({changed: true, additions: 1});
  }
}

async function exerciseBinding(page, state, row, binding) {
  if (customActions.has(row.action)) {
    await exerciseCustom(page, state, row, binding);
  } else {
    await compareWithCommand(page, row, binding);
  }
}

async function openEditor(page) {
  const state = {renders: []};
  await page.route('**/apps/graph-viz/file/*/browse', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({file: false, children: []})
    });
  });
  await page.route('**/apps/graph-viz/render', async (route) => {
    state.renders.push(route.request().postData() || '');
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
  await page.waitForFunction(() => {
    const problem = document.querySelector('#editor-load-error');
    return Boolean(window.__GVIZ_EDITOR_TEST__) || Boolean(problem?.title);
  });
  const initialization = await page.evaluate(() => ({
    ready: Boolean(window.__GVIZ_EDITOR_TEST__),
    problem: document.querySelector('#editor-load-error').title
  }));
  assert.deepEqual(initialization, {ready: true, problem: ''});
  await page.evaluate(() => {
    const toggle = document.querySelector('#auto-render');
    toggle.checked = false;
    toggle.dispatchEvent(new Event('change'));
  });
  state.renders.length = 0;
  return state;
}

test.beforeEach(async ({context}) => {
  await context.addInitScript(() => {
    window.__GVIZ_BROWSER_TEST__ = {
      acePlatform: 'win',
      keyboardLayout: 'en-US'
    };
  });
});

test('work unit 10 manifest rows are completely accounted', () => {
  const rows = manifest.rows.filter((row) => groups.includes(row.group));
  assert.equal(rows.length, 49);
  assert.equal(rows.reduce((count, row) => {
    return count + row.bindings.length;
  }, 0), 50);
  assert.deepEqual(rows.filter((row) => !row.bindings.length).map((row) => {
    return `${row.group}: ${row.action}`;
  }), [
    'Folding: Fold all comments',
    'Other: Center selection'
  ]);
  for (const row of rows.filter((item) => item.bindings.length)) {
    assert.ok(
      commandByAction[row.action] || customActions.has(row.action),
      `${row.group}: ${row.action}`
    );
  }
});

for (const group of groups) {
  test(`${group} bindings produce observable outcomes`, async ({page}) => {
    const state = await openEditor(page);
    for (const row of rowsFor(group)) {
      for (const binding of row.bindings) {
        await test.step(`${binding}: ${row.action}`, async () => {
          await exerciseBinding(page, state, row, binding);
        });
      }
    }
  });
}
