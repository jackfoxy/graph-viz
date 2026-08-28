# peripheries

Set number of peripheries used in polygonal shapes and cluster boundaries

type: [int](../attribute-types/int.md), default: `<shape default>` (nodes) , `1` (clusters) , minimum: `0`

Note that [user-defined shapes](../node-shapes.md#epsf) are treated as a form of box shape, so the default peripheries value is 1 and the user-defined shape will be drawn in a bounding rectangle. Setting `peripheries=0` will turn this off.

`peripheries=1` is the maximum value for clusters.

_Valid on:_

  * Nodes
  * Clusters
