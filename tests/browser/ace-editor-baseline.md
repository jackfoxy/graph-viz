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

The checked-in manifest is an inventory only. It deliberately makes no claim
that Ace commands have been implemented or tested in this textarea baseline.

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
