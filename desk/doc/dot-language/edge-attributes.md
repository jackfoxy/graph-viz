# Edge Attributes

Attributes you can set on graph edges

Examples of edge statements:

`edge [name0=val0]`
sets default edge attribute name0 to val0.
Any edge appearing after this inherits the new default attributes.

`n1 -> n2 [name1=val1]` or `n1 -- n2 [name1=val1]`
creates directed or undirected edge between nodes n1 and n2 and sets its attributes according to the optional list and default attributes for edges.

- [arrowhead](attributes/arrowhead.md) - Style of arrowhead on the head node of an edge.
- [arrowsize](attributes/arrowsize.md) - Multiplicative scale factor for arrowheads.
- [arrowtail](attributes/arrowtail.md) - Style of arrowhead on the tail node of an edge.
- [class](attributes/class.md) - Classnames to attach to the node, edge, graph, or cluster's SVG element.
  For [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [color](attributes/color.md) - Basic drawing color for graphics, not text.
- [colorscheme](attributes/colorscheme.md) - A color scheme namespace: the context for interpreting color names.
- [comment](attributes/comment.md) - Comments are inserted into output.
- [constraint](attributes/constraint.md) - If false, the edge is not used in ranking the nodes.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [decorate](attributes/decorate.md) - Whether to connect the edge label to the edge with a line.
- [dir](attributes/dir.md) - Edge type for drawing arrowheads.
- [edgehref](attributes/edgehref.md) - Synonym for [edgeURL](attributes/edgeurl.md).
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [edgetarget](attributes/edgetarget.md) - Browser window to use for the [edgeURL](attributes/edgeurl.md) link.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [edgetooltip](attributes/edgetooltip.md) - Tooltip annotation attached to the non-label part of an edge.
  For [cmap](https://www.graphviz.org/docs/outputs/cmap/), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [edgeURL](attributes/edge-url.md) - The link for the non-label parts of an edge.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [fillcolor](attributes/fillcolor.md) - Color used to fill the background of a node or cluster.
- [fontcolor](attributes/fontcolor.md) - Color used for text.
- [fontname](attributes/fontname.md) - Font used for text.
- [fontsize](attributes/fontsize.md) - Font size, [in points](https://www.graphviz.org/doc/info/attrs.html#points), used for text.
- [head_lp](attributes/head_lp.md) - Center position of an edge's head label.
  For write only.
- [headclip](attributes/headclip.md) - If true, the head of an edge is clipped to the boundary of the head node.
- [headhref](attributes/headhref.md) - Synonym for [headURL](attributes/headurl.md).
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [headlabel](attributes/headlabel.md) - Text label to be placed near head of edge.
- [headport](attributes/headport.md) - Indicates where on the head node to attach the head of the edge.
- [headtarget](attributes/headtarget.md) - Browser window to use for the [headURL](attributes/headurl.md) link.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [headtooltip](attributes/headtooltip.md) - Tooltip annotation attached to the head of an edge.
  For [cmap](https://www.graphviz.org/docs/outputs/cmap/), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [headURL](attributes/headurl.md) - If defined, `headURL` is output as part of the head label of the edge.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [href](attributes/href.md) - Synonym for [URL](attributes/url.md).
  For map, [postscript](https://www.graphviz.org/docs/outputs/ps/), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [id](attributes/id.md) - Identifier for graph objects.
  For map, [postscript](https://www.graphviz.org/docs/outputs/ps/), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [label](attributes/label.md) - Text label attached to objects.
- [labelangle](attributes/labelangle.md) - The angle (in degrees) in polar coordinates of the head & tail edge labels.
- [labeldistance](attributes/labeldistance.md) - Scaling factor for the distance of [headlabel](attributes/headlabel.md) / [taillabel](attributes/taillabel.md) from the head / tail nodes.
- [labelfloat](attributes/labelfloat.md) - If true, allows edge labels to be less constrained in position.
- [labelfontcolor](attributes/labelfontcolor.md) - Color used for [headlabel](attributes/headlabel.md) and [taillabel](attributes/taillabel.md).
- [labelfontname](attributes/labelfontname.md) - Font for `headlabel` and `taillabel`.
- [labelfontsize](attributes/labelfontsize.md) - Font size of `headlabel` and `taillabel`.
- [labelhref](attributes/labelhref.md) - Synonym for [labelURL](attributes/labelurl.md).
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [labeltarget](attributes/labeltarget.md) - Browser window to open [labelURL](attributes/labelurl.md) links in.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [labeltooltip](attributes/labeltooltip.md) - Tooltip annotation attached to label of an edge.
  For [cmap](https://www.graphviz.org/docs/outputs/cmap/), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [labelURL](attributes/labelurl.md) - If defined, `labelURL` is the link used for the label of an edge.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [layer](attributes/layer.md) - Specifies layers in which the node, edge or cluster is present.
- [len](attributes/len.md) - Preferred edge length, in inches.
  For [neato](https://www.graphviz.org/docs/layouts/neato.md), [fdp](https://www.graphviz.org/docs/layouts/fdp/) only.
- [lhead](attributes/lhead.md) - Logical head of an edge.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [lp](attributes/lp.md) - Label center position.
  For write only.
- [ltail](attributes/ltail.md) - Logical tail of an edge.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [minlen](attributes/minlen.md) - Minimum edge length (rank difference between head and tail).
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [nojustify](attributes/nojustify.md) - Whether to justify multiline text vs the previous text line (rather than the side of the container).
- [penwidth](attributes/penwidth.md) - Specifies the width of the pen, in points, used to draw lines and curves.
- [pos](attributes/pos.md) - Position of node, or spline control points.
  For [neato](https://www.graphviz.org/docs/layouts/neato.md), [fdp](https://www.graphviz.org/docs/layouts/fdp/) only.
- [radius](attributes/radius.md) - Radius of rounded corners on orthogonal edges.
- [samehead](attributes/samehead.md) - Edges with the same head and the same `samehead` value are aimed at the same point on the head.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [sametail](attributes/sametail.md) - Edges with the same tail and the same `sametail` value are aimed at the same point on the tail.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [showboxes](attributes/showboxes.md) - Print guide boxes for debugging.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [style](attributes/style.md) - Set style information for components of the graph.
- [tail_lp](attributes/tail_lp.md) - Position of an edge's tail label, [in points](https://www.graphviz.org/doc/info/attrs.html#points).
  For write only.
- [tailclip](attributes/tailclip.md) - If true, the tail of an edge is clipped to the boundary of the tail node.
- [tailhref](attributes/tailhref.md) - Synonym for [tailURL](attributes/tailurl.md).
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [taillabel](attributes/taillabel.md) - Text label to be placed near tail of edge.
- [tailport](attributes/tailport.md) - Indicates where on the tail node to attach the tail of the edge.
- [tailtarget](attributes/tailtarget.md) - Browser window to use for the [tailURL](attributes/tailurl.md) link.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [tailtooltip](attributes/tailtooltip.md) - Tooltip annotation attached to the tail of an edge.
  For [cmap](https://www.graphviz.org/docs/outputs/cmap/), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [tailURL](attributes/tailurl.md) - If defined, `tailURL` is output as part of the tail label of the edge.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [target](attributes/target.md) - If the object has a [URL](attributes/url.md), this attribute determines which window of the browser is used for the URL.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [tooltip](attributes/tooltip.md) - Tooltip (mouse hover text) attached to the node, edge, cluster, or graph.
  For [cmap](https://www.graphviz.org/docs/outputs/cmap/), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [URL](attributes/url.md) - Hyperlinks incorporated into device-dependent output.
  For map, [postscript](https://www.graphviz.org/docs/outputs/ps/), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [weight](attributes/weight.md) - Weight of edge.
- [xlabel](attributes/xlabel.md) - External label for a node or edge.
- [xlp](attributes/xlp.md) - Position of an exterior label, [in points](https://www.graphviz.org/doc/info/attrs.html#points).
  For write only.
