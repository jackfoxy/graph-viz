# imagescale

Controls how an image fills its containing node

type: [bool](../attribute-types/bool.md) | [string](../attribute-types/string.md), default: `false`

In general, the image is given its natural size, (cf. [dpi](dpi.md)), and the node size is made large enough to contain its image, its label, its margin, and its peripheries.

Its width and height will also be at least as large as its minimum [width](width.md) and [height](height.md). If, however, `fixedsize=true`, the width and height attributes specify the exact size of the node.

  * During rendering, in the default case (`imagescale=false`), the image retains its natural size.
  * If `imagescale=true`, the image is uniformly scaled (i.e., its aspect ratio is preserved) to fit inside the node. At least one dimension of the image will be as large as possible given the size of the node.
  * When `imagescale=width`, the width of the image is scaled to fill the node width.
  * The corresponding property holds when `imagescale=height`.
  * When `imagescale=both`, both the height and the width are scaled separately to fill the node.



In all cases, if a dimension of the image is larger than the corresponding dimension of the node, that dimension of the image is scaled down to fit the node.

As with the case of expansion, if `imagescale=true`, width and height are scaled uniformly.

_Valid on:_

  * Nodes
