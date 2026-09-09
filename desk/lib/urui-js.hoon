::  urui-js: the shared browser runtime, as cords.
::
|%
::
++  theme-bootstrap
  ::  Read a stored theme before first paint.
  ::
  |=  [storage-key=@t version=@ud]
  ^-  @t
  =/  key  (en:json:html s+storage-key)
  =/  ver  (scot %ud version)
  %+  rap  3
  :~  '''
      (() => {
        const key =
      '''
      key
      '''
      ;
        const themes = ['system', 'light', 'dark'];
        let selected = 'system';
        try {
          const saved = JSON.parse(localStorage.getItem(key));
          const candidate = saved?.preferences?.theme;
          if (saved?.version ===
      '''
      ver
      '''
       && themes.includes(candidate)) {
            selected = candidate;
          }
        } catch (_) {
          // Storage failures must not block first paint.
        }
        const systemDark = matchMedia(
          '(prefers-color-scheme: dark)'
        ).matches;
        const effective = selected === 'system'
          ? (systemDark ? 'dark' : 'light')
          : selected;
        const root = document.documentElement;
        root.dataset.theme = selected;
        root.dataset.effectiveTheme = effective;
        root.style.colorScheme = effective;
      })();
      '''
  ==
::
++  core
  ::  Define the stable API before the consumer installs its hooks.
  ::
  ^-  @t
  %+  rap  3
  :~  '''
      (() => {
        'use strict';
        let hooks = Object.create(null);
        let booted = false;

        function invoke(group, method, args) {
          const owner = group ? hooks[group] : hooks;
          const target = owner?.[method];
          if (typeof target !== 'function') return undefined;
          return target(...args);
        }

        function methods(group, names) {
          return Object.freeze(Object.fromEntries(names.map((name) => [
            name,
            (...args) => invoke(group, name, args)
          ])));
        }

        function createAceEditorAdapter(host, options = {}) {
      '''
      editor-adapter
      '''
        }

        const editor = Object.freeze({
          ...methods('editor', ['primary', 'secondary']),
          adapter: createAceEditorAdapter
        });
        const api = {
          config: Object.freeze(window.URUI_CONFIG || {}),
          boot(next = {}) {
            if (booted) throw new Error('urui.boot called more than once');
            if (!next || typeof next !== 'object') {
              throw new TypeError('urui.boot requires a hook object');
            }
            hooks = next;
            booted = true;
            invoke(null, 'onReady', [api]);
            return api;
          },
          status: (...args) => invoke(null, 'status', args),
          tabs: methods('tabs', [
            'create', 'close', 'select', 'update', 'list', 'active'
          ]),
          editor,
          explorer: methods('explorer', [
            'show', 'refreshTree', 'addRef', 'openDocs'
          ]),
          dialog: Object.freeze({
            help: (...args) => invoke('dialog', 'help', args),
            error: (...args) => invoke('dialog', 'error', args),
            confirm: (...args) => {
              const answer = invoke('dialog', 'confirm', args);
              return answer === undefined ? window.confirm(...args) : answer;
            },
            prompt: (...args) => {
              const answer = invoke('dialog', 'prompt', args);
              return answer === undefined ? window.prompt(...args) : answer;
            }
          }),
          session: methods('session', ['save', 'queue', 'get', 'set']),
          files: methods('files', ['browse', 'load', 'save', 'delete']),
          shortcuts: methods('shortcuts', ['register']),
          layout: methods('layout', ['paneWidth', 'explorerWidth']),
          problem: methods('problem', ['show', 'clear'])
        };
        for (const value of Object.values(api)) {
          if (value && typeof value === 'object') Object.freeze(value);
        }
        window.urui = Object.freeze(api);
      })();
      '''
  ==
::
++  editor-adapter
  ::  The body of createAceEditorAdapter, shared by every consumer.
  ::
  ^-  @t
  '''
  const assets = options.assets;
  if (!window.ace || !assets) {
    throw new Error('Ace runtime or configuration did not load');
  }
  const AceRange = window.ace.require('ace/range').Range;
  const beautify = window.ace.require('ace/ext/beautify');
  if (!Array.isArray(beautify?.commands)) {
    throw new Error('Ace Beautify extension did not load');
  }
  const aceEditor = window.ace.edit(host);
  const session = aceEditor.session;
  const changeListeners = new Set();
  const textInput = aceEditor.textInput.getElement();
  let errorMarker;
  let suppressChanges = 0;

  aceEditor.setOptions({
    displayIndentGuides: true,
    fontSize: '0.9rem',
    highlightActiveLine: true,
    showPrintMargin: false,
    tabSize: 2,
    useSoftTabs: true,
    wrap: true
  });
  aceEditor.setTheme(
    document.documentElement.dataset.effectiveTheme === 'dark'
      ? assets.darkTheme
      : assets.lightTheme
  );
  session.setMode(options.mode || assets.mode);
  session.setUseWorker(assets.useWorker);
  if (options.platform) {
    aceEditor.commands.platform = options.platform;
  }
  aceEditor.commands.addCommands(beautify.commands);
  aceEditor.commands.bindKey('Ctrl-T', 'transposeletters');
  textInput.setAttribute(
    'aria-label',
    options.label || 'Source editor'
  );
  if (options.labelledBy) {
    textInput.setAttribute('aria-labelledby', options.labelledBy);
  }
  textInput.setAttribute(
    'aria-describedby',
    options.describedBy || ''
  );
  textInput.setAttribute('aria-invalid', 'false');

  function getSource() {
    return aceEditor.getValue();
  }

  function clampOffset(offset) {
    const numeric = Number.isFinite(offset) ? Math.trunc(offset) : 0;
    return Math.max(0, Math.min(getSource().length, numeric));
  }

  function getSelection() {
    const range = aceEditor.selection.getRange();
    return {
      start: positionToOffset(range.start),
      end: positionToOffset(range.end)
    };
  }

  function setSelection(start, end = start) {
    const nextStart = clampOffset(start);
    const nextEnd = Math.max(nextStart, clampOffset(end));
    const first = offsetToPosition(nextStart);
    const last = offsetToPosition(nextEnd);
    aceEditor.selection.setSelectionRange(new AceRange(
      first.row,
      first.column,
      last.row,
      last.column
    ));
  }

  function offsetToPosition(offset) {
    return session.doc.indexToPosition(clampOffset(offset), 0);
  }

  function positionToOffset(position) {
    const source = getSource();
    const lines = source.split('\n');
    const requestedRow = Number.isFinite(position?.row)
      ? Math.trunc(position.row)
      : 0;
    const row = Math.max(0, Math.min(lines.length - 1, requestedRow));
    const requestedColumn = Number.isFinite(position?.column)
      ? Math.trunc(position.column)
      : 0;
    const column = Math.max(0, Math.min(lines[row].length, requestedColumn));
    return session.doc.positionToIndex({row, column}, 0);
  }

  function notifyChange() {
    for (const listener of changeListeners) listener();
  }

  function mutate(change, notify) {
    suppressChanges += 1;
    try {
      change();
    } finally {
      suppressChanges -= 1;
    }
    if (notify !== false) notifyChange();
  }

  function isolateUndo(change) {
    const undoManager = session.getUndoManager();
    undoManager.startNewGroup();
    try {
      change();
    } finally {
      undoManager.startNewGroup();
    }
  }

  function setSource(source, options = {}) {
    mutate(() => {
      const history = options.history || 'undoable';
      if (history === 'reset') {
        session.setValue(source);
        session.getUndoManager().reset();
      } else if (history === 'undoable') {
        const last = offsetToPosition(getSource().length);
        isolateUndo(() => {
          session.replace(new AceRange(
            0,
            0,
            last.row,
            last.column
          ), source);
        });
      } else {
        throw new Error(`Unsupported editor history mode: ${history}`);
      }
      const selection = options.selection || {
        start: source.length,
        end: source.length
      };
      setSelection(selection.start, selection.end);
    }, options.notify);
  }

  function replaceRange(start, end, replacement, options = {}) {
    const rangeStart = clampOffset(start);
    const rangeEnd = Math.max(rangeStart, clampOffset(end));
    const first = offsetToPosition(rangeStart);
    const last = offsetToPosition(rangeEnd);
    mutate(() => {
      isolateUndo(() => {
        session.replace(new AceRange(
          first.row,
          first.column,
          last.row,
          last.column
        ), replacement);
      });
      const replacementEnd = rangeStart + replacement.length;
      if (options.selection && typeof options.selection === 'object') {
        setSelection(options.selection.start, options.selection.end);
      } else if (options.selection === 'select') {
        setSelection(rangeStart, replacementEnd);
      } else if (options.selection === 'start') {
        setSelection(rangeStart);
      } else {
        setSelection(replacementEnd);
      }
    }, options.notify);
  }

  function selectRange(start, end, options = {}) {
    setSelection(start, end);
    if (options.focus) aceEditor.focus();
    if (options.reveal) {
      const position = offsetToPosition(start);
      aceEditor.scrollToLine(position.row, true, true);
    }
  }

  function clearDiagnostic() {
    session.clearAnnotations();
    if (errorMarker !== undefined) session.removeMarker(errorMarker);
    errorMarker = undefined;
    textInput.setAttribute('aria-invalid', 'false');
  }

  function setDiagnostic(problem) {
    clearDiagnostic();
    if (!problem) return;
    const requestedLine = Number(problem.line);
    if (!Number.isFinite(requestedLine) || requestedLine < 1) return;
    const lines = getSource().split('\n');
    const row = Math.min(lines.length - 1, Math.trunc(requestedLine) - 1);
    const requestedColumn = Number(problem.column);
    const column = Math.max(0, Math.min(
      lines[row].length,
      Number.isFinite(requestedColumn)
        ? Math.trunc(requestedColumn) - 1
        : 0
    ));
    const endColumn = Math.min(lines[row].length, column + 1);
    const markerEnd = endColumn > column ? endColumn : column + 1;
    const message = problem.message || 'syntax error';
    session.setAnnotations([{row, column, text: message, type: 'error'}]);
    errorMarker = session.addMarker(
      new AceRange(row, column, row, markerEnd),
      'ace-error-marker',
      'text',
      false
    );
    aceEditor.selection.moveCursorTo(row, column);
    aceEditor.clearSelection();
    aceEditor.scrollToLine(row, true, true);
    textInput.setAttribute('aria-invalid', 'true');
  }

  session.on('change', () => {
    if (!suppressChanges) notifyChange();
  });

  return {
    getSource,
    setSource,
    replaceRange,
    getSelection,
    setSelection,
    selectRange,
    offsetToPosition,
    positionToOffset,
    focus: () => aceEditor.focus(),
    onChange(listener) {
      changeListeners.add(listener);
      return () => changeListeners.delete(listener);
    },
    isFocused(target) {
      const active = document.activeElement;
      return target === host || host.contains(target)
        || active === host || host.contains(active)
        || Boolean(aceEditor.isFocused?.());
    },
    setDiagnostic,
    setTheme(effective) {
      aceEditor.setTheme(
        effective === 'dark' ? assets.darkTheme : assets.lightTheme
      );
    },
    refresh: () => aceEditor.resize(true)
  };
  '''
--
