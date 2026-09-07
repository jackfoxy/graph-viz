# fillcolor

Color used to fill the background of a node or cluster

type: [color](../attribute-types/color.md) | [colorList](../attribute-types/colorList.md), default: `lightgrey` (nodes) , `black` (clusters)

Assuming `[style](style.md)=filled`, or a filled [arrowhead](arrowhead.md).

If `fillcolor` is not defined, [color](color.md) is used. (For clusters, if `color` is not defined, [bgcolor](bgcolor.md) is used.) If this is not defined, the default is used, except for `[shape](shape.md)=point` or when the output format is `MIF`, which use black by default.

If the value is a [colorList](../attribute-types/colorList.md), a gradient fill is used. By default, this is a linear fill; setting `[style](style.md)=radial` will cause a radial fill. At present, only two colors are used. If the second color (after a colon) is missing, the default color is used for it.

See also the [gradientangle](gradientangle.md) attribute for setting the gradient angle.

Note that a cluster inherits the root graph's attributes if defined. Thus, if the root graph has defined a `fillcolor`, this will override a [color](color.md) or [bgcolor](bgcolor.md) attribute set for the cluster.

_Valid on:_

  * Nodes
  * Edges
  * Clusters
