# Release checklist

## Automated verification

Run from the repository root with Node 20+, Graphviz, and a Vere binary that
supports `eval`:

```bash
./check.sh verify
npm ci
npm run test:shortcuts
VERE=~/piers/urbit tests/browser/run-real.sh
```

Run the full desk suite on a mounted fake ship:

```hoon
|commit %graph-viz
-test /=graph-viz=/tests ~
```

The browser release gate must report all 100 official shortcut rows, 102
Windows/Linux executions, 97 unique bindings, five exclusions, five duplicate
keys, and one application override. It also covers comprehensive `Ctrl-Z`,
`Ctrl-Y`, `Ctrl-Shift-Z`, macro record/playback, offline Ace assets, adapter
lifecycle, visual editing, themes, accessibility, responsive resize, file
operations, Help tabs, fullscreen, and persistence.

## Installed-desk smoke

Use a fresh ship with no internet access after copying the desk:

1. Commit and install `%graph-viz`; open `/apps/graph-viz`.
2. Confirm every `/apps/graph-viz/ace/` request succeeds and no external
   script, module, worker, or source-map request occurs.
3. Type and render DOT; verify diagnostics, undo/redo, macro record/playback,
   selection, indentation, find/replace, folding, and Graph Viz shortcuts.
4. Switch light, dark, and system themes; verify the Ace theme and SVG preview,
   including a live system-theme change.
5. Drag both dividers to their extremes and repeat at narrow width; verify the
   editor remains usable and resized.
6. Open, save, overwrite, and delete DOT/SVG files from prompts, left-click,
   and the context menu; verify filename-only tabs and DOT history reset.
7. Open and close Help and Users Guide tabs with and without `%docs` installed.
8. Exercise SVG source/rendered views, copy, zoom, pan, fit, fullscreen, visual
   selection/editing, and reload persistence.

## Final review

```bash
find desk tests/browser -type f -name '*.js' -exec node --check {} \;
git diff --check
git status --short
```

Confirm the Ace version, file list, hashes, and license in
`desk/web/ace/README.md`; inspect the complete diff; and commit only the
intended release changes.

## Work unit 13 verification

Verified on 2026-08-22:

- 159 Hoon tests passed on a fresh fakezod (`ok=%.y`);
- 46 pinned-Chromium integration tests passed against the installed desk;
- the synthetic browser adapter smoke passed;
- the shortcut manifest test passed with the exact accounting above;
- `./check.sh verify` passed at 77% aggregate order agreement;
- all checked-in JavaScript passed `node --check`; and
- `git diff --check` passed.
