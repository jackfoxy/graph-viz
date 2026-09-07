# v1.0.2

  - use Ace editor
  - tabbed editor and render area
  - drag tabs to reposition

# v1.0.1

UI help and editing enhancements

# v1.0.0

Known gaps, in rough priority order. Each sits behind an interface designed for the full replacement, so none require reworking the pipeline.

- **Network simplex ranking.** v1 ranks with longest-path + source tightening + an ns.c-style balance pass. This matches reference `dot -Tplain` ranks exactly on the validation corpus, but simplex handles adversarial weight/minlen combinations better. Drop-in behind `+rank-graph:rank`.
- **Box-constrained spline fitting** (`routespl.c`). v1 fits piecewise cubics through the virtual-node corridor; true fitting produces smoother long edges. Drop-in behind `+route-graph:route`.
- **Recursive cluster layout.** v1 clusters constrain ordering and draw bounding boxes; dot lays out cluster interiors as nested graphs. Affects `order`/`coord`.
- **HTML-like labels** (`label=<...>`) — currently `%unsupported-feature` with the source position.
- **`record`/`Mrecord` shapes** — currently `%unsupported-feature`.
- **Other engines** (`neato`, `fdp`, `sfdp`, `twopi`, `circo`, `patchwork`, `osage`) — recognized, rejected. The positioned-graph noun and codegen are engine-agnostic; each engine is a new layout path.
- **Other formats** (`png`, `pdf`, `plain`, `json`, `xdot`, ...) — recognized, rejected. `plain`/`json`/`xdot` are cheap text codegens over the positioned graph; raster formats need image encoders.
- **Smaller items:** `ratio`; edge `weight` in median ordering; greedy-FAS cycle breaking (v1 is DFS-based); per-arrow open/closed fill fidelity (`empty` currently fills); graph-level `label`; `concentrate`; per-line font metrics beyond the Helvetica table (`metrics` is the single interface to swap).

## Release checklist

### Package

- `desk/desk.bill` starts `%graph-viz` and `%graph-viz-web`.
- `desk/desk.docket-0` has the intended title, version, site, license, website, and color.
- `desk/sys.kelvin` targets the supported kernel.
- All `sur`, `lib`, `mar`, `app`, `gen`, `doc`, and test dependencies are present in the desk.
- `git status --short` contains only intentional release changes.

### Automated validation

- On a disposable fake ship: `-test /=graph-viz=/tests ~`.
- From the repository root: `./check.sh verify`.
- Against the running ship, set `GVIZ_URL` and run `tests/browser/run.sh`.
- Authenticated `POST /apps/graph-viz/render` returns status 200, `image/svg+xml`, and a valid `<svg>` document.
- Invalid DOT returns status 422 and a structured JSON parse error.

### Manual browser smoke

- A fresh `|install our %graph-viz` launches both agents and the docket opens `/apps/graph-viz`.
- Editing renders after the debounce and an older response cannot replace a newer preview.
- Parse, unsupported-feature, and layout errors preserve the last valid preview.
- Wheel zoom, drag pan, fit, reset, splitter resize, and mobile layout work.
- Node/edge selection links to DOT; supported visual edits rerender valid DOT.
- Reload restores source, pane size, view, and auto-render preference.
- Clay DOT/SVG browse, load, and save, and share URLs, round-trip correctly.
- Keyboard navigation, focus, labels, and shortcuts remain usable.

### Publish

- Update `version` in `desk/desk.docket-0` when release semantics require it.
- Review the screenshot and installation documentation.
- Tag the tested commit and publish the desk through the chosen channel.