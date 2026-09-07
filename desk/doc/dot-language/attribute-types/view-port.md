# viewPort

Clipping window on final drawing

Format: `"%lf,%lf,%lf,%lf,%lf"` or `"%lf,%lf,%lf,'%s'"`

The viewPort `W,H,Z,x,y` or `W,H,Z,N` specifies a viewport for the final image. The pair `(W,H)` gives the dimensions (width and height) of the final image, in [points](/doc/info/attrs.html#points).

The optional `Z` is the zoom factor, i.e., the image in the original layout will be `W/Z` by `H/Z` points in size. By default, `Z` is `1`.

The optional last part is either a pair `(x,y)` giving a position in the original layout of the graph, in [points](/doc/info/attrs.html#points), of the center of the viewport, or the name `N` of a node whose center should used as the focus.

By default, the focus is the center of the graph bounding box, i.e., `(bbx/2,bby/2)`, where `"bbx,bby"` is the value of the bounding box attribute [bb](../attributes/bb.md).

Sample values: `50,50,.5,'2.8 BSD'` or `100,100,2,450,300`. The first will take the 100x100 point square centered on the node `2.8 BSD` and scale it down by 0.5, yielding a 50x50 point final image.

## Attributes

`viewPort` is a valid type for:

  * [viewport](../attributes/viewport.md)
