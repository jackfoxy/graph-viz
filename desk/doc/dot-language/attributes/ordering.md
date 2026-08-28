# ordering

Constrains the left-to-right ordering of node edges.

type: [string](../attribute-types/string.md), default: `""`

If `ordering="out"`, then the outedges of a node, that is, edges with the node as its tail node, must appear left-to-right in the same order in which they are defined in the input.

If `ordering="in"`, then the inedges of a node must appear left-to-right in the same order in which they are defined in the input.

If defined as a graph or subgraph attribute, the value is applied to all nodes in the graph or subgraph.

Note that the graph attribute takes precedence over the node attribute.

_Valid on:_

  * Graphs
  * Nodes



**Note:** [dot](/docs/layouts/dot/) only.
