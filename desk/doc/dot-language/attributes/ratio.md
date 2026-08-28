# ratio

Sets the aspect ratio (drawing height/drawing width) for the drawing

type: [double](../attribute-types/double.md) | [string](../attribute-types/string.md)

Note that this is adjusted before the [size](size.md) attribute constraints are enforced.

In addition, the calculations usually ignore the node sizes, so the final drawing size may only approximate what is desired.

If `ratio` is numeric, `ratio` is taken as the desired aspect ratio. Then, if the actual aspect ratio is less than the desired ratio, the drawing height is scaled up to achieve the desired ratio; if the actual ratio is greater than that desired ratio, the drawing width is scaled up.

If `ratio="fill"` and the [size](size.md) attribute is set, node positions are scaled, separately in both x and y, so that the final drawing exactly fills the specified size. If both [size](size.md) values exceed the width and height of the drawing, then both coordinate values of each node are scaled up accordingly. However, if either size dimension is smaller than the corresponding dimension in the drawing, one dimension is scaled up so that the final drawing has the same aspect ratio as specified by [size](size.md). Then, when rendered, the layout will be scaled down uniformly in both dimensions to fit the given [size](size.md), which may cause nodes and text to shrink as well. This may not be what the user wants, but it avoids the hard problem of how to reposition the nodes in an acceptable fashion to reduce the drawing size.

If `ratio="compress"` and the [size](size.md) attribute is set, dot attempts to compress the initial layout to fit in the given size. This achieves a tighter packing of nodes but reduces the balance and symmetry. This feature only works in dot.

If `ratio="expand"`, the [size](size.md) attribute is set, and both the width and the height of the graph are less than the value in [size](size.md), node positions are scaled uniformly until at least one dimension fits [size](size.md) exactly. Note that this is distinct from using [size](size.md) as the desired size, as here the drawing is expanded before edges are generated and all node and text sizes remain unchanged.

If `ratio="auto"`, the [page](page.md) attribute is set and the graph cannot be drawn on a single page, then [size](size.md) is set to an "ideal" value.

In particular, the size in a given dimension will be the smallest integral multiple of the page size in that dimension which is at least half the current size. The two dimensions are then scaled independently to the new size. This feature only works in `dot`.

_Valid on:_

  * Graphs
