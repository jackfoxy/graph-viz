# penwidth

Specifies the width of the pen, in points, used to draw lines and curves

type: [double](../attribute-types/double.md), default: `1.0`, minimum: `0.0`

including the boundaries of edges and clusters.

`penwidth` value is inherited by subclusters, and has no effect on text.

Previous to 31 January 2008, the effect of `penwidth=W` was achieved by including `setlinewidth(W)` as part of a [style](style.md) specification.

If both attributes are set, `penwidth` will be used.

_Valid on:_

  * Clusters
  * Nodes
  * Edges
