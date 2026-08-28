# label_scheme

Whether to treat a node whose name has the form `|edgelabel|*` as a special node representing an edge label.

type: [int](../attribute-types/int.md), default: `0`, minimum: `0`

  * The default, `label_scheme=0`, produces no effect.
  * If `label_scheme=1`, `sfdp` uses a penalty-based method to make that kind of node close to the center of its neighbor.
  * With `label_scheme=2`, `sfdp` uses a penalty-based method to make that kind of node close to the old center of its neighbor.
  * Finally, `label_scheme=3` invokes a two-step process of overlap removal and straightening.

_Valid on:_

  * Graphs



**Note:** [sfdp](/docs/layouts/sfdp/) only.
