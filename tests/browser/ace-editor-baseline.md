# Ace editor baseline

This inventory describes the textarea implementation before Ace is added.
Production behavior is unchanged by this work unit.

## Source interactions

| Area | Current textarea interaction | Required adapter behavior |
|---|---|---|
| Initialization | URL source, restored session source, or starter template is assigned to `dot.value`; invalid URL input falls back to session/starter. | Set the initial document once, then establish a clean history baseline. |
| Persistence | `saveSession()` validates and reads `dot.value`; `editorChanged()` debounces storage by 150 ms. | Read current source at save time and emit one change notification per logical edit. |
| Rendering | Validation, empty-source handling, auto-render, and manual render read `dot.value`; render requests send it verbatim. | Always read current source at action time; retain debounce and stale-request suppression. |
| DOT files | Load and explorer/context-menu Open assign loaded text to `dot.value`; Save reads it verbatim. | A successful open replaces the document and establishes a clean file history baseline. |
| SVG files | Loading SVG changes only the preview and disables Auto-render. | Do not mutate DOT when an SVG file is loaded. |
| Templates | Selecting a starter assigns the complete template, focuses the editor, selects offset 0, and calls `editorChanged()`. | Treat insertion as one undoable whole-document edit; one undo restores the prior document. |
| Visual edits | Add node, draw edge, Delete, and attribute changes parse `dot.value`, compute new source, assign it, call `editorChanged()`, and render immediately. `splitEdgeStatement()` also performs an intermediate assignment. | Preserve formatting and make each user action one undo unit and one application change. |
| SVG selection | Selecting an SVG node/edge parses `dot.value`, focuses the textarea, selects absolute offsets, scrolls to the statement, and synchronizes the gutter. | Reveal/select the exact Ace range without adding history. |
| Direct editing | `input` calls `editorChanged()`; `keydown` implements Tab/Shift-Tab, paired delimiters, and skipping an existing closer. | Ace must supply equivalent editing while emitting one application change per edit. |
| Selection | Reads `selectionStart`/`selectionEnd`; writes with `setSelectionRange()` and `setRangeText()`. | Preserve absolute-offset selection and range replacement, including multiline and Unicode text. |
| Focus | Template insertion and SVG selection call `dot.focus()`. | Preserve focus ownership and keyboard continuity. |
| Error line | Parse errors set a class on `#dot`, rebuild the custom line gutter, and position a CSS error-line overlay using scroll, padding, and line height. Edits clear it. | Replace with an Ace annotation/marker and clear it on edit. |
| Scrolling | Textarea scroll synchronizes `#line-numbers`; source selection sets `scrollTop`. | Use Ace reveal/scroll APIs; no custom gutter synchronization. |
| Theme | Theme changes update document theme attributes and CSS variables; textarea colors follow CSS. | Later select matching Ace light/dark themes without changing source or history. |
| Resize | Workspace and explorer splitters update CSS custom properties; textarea flexes with `.editor-body`. | Call Ace resize as needed while preserving current splitter limits and persistence. |
| Validation | Source size/null validation reads the whole textarea for persistence, file save, and render. | Keep the same validation and exact source bytes. |

## Whole-document history boundaries

- Starter source, URL import, and session restore are mutually exclusive startup
  inputs with priority `URL > session > starter`. The chosen source becomes the
  initial clean document; undo must not cross startup.
- Opening a DOT file, including explorer left-click and context-menu Open,
  establishes a new clean document; undo must not restore the previously open
  file.
- Template insertion is an explicit edit to the current document. It is one
  history entry, so one undo restores the complete prior source and redo
  reapplies the template.
- Loading an SVG is not a DOT history boundary because it must not change DOT.
- Each visual edit is one history entry even when implementation requires
  several range changes.

## Graph Viz and Ace shortcut ownership

Existing Graph Viz behavior wins when the event applies to the application.
Later real-browser coverage must verify both the application command and the
remaining Ace command path.

| Key | Graph Viz behavior | Ace Windows/Linux default | Conflict rule |
|---|---|---|---|
| `Ctrl-Enter` | Render now. | Enter full screen. | Graph Viz renders; preview fullscreen remains button-driven. |
| `Delete` | Delete one selected SVG node/edge when focus is outside an input, textarea, or select. | Delete editor content. | Ace host must count as editor input; focused Ace receives Delete. |
| `Escape` | Close Clay error/context menu/Help tab or clear SVG selection, in that priority. | Ace overlays and transient modes may consume Escape although it is absent from the wiki table. | Open Graph Viz UI closes first; otherwise Ace receives Escape. |
| `Tab` / `Shift-Tab` | Custom textarea indent/outdent. | Ace indent/outdent. | Ace owns the focused-editor behavior with equivalent two-space indentation. |
| `Ctrl-S` | Save DOT. | No default in the official table. | Graph Viz owns it. |
| `Ctrl-Shift-S` | Save SVG. | No default in the official table. | Graph Viz owns it. |
| `Ctrl-0` | Fit preview. | No exact default (`Alt-0` folds all). | Graph Viz owns it. |
| `Ctrl-1` | Reset preview. | No default in the official table. | Graph Viz owns it. |

At this baseline the checked-in manifest was inventory only. Work unit 8
finalizes its ownership and exception records after Ace integration.

## Editor adapter contract

Work unit 3 routes application behavior through one textarea-backed adapter.
Its contract is intentionally independent of the eventual Ace implementation:

- `getSource()` and `setSource()` read or replace the complete document;
- `replaceRange()` applies one absolute-offset edit and emits one change;
- `getSelection()`, `setSelection()`, and `selectRange()` use absolute UTF-16
  offsets matching browser string and textarea selection semantics;
- `offsetToPosition()` and `positionToOffset()` convert between offsets and
  zero-based `{row, column}` positions, including multiline Unicode source;
- `focus()` and reveal options preserve editor navigation behavior;
- `onChange()` is the single application notification path for native and
  programmatic edits;
- gutter refresh, scroll synchronization, and parse-error highlighting remain
  owned by the adapter until Ace replaces them.

Whole-document startup replacement suppresses notification. File loads,
templates, visual edits, range edits, and native textarea input each notify
exactly once.

## Work unit 4 Ace implementation

The production editor is now Ace 1.44.0. The adapter retains zero-based UTF-16
absolute offsets while translating through the Ace document for selections and
range edits. Programmatic document and range changes suppress Ace's native
change event and emit one adapter notification; direct Ace edits use the
session change event.

Ace supplies its gutter, scrolling, soft-tab indentation, bracket pairing, and
active-line display. The editor uses DOT mode, two-space soft tabs, wrapping,
no worker, and no print margin. The initial document replacement remains
silent. A failed runtime or configuration load hides the unusable host and
shows an actionable alert.

## Work unit 5 lifecycle boundaries

The adapter's `setSource()` uses an explicit history mode. Startup inputs and
successful DOT file opens use `history: 'reset'`; Ace's undo manager is reset
after the complete source is installed. Templates use `history: 'undoable'`;
the whole-document replacement is isolated as one undo group, so one undo
restores the prior source and one redo reapplies the template. Other
programmatic whole-document edits default to the undoable mode.

The current shell has no DOT share or download control. Its existing URL import
and SVG copy/save paths remain the applicable share/export behavior; URL import
uses the startup reset boundary, while SVG actions read the current rendered
SVG without changing DOT.

Auto-render remains driven only by adapter change notifications and retains its
350 ms debounce. Disabling Auto-render, including by loading an SVG file,
cancels a queued render and invalidates an in-flight response. Re-enabling it
queues one render of the source read when that render action executes.

## Work unit 6 visual editing boundaries

SVG source selection continues to use absolute UTF-16 offsets at the adapter
boundary; the adapter converts them to an Ace range and reveals the range's
zero-based start row without changing source or history.

Add node, Draw edge, Delete, and attribute-form actions now calculate the
smallest single replacement between the prior and resulting DOT documents.
The adapter isolates that Ace document replacement from adjacent keyboard
groups, emits one application change, and therefore gives every visual action
one undo/redo entry. Edge-chain splitting is calculated without an intermediate
editor mutation, so an attribute edit remains one logical action.

## Work unit 7 editor surface boundaries

Parse failures use a zero-based Ace annotation and text marker translated from
the server's one-based line and column. The error cursor and viewport reveal
that location without changing history. Any source edit or successful render
clears the annotation, marker, and editor invalid state; the existing error
panel remains the full visible and announced message.

The effective light or dark application scheme selects the pinned GitHub or
Monokai Ace theme. Explicit and system scheme changes do not replace the
document or reset selection, cursor, scroll, focus, or undo history.

A `ResizeObserver` follows the Ace host, while splitter, explorer-view, and
window events request a coalesced resize. This covers restored dimensions,
divider extremes, responsive layout changes, and Help/document tab changes.
The Ace input is labelled by the visible DOT source heading, described by both
error regions, exposes invalid parse state, and retains a visible focus ring.

## Work unit 8 shortcut boundaries

Graph Viz owns exact `Ctrl-Enter`, `Ctrl-S`, `Ctrl-Shift-S`, `Ctrl-0`, and
`Ctrl-1` chords at document capture phase, so each application command fires
once even while Ace is focused. Extra modifiers are not ignored: notably,
Ace retains `Ctrl-Alt-S` for Sort Lines.

Delete and Escape actions on the rendered graph are limited to focused preview
content. Help Escape is limited to the focused explorer, while open Clay-error
and file-context overlays retain first priority and restore focus when closed.
Ace focus is detected through its host, active internal text input, and editor
focus state, so Delete, Backspace, Escape, Tab, and Shift-Tab remain editor
commands while DOT editing.

The official table calls `Ctrl-Enter` “Enter full screen,” but the pinned
standalone Ace bundle exposes no corresponding command to invoke directly.
The finalized manifest records that exception; Graph Viz preview fullscreen
remains available through its button.

## Work unit 9 editing, selection, and navigation shortcuts

Every Windows/Linux binding in the manifest's Line Operations, Selection, and
Go to groups is exercised with real Chromium keyboard events against Ace's
`win` key map. Each event's source, cursor, selection, or scroll result is
compared with the exact result of its named Ace command from the same reset
fixture. Go-to-line and diagnostic navigation use explicit observable results.

This tranche covers 51 source rows and 52 binding executions. The count
includes every alternate and separately executes the duplicated `Ctrl-P` and
`Ctrl-Shift-P` source rows. The three `---` rows—Split line, Scroll page down,
and Scroll page up—are recorded as Windows/Linux exclusions and are not sent
as keyboard events.

## Work unit 10 remaining shortcuts and final accounting

Every Windows/Linux binding in Multicursor, Find/Replace, Folding, and Other
is exercised with real Chromium keyboard events and an observable editor or UI
result. This tranche covers 49 source rows and 50 binding executions. Fold all
comments and Center selection are the two `---` exclusions. Undo, redo, macro
recording, and macro replay receive basic smoke coverage here; their full
history and sequence matrices remain assigned to work units 11 and 12.

Across work units 9 and 10, all 100 source rows and 102 binding executions are
accounted for: 97 unique bindings, five exclusions, and five duplicate keys.
The duplicate keys are `Ctrl-Shift-P`, `Ctrl-P`, `Ctrl-Shift-L`, `Ctrl-U`, and
`Ctrl-Shift-U`. `Ctrl-Enter` remains the single application override.

The pinned Ace bundle binds `transposeletters` to `Alt-Shift-X`, although the
source table specifies `Ctrl-T`; Graph Viz registers `Ctrl-T` as a compatibility
alias. The pinned `Alt-0` command is `foldOther`, which supplies the documented
Fold all behavior. Beautify is loaded and registered before the editor binds
and tests `Ctrl-Shift-B`.

## Work unit 11 undo and redo behavior

Real-browser history coverage now executes `Ctrl-Z`, `Ctrl-Y`, and
`Ctrl-Shift-Z` across character insertion, coalesced typing, forward and
backward deletion, newline insertion, multiline paste, selection replacement,
indentation, every line-operation edit, case conversion, number modification,
comments, and multi-cursor insertion. Each history cycle asserts the complete
source plus Ace anchor, lead, and all selection ranges.

Add node, Draw edge, Delete selection, and Apply attributes each remain one
visual undo unit. Keyboard and visual edits retain independent ordering, a new
edit invalidates both redo bindings, template replacement remains one undoable
whole-document change, and reset replacement clears both history stacks. The
pinned Ace build selects a changed range on some redo operations; tests preserve
that exact native behavior instead of forcing a collapsed cursor.

An 80-entry isolated-edit history is completely unwound and replayed, followed
by five repeated top-entry cycles. Render success and failure, theme changes,
resizing, explorer and Help navigation, and SVG-only loads preserve source,
selection, and history revision. Auto-render receives one exact source per
edit, undo, or redo; session persistence records each changed source once even
when later view-state updates rewrite the same session.

## Work unit 12 macro recording and playback

Windows/Linux macro coverage drives `Ctrl-Alt-E` and `Ctrl-Shift-E` through
real keyboard events. Recorded sequences include text, navigation, selection,
deletion, indentation, multiline insertion, Unicode, DOT punctuation, undo,
redo, selection replacement, and multi-cursor edits. Playback is verified at
multiple positions, across repeated runs, and through exact source, anchor,
lead, selection-range, undo, and redo states.

The pinned Ace behavior is retained: replay before any recording is a no-op;
an empty recording restores the prior macro; a nonempty recording replaces it;
and replayed macro edits form one undoable operation. Recording controls and
replay controls do not add themselves recursively. A recording containing Undo
then Redo preserves that command sequence, and a later recording still replaces
it normally.

Graph Viz render, fit, and reset shortcuts remain outside Ace recording. Visual
widget mutations change DOT history without changing the stored macro. Macro
playback with several recorded insert commands produces one debounced render
and one persisted source transition per resulting document.

## Real-browser test environment

- Runner: `@playwright/test` 1.62.1, exact version in `package-lock.json`.
- Browser: Playwright's pinned Chromium-for-Linux revision.
- Ace platform for future tests: `win` (Ace's Windows/Linux key map).
- Keyboard layout: `en-US`; the smoke uses layout-stable ASCII and named keys.
- Determinism: one worker, no retries, fixed locale/timezone/viewport/color
  scheme, local application URL, and mocked render/file responses.

Install the pinned runner and browser once:

```bash
npm ci
npx playwright install chromium
```

Run against a page and JavaScript compiled directly from the current Hoon:

```bash
VERE=~/piers/urbit tests/browser/run-real.sh
```

Or run against an installed Graph Viz desk:

```bash
GVIZ_URL=http://localhost:8080 tests/browser/run-real.sh
```

The test itself makes no external network requests.

## Work unit 13 release state

The pre-Ace inventory above remains as migration history; it no longer
describes the production editor. Production source access is exclusively
through `createAceEditorAdapter()`. The old textarea editor, custom gutter,
scroll synchronization, input handler, and indentation handler are absent.
The remaining temporary textarea is only a clipboard fallback and never holds
the DOT document.

The synthetic browser harness now drives the same adapter contract and keeps
its fake Ace document state outside the host element. Real-browser smoke,
surface, lifecycle, visual-editing, failure, shortcut, undo/redo, and macro
tests run against the vendored Ace runtime. The Windows/Linux shortcut report
accounts for 100 source rows, 102 executions, 97 unique bindings, five
documented exclusions, five duplicate keys, and the single `Ctrl-Enter`
application override.

Known limitations are deliberate: only the Windows/Linux key map and `en-US`
layout are certified; the five manifest rows with no Windows/Linux keystroke
are inventory-only; Ace's unavailable full-screen command remains replaced by
Graph Viz render on `Ctrl-Enter`; DOT mode has no worker; and browser clipboard
permissions can force the local fallback path.
