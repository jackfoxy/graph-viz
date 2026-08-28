# diredgeconstraints

Whether to constrain most edges to point downwards

type: [string](../attribute-types/string.md) | [bool](../attribute-types/bool.md), default: `false`

If true, constraints are generated for each edge in the largest (heuristic) directed acyclic subgraph such that the edge must point downwards.

Only valid when `[mode](mode.md)="ipsep"`.

If `hier`, generates level constraints similar to those used with `[mode](mode.md)="hier"`. The main difference is that, in the latter case, only these constraints are involved, so a faster solver can be used.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only.
