# Post-v1

Known gaps, in rough priority order. Each sits behind an interface
designed for the full replacement, so none require reworking the
pipeline.

- **Network simplex ranking.** v1 ranks with longest-path + source
  tightening + an ns.c-style balance pass. This matches reference
  `dot -Tplain` ranks exactly on the validation corpus, but simplex
  handles adversarial weight/minlen combinations better. Drop-in
  behind `+rank-graph:rank`.
- **Box-constrained spline fitting** (`routespl.c`). v1 fits
  piecewise cubics through the virtual-node corridor; true fitting
  produces smoother long edges. Drop-in behind
  `+route-graph:route`.
- **Recursive cluster layout.** v1 clusters constrain ordering and
  draw bounding boxes; dot lays out cluster interiors as nested
  graphs. Affects `order`/`coord`.
- **HTML-like labels** (`label=<...>`) — currently
  `%unsupported-feature` with the source position.
- **`record`/`Mrecord` shapes** — currently `%unsupported-feature`.
- **Other engines** (`neato`, `fdp`, `sfdp`, `twopi`, `circo`,
  `patchwork`, `osage`) — recognized, rejected. The positioned-graph
  noun and codegen are engine-agnostic; each engine is a new layout
  path.
- **Other formats** (`png`, `pdf`, `plain`, `json`, `xdot`, ...) —
  recognized, rejected. `plain`/`json`/`xdot` are cheap text codegens
  over the positioned graph; raster formats need image encoders.
- **Smaller items:** `ratio`; edge `weight` in median ordering;
  greedy-FAS cycle breaking (v1 is DFS-based); per-arrow open/closed
  fill fidelity (`empty` currently fills); graph-level `label`;
  `concentrate`; per-line font metrics beyond the Helvetica table
  (`metrics` is the single interface to swap).
