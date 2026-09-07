# Node Attributes

Attributes you can set on graph nodes.

### Examples

* `node [style=filled]` — sets the default value of the node attribute [style](attributes/style.md) to `filled`. Any node appearing after this inherits this value, unless it explicitly sets the `style` attribute.
* `n0 [fillcolor=red]` — creates node `n0` and sets its [fillcolor](attributes/fillcolor.md) attribute to `red`. Other attributes are set to any previously specified default values for nodes.

---

### Attribute List

* [area](attributes/area.md) – Indicates the preferred area for a node or empty cluster. For [patchwork](https://graphviz.org/docs/layouts/patchwork/) only.
* [class](attributes/class.md) – Classnames to attach to the node, edge, graph, or cluster's SVG element. For [svg](https://graphviz.org/docs/outputs/svg.md) only.
* [color](attributes/color.md) – Basic drawing color for graphics, not text.
* [colorscheme](attributes/colorscheme.md) – A color scheme namespace: the context for interpreting color names.
* [comment](attributes/comment.md) – Comments are inserted into output.
* [distortion](attributes/distortion.md) – Distortion factor for [shape=polygon](https://www.google.com/search?q=https://graphviz.org/doc/info/shapes.html%23polygon).
* [fillcolor](attributes/fillcolor.md) – Color used to fill the background of a node or cluster.
* [fixedsize](attributes/fixedsize.md) – Whether to use the specified [width](attributes/width.md) and [height](attributes/height.md) attributes to choose node size (rather than sizing to fit the node contents).
* [fontcolor](attributes/fontcolor.md) – Color used for text.
* [fontname](attributes/fontname.md) – Font used for text.
* [fontsize](attributes/fontsize.md) – Font size, in points, used for text.
* [gradientangle](attributes/gradientangle.md) – If a gradient fill is being used, this determines the angle of the fill.
* [group](attributes/group.md) – Name for a group of nodes, for bundling edges avoiding crossings. For [dot](https://graphviz.org/docs/layouts/dot/) only.
* [height](attributes/height.md) – Height of node, in inches.
* [href](attributes/href.md) – Synonym for [URL](attributes/url.md). For [map](https://graphviz.org/docs/outputs/imap.md), [postscript](https://graphviz.org/docs/outputs/ps.md), [svg](https://graphviz.org/docs/outputs/svg.md) only.
* [id](attributes/id.md) – Identifier for graph objects. For [map](https://graphviz.org/docs/outputs/imap.md), [postscript](https://graphviz.org/docs/outputs/ps.md), [svg](https://graphviz.org/docs/outputs/svg.md) only.
* [image](attributes/image.md) – Gives the name of a file containing an image to be displayed inside a node.
* [imagepos](attributes/imagepos.md) – Controls how an image is positioned within its containing node.
* [imagescale](attributes/imagescale.md) – Controls how an image fills its containing node.
* [label](attributes/label.md) – Text label attached to objects.
* [labelloc](attributes/labelloc.md) – Vertical placement of labels for nodes, root graphs, and clusters.
* [layer](attributes/layer.md) – Specifies layers in which the node, edge, or cluster is present.
* [margin](attributes/margin.md) – For graphs, this sets x and y margins of canvas, in inches.
* [nojustify](attributes/nojustify.md) – Whether to justify multiline text vs the previous text line (rather than the side of the container).
* [ordering](attributes/ordering.md) – Constrains the left-to-right ordering of node edges. For [dot](https://graphviz.org/docs/layouts/dot/) only.
* [orientation](attributes/orientation.md) – Node shape rotation angle, or graph orientation.
* [penwidth](attributes/penwidth.md) – Specifies the width of the pen, in points, used to draw lines and curves.
* [peripheries](attributes/peripheries.md) – Set number of peripheries used in polygonal shapes and cluster boundaries.
* [pin](attributes/pin.md) – Keeps the node at the node's given input position. For [neato](https://graphviz.org/docs/layouts/neato/), [fdp](https://graphviz.org/docs/layouts/fdp/) only.
* [pos](attributes/pos.md) – Position of node, or spline control points. For [neato](https://graphviz.org/docs/layouts/neato/), [fdp](https://graphviz.org/docs/layouts/fdp/) only.
* [rects](attributes/rects.md) – Rectangles for fields of records, in points. Write only.
* [regular](attributes/regular.md) – If `true`, force polygon to be regular.
* [root](attributes/root.md) – Specifies nodes to be used as the center of the layout. For [twopi](https://graphviz.org/docs/layouts/twopi/), [circo](https://graphviz.org/docs/layouts/circo/) only.
* [samplepoints](attributes/samplepoints.md) – Gives the number of points used for a circle/ellipse node.
* [shape](attributes/shape.md) – Sets the shape of a node.
* [shapefile](attributes/shapefile.md) – A file containing user-supplied node content.
* [showboxes](attributes/showboxes.md) – Print guide boxes for debugging. For [dot](https://graphviz.org/docs/layouts/dot/) only.
* [sides](attributes/sides.md) – Number of sides when [shape=polygon](https://www.google.com/search?q=https://graphviz.org/doc/info/shapes.html%23polygon).
* [skew](attributes/skew.md) – Skew factor for [shape=polygon](https://www.google.com/search?q=https://graphviz.org/doc/info/shapes.html%23polygon).
* [sortv](attributes/sortv.md) – Sort order of graph components for ordering [packmode](attributes/packmode.md) packing.
* [style](attributes/style.md) – Set style information for components of the graph.
* [target](attributes/target.md) – If the object has a [URL](attributes/url.md), this attribute determines which window of the browser is used for the URL. For [map](https://graphviz.org/docs/outputs/imap.md), [svg](https://graphviz.org/docs/outputs/svg.md) only.
* [tooltip](attributes/tooltip.md) – Tooltip (mouse hover text) attached to the node, edge, cluster, or graph. For [cmap](https://graphviz.org/docs/outputs/imap.md), [svg](https://graphviz.org/docs/outputs/svg.md) only.
* [URL](attributes/url.md) – Hyperlinks incorporated into device-dependent output. For [map](https://graphviz.org/docs/outputs/imap.md), [postscript](https://graphviz.org/docs/outputs/ps.md), [svg](https://graphviz.org/docs/outputs/svg.md) only.
* [vertices](attributes/vertices.md) – Sets the coordinates of the vertices of the node's polygon, in inches. Write only.
* [width](attributes/width.md) – Width of node, in inches.
* [xlabel](attributes/xlabel.md) – External label for a node or edge.
* [xlp](attributes/xlp.md) – Position of an exterior label, in points. Write only.
* [z](attributes/z.md) – Z-coordinate value for 3D layouts and displays.