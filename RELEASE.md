# Release checklist

## Package

- [ ] `desk/desk.bill` starts `%graph-viz` and `%graph-viz-web`.
- [ ] `desk/desk.docket-0` has the intended title, version, site, license,
      website, and color.
- [ ] `desk/sys.kelvin` targets the supported kernel.
- [ ] All `sur`, `lib`, `mar`, `app`, `gen`, `doc`, and test dependencies are
      present in the desk.
- [ ] `git status --short` contains only intentional release changes.

## Automated validation

- [ ] On a disposable fake ship: `-test /=graph-viz=/tests ~`.
- [ ] From the repository root: `./check.sh verify`.
- [ ] Against the running ship, set `GVIZ_URL` and run
      `tests/browser/run.sh`.
- [ ] Authenticated `POST /apps/graph-viz/render` returns status 200,
      `image/svg+xml`, and a valid `<svg>` document.
- [ ] Invalid DOT returns status 422 and a structured JSON parse error.

## Manual browser smoke

- [ ] A fresh `|install our %graph-viz` launches both agents and the docket
      opens `/apps/graph-viz`.
- [ ] Editing renders after the debounce and an older response cannot replace
      a newer preview.
- [ ] Parse, unsupported-feature, and layout errors preserve the last valid
      preview.
- [ ] Wheel zoom, drag pan, fit, reset, splitter resize, and mobile layout work.
- [ ] Node/edge selection links to DOT; supported visual edits rerender valid
      DOT.
- [ ] Reload restores source, pane size, view, and auto-render preference.
- [ ] DOT, SVG, and share-URL exports round-trip correctly.
- [ ] Keyboard navigation, focus, labels, and shortcuts remain usable.

## Publish

- [ ] Update `version` in `desk/desk.docket-0` when release semantics require
      it.
- [ ] Review the screenshot and installation documentation.
- [ ] Tag the tested commit and publish the desk through the chosen channel.
