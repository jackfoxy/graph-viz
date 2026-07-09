# %graph-viz reference

## CLI flag dispositions

How each `dot` command-line flag maps onto the poke interface.

| flag | disposition | mapping |
|---|---|---|
| command name (`dot`/`neato`/...) | implemented | `engine` field; only `%dot` lays out, rest → `%unsupported-engine` |
| `-K layout` | implemented | same `engine` field |
| `-T format[:renderer[:formatter]]` | implemented | `format` field; full enum recognized, only `%svg` accepted |
| `-G name[=value]` | implemented | `defaults` entry with `targ=%graph` |
| `-N name[=value]` | implemented | `defaults`, `targ=%node` |
| `-E name[=value]` | implemented | `defaults`, `targ=%edge` |
| `-A name[=value]` | implemented | expand to all three targets before poking |
| `-s[scale]` | implemented | `scale` (unit @rd), default 72.0 |
| `-y` | implemented | `flip-y` |
| `-q` | implemented | `quiet`: omit `warnings` |
| `-v` | implemented | `verbose`: per-phase `diag` |
| `-V` | implemented | `%version` command |
| `-P` | implemented | `%plugins` command |
| `-n[num]`, `-x` | stubbed | neato-only → `%unsupported-feature` at the caller's discretion |
| `-o`, `-O` | n/a | the result is a fact; the caller persists it |
| `-l`, `-m`, `-c`, `-?` | n/a | PostScript libraries, memory testing, plugin config, usage |

## Supported attributes

Unknown attributes are preserved in the resolved maps (round-trip
fidelity) but ignored, each producing one `unknown attribute: name`
warning. All length-like values are in inches (multiplied by 72pt),
following graphviz.

### Graph

| attribute | default | notes |
|---|---|---|
| `rankdir` | `TB` | `TB` `LR` `BT` `RL` |
| `nodesep` | `0.25` | minimum within-rank gap |
| `ranksep` | `0.5` | rank separation |
| `bgcolor` | — | page background |
| `size` | — | `"w,h"` or `"s"`; produces a scale factor ≤ 1 in the SVG transform |
| `ratio` | — | parsed, no geometry effect in v1 |

### Node

| attribute | default | notes |
|---|---|---|
| `shape` | `ellipse` | `box` `rect` `rectangle` `ellipse` `circle` `oval` `plaintext` `none` `point` `diamond` `triangle` `pentagon` `hexagon` `octagon`; unknown names draw as boxes; `record`/HTML rejected |
| `label` | `\N` | `\N` = node name, `\G` = graph name; `\n` `\l` `\r` break lines with center/left/right alignment |
| `width`, `height` | `0.75`, `0.5` | minima unless `fixedsize` |
| `fixedsize` | `false` | use `width`/`height` exactly |
| `color` | `black` | border/stroke |
| `fillcolor` | `lightgrey` | with `style=filled` |
| `fontcolor` | `black` | label text |
| `fontname` | `Times-Roman` | mapped to a websafe family in SVG |
| `fontsize` | `14` | points |
| `style` | `solid` | comma list: `solid` `dashed` `dotted` `bold` `filled` `invis` |
| `penwidth` | `1` | stroke width |

### Edge

| attribute | default | notes |
|---|---|---|
| `label` | — | `\T`/`\H`/`\E` substitute tail/head/edge names |
| `color`, `style`, `penwidth` | as node | `invis` suppresses drawing, keeps the title |
| `arrowhead`, `arrowtail` | `normal` | `normal` `empty` `vee` `dot` `diamond` `none`; unknown → `normal` |
| `arrowsize` | `1` | scales arrow polygons |
| `dir` | `forward` (digraph), `none` (graph) | `forward` `back` `both` `none`; reversal-corrected so arrows follow the source direction |
| `minlen` | `1` | minimum rank span |
| `weight` | `1` | parsed, reserved for layout tuning |
| `fontname`, `fontsize`, `fontcolor` | as node | for edge labels |

### Subgraphs

- `rank=same|min|max|source|sink` inside a subgraph constrains its
  nodes' ranks.
- Subgraphs named `cluster*` draw as background rectangles;
  `label`, `color` (border), and `style=filled` + `fillcolor` /
  `bgcolor` apply. Cluster members stay contiguous within ranks.

### Colors

Anywhere a color is accepted: an X11 color name (the built-in table
covers ~110 names and follows X11 where it differs from SVG — `green`
is `#00ff00`, `purple` `#a020f0`, `gray` `#bebebe`), a `#hex` form
passed through untouched, or an `H S V` / `H,S,V` triple of floats in
[0,1]. Unknown names pass through to the SVG as written.

## Error taxonomy

Errors are results, not nacks (`$err` in `sur/gviz.hoon`):

| error | when |
|---|---|
| `[%parse line col msg]` | DOT syntax errors; 1-indexed source position |
| `[%unsupported-engine engine]` | any engine but `%dot` |
| `[%unsupported-format format]` | any format but `%svg` |
| `[%unsupported-feature msg]` | HTML labels (with source position), `record`/`Mrecord`/HTML shapes |
| `[%layout msg]` | an internal layout crash, trapped by `+mule` — never crashes the agent |

The only nack: poking `%gviz-command` with no subscriber on
`/result/[uid]`, with a tang explaining the protocol.

## Diagnostics (`verbose`)

`diag` reports per-phase structural counts:
`[nodes edges clusters nrank virtuals crossings]` — distinct nodes,
expanded edges, clusters, rank count, virtual (routing) nodes, and the
crossing count after mincross.
