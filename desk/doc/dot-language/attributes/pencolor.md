# pencolor

Color used to draw the bounding box around a cluster

type: [color](../attribute-types/color.md), default: `black`

If `pencolor` is not defined, [color](color.md) is used.

If [color](color.md) is not defined, [bgcolor](bgcolor.md) is used.

If [bgcolor](bgcolor.md) is not defined, the default is used.

Note that a cluster inherits the root graph's attributes if defined. Thus, if the root graph has defined a `pencolor`, this will override a [color](color.md) or [bgcolor](bgcolor.md) attribute set for the cluster.

_Valid on:_

  * Clusters
