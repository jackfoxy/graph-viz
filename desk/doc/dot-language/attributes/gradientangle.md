# gradientangle

If a gradient fill is being used, this determines the angle of the fill

type: [int](../attribute-types/int.md), default: `0`, minimum: `0`

For linear fills, the colors transform along a line specified by the angle and the center of the object. For radial fills, a value of zero causes the colors to transform radially from the center; for non-zero values, the colors transform from a point near the object's periphery as specified by the value.

If unset, the default angle is 0.

_Valid on:_

  * Nodes
  * Clusters
  * Graphs
