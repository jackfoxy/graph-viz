# graph-viz

Gall/Hoon implementation of graphviz and the DOT language: DOT text →
AST → attributed graph → positioned graph → SVG, as a stateless
poke-driven Urbit agent. `dot` engine and SVG output only in v1.

## LLM Skills

[Graphviz DOT language reference](https://github.com/jackfoxy/foxy-skills/tree/master/gviz-dot-syntax)

[%graph-viz Gall agent API reference](https://github.com/jackfoxy/foxy-skills/tree/master/gviz-gall-api/)

[Practical recipes and best practices](https://github.com/jackfoxy/foxy-skills/tree/master/gviz-patterns/)

## Layout

```
desk/                     the %graph-viz desk (zuse 409/408)
  sur/ast.hoon              DOT AST
  sur/graph.hoon            positioned graph (public consumable noun)
  sur/gviz.hoon             poke/response protocol types
  lib/parse.hoon            DOT grammar (parser combinators)
  lib/print.hoon            AST → canonical DOT text (parser test oracle)
  lib/attr.hoon             attribute resolution + typed decoding
  lib/metrics.hoon          text metrics (single interface, Helvetica AFM)
  lib/acyc.hoon             cycle breaking
  lib/rank.hoon             rank assignment
  lib/order.hoon            ordering / crossing reduction
  lib/coord.hoon            coordinate assignment
  lib/route.hoon            edge routing, splines, arrowheads
  lib/svg.hoon              SVG codegen
  lib/gviz.hoon             top-level pipeline gate (command → response)
  lib/gviz-web.hoon         browser page, styles, script, and JSON
  lib/server.hoon           vendored Eyre response helper
  app/graph-viz.hoon        noun API/render agent
  app/graph-viz-web.hoon    Eyre/Sail browser agent
  desk.docket-0             direct site metadata (no frontend glob)
  mar/gviz/*.hoon           poke/response marks; mar/dot, mar/svg
  tests/lib/*, tests/app/*  per-stage unit suites (~125 arms)
  tests/dot/*.dot           parser/layout corpus
  tests/svg/*.svg           byte-exact SVG regression goldens
check.sh                  offline reference validation (see below)
tests/browser/             Node browser behavior smoke suite
docs/screenshots/          desktop and responsive release screenshots
RELEASE.md                 release and manual smoke checklist
```

## Protocol

Pokes only ack/nack, so results ride a one-shot subscription: subscribe
to `/result/[uid]` on `%graph-viz`, poke `%gviz-command` carrying the
same uid, receive one `%gviz-result` `%fact` on the path, then a
`%kick`. Errors (parse, unsupported engine/format/feature, layout) are
structured results, not nacks. A poke with no matching subscriber is
nacked with an explanation.

## Browser editor

Installing the desk starts both agents. Docket opens the editor at
`/apps/graph-viz`; its HTML, CSS, and JavaScript are generated directly
from Hoon, so no external frontend build or glob is required. The editor
posts DOT text to `/apps/graph-viz/render`. The noun protocol above is
unchanged.

Clay-backed DOT and SVG files are stored below `/data/graph-viz`. Browser
path prompts and file trees keep this storage root hidden.

![Graph Viz editor rendering the flowchart template](docs/screenshots/editor.png)

![Responsive Graph Viz editor](docs/screenshots/mobile.png)

## Install from source

The desk is self-contained and has no frontend build step. On a development
ship, create and mount a desk:

```hoon
|merge %graph-viz our %base
|mount %graph-viz
```

Copy the contents of this repository's `desk/` directory into the mounted
`graph-viz/` directory beside the pier, then commit and install it:

```hoon
|commit %graph-viz
|install our %graph-viz
```

Open `/apps/graph-viz` through the ship's HTTP interface. Installation starts
both `%graph-viz` (noun API) and `%graph-viz-web` (browser editor), as declared
in `desk.bill`. Direct-site metadata lives in `desk.docket-0`; no glob is
required.

## Testing

On a fakezod with the desk mounted and installed:

```
|commit %graph-viz
-test /=graph-viz=/tests ~
```

Run the browser behavior suite against the served JavaScript with Node 20 or
newer:

```bash
GVIZ_URL=http://localhost:8080 tests/browser/run.sh
```

The suite covers rendering, out-of-order response suppression, structured
errors, persistence, Clay-backed DOT/SVG browsing, load, and save, share URLs,
pan/zoom, and SVG-to-source selection. For release validation, follow
[RELEASE.md](RELEASE.md).

## check.sh — reference validation and goldens

`check.sh` (repo root, not part of the desk) validates the pipeline
against reference graphviz and maintains the checked-in goldens. It
compiles the desk sources with `vere eval` by emulating ford imports,
so no ship is needed. Requirements: a vere binary (`VERE` env, default
`~/piers/vere-v4.5-linux-x86_64`), `python3`, and graphviz `dot` on
PATH.

- `./check.sh verify` — renders the corpus and compares structure
  against `dot -Tplain`: rank assignment must match exactly per file;
  within-rank pair order must agree ≥65% in aggregate across the
  corpus (measured 77% against graphviz 2.43; per-file numbers are
  noisy on small graphs where both layouts are equally optimal).
- `./check.sh regen` — regenerates `desk/tests/svg/*.svg` and prints
  the diag tuples asserted in `tests/lib/e2e.hoon`. Run after any
  intentional layout/codegen change, eyeball the SVG diffs, commit.
  Output is deterministic: regen on an unchanged tree is byte-identical.

## Corpus notes

- `unix`, `cluster` (= `clust.gv`), `fsm`, `world`, `shells` are real
  files from the graphviz repo test set; `hello.dot` is the canonical
  one-liner. `shells` stands in for `profile.gv`, which no longer
  exists upstream.
- The remaining `tests/dot/*.dot` are adversarial: quoted keywords,
  unicode labels, 8-bit unquoted ids, deep nesting, ports/compass
  forms, subgraph edge endpoints, empty graphs.
- Corpus files contain tabs (fine for clay and the lexer; hoon source
  itself forbids them, which matters only to the ford-emulation in
  check.sh, which converts them).

## Validation status (vs graphviz 2.43)

- Ranks: exact match with `dot -Tplain` on all five comparable corpus
  files (a balance pass mirrors network simplex's tie-breaking on
  1-in/1-out nodes).
- Crossings: within ceil(1.5×) of dot's own mincross counts
  (`dot -v`); thresholds checked into `tests/lib/order.hoon`.
- Coordinates: no-overlap and order-preservation are property-tested;
  virtual-chain spreads measured tighter than dot's own splines.
- SVG: output follows dot's `-Tsvg` structure (`<g class="node">`,
  `<g class="edge">`, `<title>`s) so downstream CSS/JS tooling works;
  corpus output is XML-validated.

## Known v1 limits

- `%dot` engine and `%svg` format only; everything else in both enums
  is recognized and rejected as unsupported.
- `record`/HTML-label shapes rejected as `%unsupported-feature`.
- Longest-path + tightening + balance instead of full network simplex;
  piecewise-cubic corridor splines instead of box-constrained fitting;
  clusters constrain ordering and draw bounding boxes but don't get
  recursive layout. All three sit behind interfaces designed for the
  full replacements.
- Within-rank order can differ from dot's at equal crossing quality
  (independent mincross tie-breaks); `ratio` is decoded but has no
  geometry effect.
