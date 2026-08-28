# Attributes

Instructions to customise the layout of Graphviz [nodes](node-attributes.md), [edges](edge-attributes.md), [graphs](graph-attributes.md), subgraphs, and [clusters](cluster-attributes.md).

The table below describes the attributes used by various Graphviz tools. The table gives the name of the attribute, the graph components (node, edge, etc.) which use the attribute and the type of the attribute (strings representing legal values of that type). Where applicable, the table also gives a default value for the attribute, a minimum allowed setting for numeric attributes, and certain restrictions on the use of the attribute.

Note that attribute names are case-sensitive. This is usually true for attribute values as well, unless noted.

All Graphviz attributes are specified by name-value pairs. Thus, to set the `color` of a node `abc`, one would use

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  abc [color = red]
}</code></pre>
</div>

Similarly, to set the arrowhead style of an edge `abc -> def`, one would use:

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  abc -&gt; def [arrowhead = diamond]
}</code></pre>
</div>

Further details concerning the setting of attributes can be found in the description of the [DOT language.](../dot-language.md)

At present, most device-independent units are either inches or [points](http://en.wikipedia.org/wiki/Point_\(typography\)), which we take as 72 points per inch.

<a id="undir_note"></a>

**Note:** Some attributes, such as [dir](../dot-language/attributes/dir.md) or [arrowtail](../dot-language/attributes/arrowtail.md), are ambiguous when used in [DOT](../dot-language.md) with an undirected graph since the head and tail of an edge are meaningless. As a convention, the first time an undirected edge appears, the [DOT](../dot-language.md) parser will assign the left node as the tail node and the right node as the head. For example, the edge `A -- B` will have tail `A` and head `B`. It is the user's responsibility to handle such edges consistently. If the edge appears later, in the format

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  B -- A [taillabel = "tail"]
}</code></pre>
</div>

the drawing will attach the tail label to node `A`. To avoid possible confusion when such attributes are required, the user is encouraged to use a directed graph. If it is important to make the graph appear undirected, this can be done using the [dir](../dot-language/attributes/dir.md), [arrowtail](../dot-language/attributes/arrowtail.md) or [arrowhead](../dot-language/attributes/arrowhead.md) attributes.

The tools accept standard C representations for `int` and `double` types. For the `bool` type, TRUE values are represented by `true` or `yes` (case-insensitive) and any non-zero integer, and FALSE values by `false` or `no` (case-insensitive) and zero. In addition, there are a variety of specialized types such as `arrowType`, `color`, `point` and `rankdir`. Legal values for these types are given at the end.

The **Used By** column field indicates which graph component(s) the attribute applies to.

In the **Notes** field, an annotation of _write only_ indicates that the attribute is used for output, and is not used or read by any of the layout programs.

Name | Used By | Type | Default | Minimum | Description, notes  
---|---|---|---|---|---  
[_background](../dot-language/attributes/background.md) | Graphs | [xdot](../dot-language/attribute-types/xdot.md) | `<none>` |  |  A string in the [xdot` format](../dot-language/attribute-types/xdot.md) specifying an arbitrary background.   
[area](../dot-language/attributes/area.md) | Nodes, Clusters | [double](../dot-language/attribute-types/double.md) | `1.0` | `>0` |  Indicates the preferred area for a node or empty cluster. [patchwork](/docs/layouts/patchwork/) only.   
[arrowhead](../dot-language/attributes/arrowhead.md) | Edges | [arrowType](../dot-language/attribute-types/arrow-type.md) | `normal` |  |  Style of arrowhead on the head node of an edge.   
[arrowsize](../dot-language/attributes/arrowsize.md) | Edges | [double](../dot-language/attribute-types/double.md) | `1.0` | `0.0` |  Multiplicative scale factor for arrowheads.   
[arrowtail](../dot-language/attributes/arrowtail.md) | Edges | [arrowType](../dot-language/attribute-types/arrow-type.md) | `normal` |  |  Style of arrowhead on the tail node of an edge.   
[bb](../dot-language/attributes/bb.md) | Clusters, Graphs | [rect](../dot-language/attribute-types/rect.md) |  |  |  Bounding box of drawing in points. write only.   
[beautify](../dot-language/attributes/beautify.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether to draw leaf nodes uniformly in a circle around the root node in sfdp.. [sfdp](/docs/layouts/sfdp/) only.   
[bgcolor](../dot-language/attributes/bgcolor.md) | Graphs, Clusters | [color](../dot-language/attribute-types/color.md), [colorList](../dot-language/attribute-types/color-list.md) | `<none>` |  |  Canvas background color.   
[center](../dot-language/attributes/center.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether to center the drawing in the output canvas.   
[charset](../dot-language/attributes/charset.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `"UTF-8"` |  |  Character encoding used when interpreting string input as a text label..   
[class](../dot-language/attributes/class.md) | Edges, Nodes, Clusters, Graphs | [string](../dot-language/attribute-types/string.md) | `""` |  |  Classnames to attach to the node, edge, graph, or cluster's SVG element. [svg](/docs/outputs/svg/) only.   
[cluster](../dot-language/attributes/cluster.md) | Clusters, Subgraphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether the subgraph is a cluster.   
[clusterrank](../dot-language/attributes/clusterrank.md) | Graphs | [clusterMode](../dot-language/attribute-types/cluster-mode.md) | `local` |  |  Mode used for handling clusters. [dot](/docs/layouts/dot/) only.   
[color](../dot-language/attributes/color.md) | Edges, Nodes, Clusters | [color](../dot-language/attribute-types/color.md), [colorList](../dot-language/attribute-types/color-list.md) | `black` |  |  Basic drawing color for graphics, not text.   
[colorscheme](../dot-language/attributes/colorscheme.md) | Edges, Nodes, Clusters, Graphs | [string](../dot-language/attribute-types/string.md) | `""` |  |  A color scheme namespace: the context for interpreting color names.   
[comment](../dot-language/attributes/comment.md) | Edges, Nodes, Graphs | [string](../dot-language/attribute-types/string.md) | `""` |  |  Comments are inserted into output.   
[compound](../dot-language/attributes/compound.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  If true, allow edges between clusters. [dot](/docs/layouts/dot/) only.   
[concentrate](../dot-language/attributes/concentrate.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  If true, use edge concentrators.   
[constraint](../dot-language/attributes/constraint.md) | Edges | [bool](../dot-language/attribute-types/bool.md) | `true` |  |  If false, the edge is not used in ranking the nodes. [dot](/docs/layouts/dot/) only.   
[Damping](../dot-language/attributes/damping.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `0.99` | `0.0` |  Factor damping force motions.. [neato](/docs/layouts/neato/) only.   
[decorate](../dot-language/attributes/decorate.md) | Edges | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether to connect the edge label to the edge with a line.   
[defaultdist](../dot-language/attributes/defaultdist.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `1+(avg. len)*sqrt(|V|)` | `epsilon` |  The distance between nodes in separate connected components. [neato](/docs/layouts/neato/) only.   
[dim](../dot-language/attributes/dim.md) | Graphs | [int](../dot-language/attribute-types/int.md) | `2` | `2` |  Set the number of dimensions used for the layout. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only.   
[dimen](../dot-language/attributes/dimen.md) | Graphs | [int](../dot-language/attribute-types/int.md) | `2` | `2` |  Set the number of dimensions used for rendering. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only.   
[dir](../dot-language/attributes/dir.md) | Edges | [dirType](../dot-language/attribute-types/dir-type.md) | `forward` (directed)   
`none` (undirected)  |  |  Edge type for drawing arrowheads.   
[diredgeconstraints](../dot-language/attributes/diredgeconstraints.md) | Graphs | [string](../dot-language/attribute-types/string.md), [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether to constrain most edges to point downwards. [neato](/docs/layouts/neato/) only.   
[distortion](../dot-language/attributes/distortion.md) | Nodes | [double](../dot-language/attribute-types/double.md) | `0.0` | `-100.0` |  Distortion factor for `[shape](../dot-language/attributes/shape.md)=[polygon](/doc/info/shapes.html#polygon)`.   
[dpi](../dot-language/attributes/dpi.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `96.0` | `0.0` |  Specifies the expected number of pixels per inch on a display device. bitmap output, [svg](/docs/outputs/svg/) only.   
[edgehref](../dot-language/attributes/edgehref.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Synonym for [edgeURL](../dot-language/attributes/edge-url.md). map, [svg](/docs/outputs/svg/) only.   
[edgetarget](../dot-language/attributes/edgetarget.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `<none>` |  |  Browser window to use for the [edgeURL](../dot-language/attributes/edge-url.md) link. map, [svg](/docs/outputs/svg/) only.   
[edgetooltip](../dot-language/attributes/edgetooltip.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Tooltip annotation attached to the non-label part of an edge. [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only.   
[edgeURL](../dot-language/attributes/edge-url.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  The link for the non-label parts of an edge. map, [svg](/docs/outputs/svg/) only.   
[epsilon](../dot-language/attributes/epsilon.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `.0001 * # nodes` (mode == KK)   
`.0001` (mode == major)   
`.01` (mode == sgd)  |  |  Terminating condition. [neato](/docs/layouts/neato/) only.   
[esep](../dot-language/attributes/esep.md) | Graphs | [addDouble](../dot-language/attribute-types/add-double.md), [addPoint](../dot-language/attribute-types/add-point.md) | `+3` |  |  Margin used around polygons for purposes of spline edge routing. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/), osage, [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only.   
[fillcolor](../dot-language/attributes/fillcolor.md) | Nodes, Edges, Clusters | [color](../dot-language/attribute-types/color.md), [colorList](../dot-language/attribute-types/color-list.md) | `lightgrey` (nodes)   
`black` (clusters)  |  |  Color used to fill the background of a node or cluster.   
[fixedsize](../dot-language/attributes/fixedsize.md) | Nodes | [bool](../dot-language/attribute-types/bool.md), [string](../dot-language/attribute-types/string.md) | `false` |  |  Whether to use the specified width and height attributes to choose node size (rather than sizing to fit the node contents).   
[fontcolor](../dot-language/attributes/fontcolor.md) | Edges, Nodes, Graphs, Clusters | [color](../dot-language/attribute-types/color.md) | `black` |  |  Color used for text.   
[fontname](../dot-language/attributes/fontname.md) | Edges, Nodes, Graphs, Clusters | [string](../dot-language/attribute-types/string.md) | `"Times-Roman"` |  |  Font used for text.   
[fontnames](../dot-language/attributes/fontnames.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `""` |  |  Allows user control of how basic fontnames are represented in SVG output. [svg](/docs/outputs/svg/) only.   
[fontpath](../dot-language/attributes/fontpath.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `<system-dependent>` |  |  Directory list used by [libgd](https://libgd.github.io/) to search for bitmap fonts.   
[fontsize](../dot-language/attributes/fontsize.md) | Edges, Nodes, Graphs, Clusters | [double](../dot-language/attribute-types/double.md) | `14.0` | `1.0` |  Font size, [in points](/doc/info/attrs.html#points), used for text.   
[forcelabels](../dot-language/attributes/forcelabels.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `true` |  |  Whether to force placement of all [xlabels](../dot-language/attributes/xlabel.md), even if overlapping.   
[gradientangle](../dot-language/attributes/gradientangle.md) | Nodes, Clusters, Graphs | [int](../dot-language/attribute-types/int.md) | `0` | `0` |  If a gradient fill is being used, this determines the angle of the fill.   
[group](../dot-language/attributes/group.md) | Nodes | [string](../dot-language/attribute-types/string.md) | `""` |  |  Name for a group of nodes, for bundling edges avoiding crossings.. [dot](/docs/layouts/dot/) only.   
[head_lp](../dot-language/attributes/head_lp.md) | Edges | [point](../dot-language/attribute-types/point.md) |  |  |  Center position of an edge's head label. write only.   
[headclip](../dot-language/attributes/headclip.md) | Edges | [bool](../dot-language/attribute-types/bool.md) | `true` |  |  If true, the head of an edge is clipped to the boundary of the head node.   
[headhref](../dot-language/attributes/headhref.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Synonym for [headURL](../dot-language/attributes/head-url.md). map, [svg](/docs/outputs/svg/) only.   
[headlabel](../dot-language/attributes/headlabel.md) | Edges | [lblString](../dot-language/attribute-types/lbl-string.md) | `""` |  |  Text label to be placed near head of edge.   
[headport](../dot-language/attributes/headport.md) | Edges | [portPos](../dot-language/attribute-types/port-pos.md) | `center` |  |  Indicates where on the head node to attach the head of the edge.   
[headtarget](../dot-language/attributes/headtarget.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `<none>` |  |  Browser window to use for the [headURL](../dot-language/attributes/head-url.md) link. map, [svg](/docs/outputs/svg/) only.   
[headtooltip](../dot-language/attributes/headtooltip.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Tooltip annotation attached to the head of an edge. [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only.   
[headURL](../dot-language/attributes/head-url.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  If defined, `headURL` is output as part of the head label of the edge. map, [svg](/docs/outputs/svg/) only.   
[height](../dot-language/attributes/height.md) | Nodes | [double](../dot-language/attribute-types/double.md) | `0.5` | `0.02` |  Height of node, in inches.   
[href](../dot-language/attributes/href.md) | Graphs, Clusters, Nodes, Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Synonym for [URL](../dot-language/attributes/url.md). map, [postscript](/docs/outputs/ps/), [svg](/docs/outputs/svg/) only.   
[id](../dot-language/attributes/id.md) | Graphs, Clusters, Nodes, Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Identifier for graph objects. map, [postscript](/docs/outputs/ps/), [svg](/docs/outputs/svg/) only.   
[image](../dot-language/attributes/image.md) | Nodes | [string](../dot-language/attribute-types/string.md) | `""` |  |  Gives the name of a file containing an image to be displayed inside a node.   
[imagepath](../dot-language/attributes/imagepath.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `""` |  |  A list of directories in which to look for image files.   
[imagepos](../dot-language/attributes/imagepos.md) | Nodes | [string](../dot-language/attribute-types/string.md) | `"mc"` |  |  Controls how an image is positioned within its containing node.   
[imagescale](../dot-language/attributes/imagescale.md) | Nodes | [bool](../dot-language/attribute-types/bool.md), [string](../dot-language/attribute-types/string.md) | `false` |  |  Controls how an image fills its containing node.   
[inputscale](../dot-language/attributes/inputscale.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `<none>` |  |  Scales the input [positions](../dot-language/attributes/pos.md) to convert between length units. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only.   
[K](../dot-language/attributes/k.md) | Graphs, Clusters | [double](../dot-language/attribute-types/double.md) | `0.3` | `0` |  Spring constant used in virtual physical model. [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only.   
[label](../dot-language/attributes/label.md) | Edges, Nodes, Graphs, Clusters | [lblString](../dot-language/attribute-types/lbl-string.md) | `"\N"` (nodes)   
`""` (otherwise)  |  |  Text label attached to objects.   
[label_scheme](../dot-language/attributes/label_scheme.md) | Graphs | [int](../dot-language/attribute-types/int.md) | `0` | `0` |  Whether to treat a node whose name has the form `|edgelabel|*` as a special node representing an edge label.. [sfdp](/docs/layouts/sfdp/) only.   
[labelangle](../dot-language/attributes/labelangle.md) | Edges | [double](../dot-language/attribute-types/double.md) | `-25.0` | `-180.0` |  The angle (in degrees) in polar coordinates of the head & tail edge labels..   
[labeldistance](../dot-language/attributes/labeldistance.md) | Edges | [double](../dot-language/attribute-types/double.md) | `1.0` | `0.0` |  Scaling factor for the distance of [headlabel](../dot-language/attributes/headlabel.md) / [taillabel](../dot-language/attributes/taillabel.md) from the head / tail nodes..   
[labelfloat](../dot-language/attributes/labelfloat.md) | Edges | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  If true, allows edge labels to be less constrained in position.   
[labelfontcolor](../dot-language/attributes/labelfontcolor.md) | Edges | [color](../dot-language/attribute-types/color.md) | `black` |  |  Color used for [headlabel](../dot-language/attributes/headlabel.md) and [taillabel](../dot-language/attributes/taillabel.md)..   
[labelfontname](../dot-language/attributes/labelfontname.md) | Edges | [string](../dot-language/attribute-types/string.md) | `"Times-Roman"` |  |  Font for `headlabel` and `taillabel`.   
[labelfontsize](../dot-language/attributes/labelfontsize.md) | Edges | [double](../dot-language/attribute-types/double.md) | `14.0` | `1.0` |  Font size of `headlabel` and `taillabel`.   
[labelhref](../dot-language/attributes/labelhref.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Synonym for [labelURL](../dot-language/attributes/label-url.md). map, [svg](/docs/outputs/svg/) only.   
[labeljust](../dot-language/attributes/labeljust.md) | Graphs, Clusters | [string](../dot-language/attribute-types/string.md) | `"c"` |  |  Justification for graph & cluster labels.   
[labelloc](../dot-language/attributes/labelloc.md) | Nodes, Graphs, Clusters | [string](../dot-language/attribute-types/string.md) | `"t"` (clusters)   
`"b"` (root graphs)   
`"c"` (nodes)  |  |  Vertical placement of labels for nodes, root graphs and clusters.   
[labeltarget](../dot-language/attributes/labeltarget.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `<none>` |  |  Browser window to open [labelURL](../dot-language/attributes/label-url.md) links in. map, [svg](/docs/outputs/svg/) only.   
[labeltooltip](../dot-language/attributes/labeltooltip.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Tooltip annotation attached to label of an edge. [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only.   
[labelURL](../dot-language/attributes/label-url.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  If defined, `labelURL` is the link used for the label of an edge. map, [svg](/docs/outputs/svg/) only.   
[landscape](../dot-language/attributes/landscape.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  If true, the graph is rendered in landscape mode.   
[layer](../dot-language/attributes/layer.md) | Edges, Nodes, Clusters | [layerRange](../dot-language/attribute-types/layer-range.md) | `""` |  |  Specifies layers in which the node, edge or cluster is present.   
[layerlistsep](../dot-language/attributes/layerlistsep.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `","` |  |  The separator characters used to split attributes of type [layerRange](../dot-language/attribute-types/layer-range.md) into a list of ranges..   
[layers](../dot-language/attributes/layers.md) | Graphs | [layerList](../dot-language/attribute-types/layer-list.md) | `""` |  |  A linearly ordered list of layer names attached to the graph.   
[layerselect](../dot-language/attributes/layerselect.md) | Graphs | [layerRange](../dot-language/attribute-types/layer-range.md) | `""` |  |  Selects a list of layers to be emitted.   
[layersep](../dot-language/attributes/layersep.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `":\t "` |  |  The separator characters for splitting the [layers](../dot-language/attributes/layers.md) attribute into a list of layer names..   
[layout](../dot-language/attributes/layout.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `""` |  |  Which [layout engine](/docs/layouts/) to use.   
[len](../dot-language/attributes/len.md) | Edges | [double](../dot-language/attribute-types/double.md) | `1.0` (neato)   
`0.3` (fdp)  |  |  Preferred edge length, in inches. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only.   
[levels](../dot-language/attributes/levels.md) | Graphs | [int](../dot-language/attribute-types/int.md) | `INT_MAX` | `0.0` |  Number of levels allowed in the multilevel scheme. [sfdp](/docs/layouts/sfdp/) only.   
[levelsgap](../dot-language/attributes/levelsgap.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `0.0` |  |  strictness of neato level constraints. [neato](/docs/layouts/neato/) only.   
[lhead](../dot-language/attributes/lhead.md) | Edges | [string](../dot-language/attribute-types/string.md) | `""` |  |  Logical head of an edge. [dot](/docs/layouts/dot/) only.   
[lheight](../dot-language/attributes/lheight.md) | Graphs, Clusters | [double](../dot-language/attribute-types/double.md) |  |  |  Height of graph or cluster label, in inches. write only.   
[linelength](../dot-language/attributes/linelength.md) | Graphs | [int](../dot-language/attribute-types/int.md) | `128` | `60` |  How long strings should get before overflowing to next line, for text output..   
[lp](../dot-language/attributes/lp.md) | Edges, Graphs, Clusters | [point](../dot-language/attribute-types/point.md) |  |  |  Label center position. write only.   
[ltail](../dot-language/attributes/ltail.md) | Edges | [string](../dot-language/attribute-types/string.md) | `""` |  |  Logical tail of an edge. [dot](/docs/layouts/dot/) only.   
[lwidth](../dot-language/attributes/lwidth.md) | Graphs, Clusters | [double](../dot-language/attribute-types/double.md) |  |  |  Width of graph or cluster label, in inches. write only.   
[margin](../dot-language/attributes/margin.md) | Nodes, Clusters, Graphs | [double](../dot-language/attribute-types/double.md), [point](../dot-language/attribute-types/point.md) | `<device-dependent>` |  |  For graphs, this sets x and y margins of canvas, in inches.   
[maxiter](../dot-language/attributes/maxiter.md) | Graphs | [int](../dot-language/attribute-types/int.md) | `100 * # nodes` (mode == KK)   
`200` (mode == major)   
`30` (mode == sgd)   
`600` (fdp)  |  |  Sets the number of iterations used. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only.   
[mclimit](../dot-language/attributes/mclimit.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `1.0` |  |  Scale factor for mincross (mc) edge crossing minimizer parameters. [dot](/docs/layouts/dot/) only.   
[mindist](../dot-language/attributes/mindist.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `1.0` | `0.0` |  Specifies the minimum separation between all nodes. [circo](/docs/layouts/circo/) only.   
[minlen](../dot-language/attributes/minlen.md) | Edges | [int](../dot-language/attribute-types/int.md) | `1` | `0` |  Minimum edge length (rank difference between head and tail). [dot](/docs/layouts/dot/) only.   
[mode](../dot-language/attributes/mode.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `major` |  |  Technique for optimizing the layout. [neato](/docs/layouts/neato/) only.   
[model](../dot-language/attributes/model.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `shortpath` |  |  Specifies how the distance matrix is computed for the input graph. [neato](/docs/layouts/neato/) only.   
[newrank](../dot-language/attributes/newrank.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether to use a single global ranking, ignoring clusters. [dot](/docs/layouts/dot/) only.   
[nodesep](../dot-language/attributes/nodesep.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `0.25` | `0.02` |  In `dot`, `nodesep` specifies the minimum space between two adjacent nodes in the same rank, in inches.   
[nojustify](../dot-language/attributes/nojustify.md) | Graphs, Clusters, Nodes, Edges | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether to justify multiline text vs the previous text line (rather than the side of the container)..   
[normalize](../dot-language/attributes/normalize.md) | Graphs | [double](../dot-language/attribute-types/double.md), [bool](../dot-language/attribute-types/bool.md) | `false` |  |  normalizes coordinates of final layout. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/), [twopi](/docs/layouts/twopi/), [circo](/docs/layouts/circo/) only.   
[notranslate](../dot-language/attributes/notranslate.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether to avoid translating layout to the origin point. [neato](/docs/layouts/neato/) only.   
[nslimit](../dot-language/attributes/nslimit.md) | Graphs | [double](../dot-language/attribute-types/double.md) |  |  |  Sets number of iterations in network simplex applications. [dot](/docs/layouts/dot/) only.   
[nslimit1](../dot-language/attributes/nslimit1.md) | Graphs | [double](../dot-language/attribute-types/double.md) |  |  |  Sets number of iterations in network simplex applications. [dot](/docs/layouts/dot/) only.   
[oneblock](../dot-language/attributes/oneblock.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Whether to draw circo graphs around one circle.. [circo](/docs/layouts/circo/) only.   
[ordering](../dot-language/attributes/ordering.md) | Graphs, Nodes | [string](../dot-language/attribute-types/string.md) | `""` |  |  Constrains the left-to-right ordering of node edges.. [dot](/docs/layouts/dot/) only.   
[orientation](../dot-language/attributes/orientation.md) | Nodes, Graphs | [double](../dot-language/attribute-types/double.md), [string](../dot-language/attribute-types/string.md) | `0.0`  
`""` | `-360.0` |  node shape rotation angle, or graph orientation.   
[outputorder](../dot-language/attributes/outputorder.md) | Graphs | [outputMode](../dot-language/attribute-types/output-mode.md) | `breadthfirst` |  |  Specify order in which nodes and edges are drawn.   
[overlap](../dot-language/attributes/overlap.md) | Graphs | [string](../dot-language/attribute-types/string.md), [bool](../dot-language/attribute-types/bool.md) | `true` |  |  Determines if and how node overlaps should be removed. [fdp](/docs/layouts/fdp/), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only.   
[overlap_scaling](../dot-language/attributes/overlap_scaling.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `-4` | `-1e+10` |  Scale layout by factor, to reduce node overlap.. [prism](../dot-language/attributes/overlap.md), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), [fdp](/docs/layouts/fdp/), [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only.   
[overlap_shrink](../dot-language/attributes/overlap_shrink.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `true` |  |  Whether the overlap removal algorithm should perform a compression pass to reduce the size of the layout. [prism](../dot-language/attributes/overlap.md) only.   
[pack](../dot-language/attributes/pack.md) | Graphs | [bool](../dot-language/attribute-types/bool.md), [int](../dot-language/attribute-types/int.md) | `false` |  |  Whether each connected component of the graph should be laid out separately, and then the graphs packed together..   
[packmode](../dot-language/attributes/packmode.md) | Graphs | [packMode](../dot-language/attribute-types/pack-mode.md) | `node` |  |  How connected components should be packed.   
[pad](../dot-language/attributes/pad.md) | Graphs | [double](../dot-language/attribute-types/double.md), [point](../dot-language/attribute-types/point.md) | `0.0555` (4 points) |  |  Inches to extend the drawing area around the minimal area needed to draw the graph.   
[page](../dot-language/attributes/page.md) | Graphs | [double](../dot-language/attribute-types/double.md), [point](../dot-language/attribute-types/point.md) |  |  |  Width and height of output pages, in inches.   
[pagedir](../dot-language/attributes/pagedir.md) | Graphs | [pagedir](../dot-language/attribute-types/pagedir.md) | `BL` |  |  The order in which pages are emitted.   
[pencolor](../dot-language/attributes/pencolor.md) | Clusters | [color](../dot-language/attribute-types/color.md) | `black` |  |  Color used to draw the bounding box around a cluster.   
[penwidth](../dot-language/attributes/penwidth.md) | Clusters, Nodes, Edges | [double](../dot-language/attribute-types/double.md) | `1.0` | `0.0` |  Specifies the width of the pen, in points, used to draw lines and curves.   
[peripheries](../dot-language/attributes/peripheries.md) | Nodes, Clusters | [int](../dot-language/attribute-types/int.md) | `<shape default>` (nodes)   
`1` (clusters)  | `0` |  Set number of peripheries used in polygonal shapes and cluster boundaries.   
[pin](../dot-language/attributes/pin.md) | Nodes | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  Keeps the node at the node's given input position. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only.   
[pos](../dot-language/attributes/pos.md) | Edges, Nodes | [point](../dot-language/attribute-types/point.md), [splineType](../dot-language/attribute-types/spline-type.md) |  |  |  Position of node, or spline control points. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only.   
[quadtree](../dot-language/attributes/quadtree.md) | Graphs | [quadType](../dot-language/attribute-types/quad-type.md), [bool](../dot-language/attribute-types/bool.md) | `normal` |  |  Quadtree scheme to use. [sfdp](/docs/layouts/sfdp/) only.   
[quantum](../dot-language/attributes/quantum.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `0.0` | `0.0` |  If `quantum > 0.0`, node label dimensions will be rounded to integral multiples of the quantum.   
[radius](../dot-language/attributes/radius.md) | Edges | [double](../dot-language/attribute-types/double.md) | `0` | `0` |  Radius of rounded corners on orthogonal edges.   
[rank](../dot-language/attributes/rank.md) | Subgraphs | [rankType](../dot-language/attribute-types/rank-type.md) |  |  |  Rank constraints on the nodes in a subgraph. [dot](/docs/layouts/dot/) only.   
[rankdir](../dot-language/attributes/rankdir.md) | Graphs | [rankdir](../dot-language/attribute-types/rankdir.md) | `TB` |  |  Sets direction of graph layout. [dot](/docs/layouts/dot/) only.   
[ranksep](../dot-language/attributes/ranksep.md) | Graphs | [double](../dot-language/attribute-types/double.md), [doubleList](../dot-language/attribute-types/double-list.md) | `0.5` (dot)   
`1.0` (twopi)  | `0.02` |  Specifies separation between ranks. [dot](/docs/layouts/dot/), [twopi](/docs/layouts/twopi/) only.   
[ratio](../dot-language/attributes/ratio.md) | Graphs | [double](../dot-language/attribute-types/double.md), [string](../dot-language/attribute-types/string.md) |  |  |  Sets the aspect ratio (drawing height/drawing width) for the drawing.   
[rects](../dot-language/attributes/rects.md) | Nodes | [rect](../dot-language/attribute-types/rect.md) |  |  |  Rectangles for fields of records, [in points](/doc/info/attrs.html#points). write only.   
[regular](../dot-language/attributes/regular.md) | Nodes | [bool](../dot-language/attribute-types/bool.md) | `false` |  |  If true, force polygon to be regular..   
[remincross](../dot-language/attributes/remincross.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) | `true` |  |  If there are multiple clusters, whether to run edge crossing minimization a second time.. [dot](/docs/layouts/dot/) only.   
[repulsiveforce](../dot-language/attributes/repulsiveforce.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `1.0` | `0.0` |  The power of the repulsive force used in an extended Fruchterman-Reingold. [sfdp](/docs/layouts/sfdp/) only.   
[resolution](../dot-language/attributes/resolution.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `96.0` | `0.0` |  Synonym for [dpi](../dot-language/attributes/dpi.md).. bitmap output, [svg](/docs/outputs/svg/) only.   
[root](../dot-language/attributes/root.md) | Graphs, Nodes | [string](../dot-language/attribute-types/string.md), [bool](../dot-language/attribute-types/bool.md) | `<none>` (graphs)   
`false` (nodes)  |  |  Specifies nodes to be used as the center of the layout. [twopi](/docs/layouts/twopi/), [circo](/docs/layouts/circo/) only.   
[rotate](../dot-language/attributes/rotate.md) | Graphs | [int](../dot-language/attribute-types/int.md) | `0` |  |  If `rotate=90`, sets drawing orientation to landscape.   
[rotation](../dot-language/attributes/rotation.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `0` |  |  Rotates the final layout counter-clockwise by the specified number of degrees. [sfdp](/docs/layouts/sfdp/) only.   
[samehead](../dot-language/attributes/samehead.md) | Edges | [string](../dot-language/attribute-types/string.md) | `""` |  |  Edges with the same head and the same `samehead` value are aimed at the same point on the head. [dot](/docs/layouts/dot/) only.   
[sametail](../dot-language/attributes/sametail.md) | Edges | [string](../dot-language/attribute-types/string.md) | `""` |  |  Edges with the same tail and the same `sametail` value are aimed at the same point on the tail.. [dot](/docs/layouts/dot/) only.   
[samplepoints](../dot-language/attributes/samplepoints.md) | Nodes | [int](../dot-language/attribute-types/int.md) | `8` (output)   
`20` (overlap and image maps)  |  |  Gives the number of points used for a circle/ellipse node.   
[scale](../dot-language/attributes/scale.md) | Graphs | [double](../dot-language/attribute-types/double.md), [point](../dot-language/attribute-types/point.md) |  |  |  Scales layout by the given factor after the initial layout. [neato](/docs/layouts/neato/), [twopi](/docs/layouts/twopi/) only.   
[searchsize](../dot-language/attributes/searchsize.md) | Graphs | [int](../dot-language/attribute-types/int.md) | `30` |  |  During network simplex, the maximum number of edges with negative cut values to search when looking for an edge with minimum cut value.. [dot](/docs/layouts/dot/) only.   
[sep](../dot-language/attributes/sep.md) | Graphs | [addDouble](../dot-language/attribute-types/add-double.md), [addPoint](../dot-language/attribute-types/add-point.md) | `+4` |  |  Margin to leave around nodes when removing node overlap. [fdp](/docs/layouts/fdp/), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), osage, [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only.   
[shape](../dot-language/attributes/shape.md) | Nodes | [shape](../dot-language/attribute-types/shape.md) | `ellipse` |  |  Sets the [shape](/doc/info/shapes.html) of a node.   
[shapefile](../dot-language/attributes/shapefile.md) | Nodes | [string](../dot-language/attribute-types/string.md) | `""` |  |  A file containing user-supplied node content.   
[showboxes](../dot-language/attributes/showboxes.md) | Edges, Nodes, Graphs | [int](../dot-language/attribute-types/int.md) | `0` | `0` |  Print guide boxes for debugging. [dot](/docs/layouts/dot/) only.   
[sides](../dot-language/attributes/sides.md) | Nodes | [int](../dot-language/attribute-types/int.md) | `4` | `0` |  Number of sides when `[shape](../dot-language/attributes/shape.md)=polygon`.   
[size](../dot-language/attributes/size.md) | Graphs | [double](../dot-language/attribute-types/double.md), [point](../dot-language/attribute-types/point.md) |  |  |  Maximum width and height of drawing, in inches.   
[skew](../dot-language/attributes/skew.md) | Nodes | [double](../dot-language/attribute-types/double.md) | `0.0` | `-100.0` |  Skew factor for `[shape](../dot-language/attributes/shape.md)=polygon`.   
[smoothing](../dot-language/attributes/smoothing.md) | Graphs | [smoothType](../dot-language/attribute-types/smooth-type.md) | `"none"` |  |  Specifies a post-processing step used to smooth out an uneven distribution of nodes.. [sfdp](/docs/layouts/sfdp/) only.   
[sortv](../dot-language/attributes/sortv.md) | Graphs, Clusters, Nodes | [int](../dot-language/attribute-types/int.md) | `0` | `0` |  Sort order of graph components for ordering [packmode](../dot-language/attributes/packmode.md) packing..   
[splines](../dot-language/attributes/splines.md) | Graphs | [bool](../dot-language/attribute-types/bool.md), [string](../dot-language/attribute-types/string.md) |  |  |  Controls how, and if, edges are represented.   
[start](../dot-language/attributes/start.md) | Graphs | [startType](../dot-language/attribute-types/start-type.md) | `""` |  |  Parameter used to determine the initial layout of nodes. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only.   
[style](../dot-language/attributes/style.md) | Edges, Nodes, Clusters, Graphs | [style](../dot-language/attribute-types/style.md) | `""` |  |  Set style information for components of the graph.   
[stylesheet](../dot-language/attributes/stylesheet.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `""` |  |  A URL or pathname specifying an XML style sheet, used in SVG output. [svg](/docs/outputs/svg/) only.   
[tail_lp](../dot-language/attributes/tail_lp.md) | Edges | [point](../dot-language/attribute-types/point.md) |  |  |  Position of an edge's tail label, [in points](/doc/info/attrs.html#points).. write only.   
[tailclip](../dot-language/attributes/tailclip.md) | Edges | [bool](../dot-language/attribute-types/bool.md) | `true` |  |  If true, the tail of an edge is clipped to the boundary of the tail node.   
[tailhref](../dot-language/attributes/tailhref.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Synonym for [tailURL](../dot-language/attributes/tail-url.md).. map, [svg](/docs/outputs/svg/) only.   
[taillabel](../dot-language/attributes/taillabel.md) | Edges | [lblString](../dot-language/attribute-types/lbl-string.md) | `""` |  |  Text label to be placed near tail of edge.   
[tailport](../dot-language/attributes/tailport.md) | Edges | [portPos](../dot-language/attribute-types/port-pos.md) | `center` |  |  Indicates where on the tail node to attach the tail of the edge.   
[tailtarget](../dot-language/attributes/tailtarget.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `<none>` |  |  Browser window to use for the [tailURL](../dot-language/attributes/tail-url.md) link. map, [svg](/docs/outputs/svg/) only.   
[tailtooltip](../dot-language/attributes/tailtooltip.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Tooltip annotation attached to the tail of an edge. [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only.   
[tailURL](../dot-language/attributes/tail-url.md) | Edges | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  If defined, `tailURL` is output as part of the tail label of the edge. map, [svg](/docs/outputs/svg/) only.   
[target](../dot-language/attributes/target.md) | Edges, Nodes, Graphs, Clusters | [escString](../dot-language/attribute-types/esc-string.md), [string](../dot-language/attribute-types/string.md) | `<none>` |  |  If the object has a [URL](../dot-language/attributes/url.md), this attribute determines which window of the browser is used for the URL.. map, [svg](/docs/outputs/svg/) only.   
[TBbalance](../dot-language/attributes/t-bbalance.md) | Graphs | [string](../dot-language/attribute-types/string.md) | `''` |  |  Which [rank](../dot-language/attributes/rank.md) to move floating (loose) nodes to. [dot](/docs/layouts/dot/) only.   
[tooltip](../dot-language/attributes/tooltip.md) | Nodes, Edges, Clusters, Graphs | [escString](../dot-language/attribute-types/esc-string.md) | `""` |  |  Tooltip (mouse hover text) attached to the node, edge, cluster, or graph. [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only.   
[truecolor](../dot-language/attributes/truecolor.md) | Graphs | [bool](../dot-language/attribute-types/bool.md) |  |  |  Whether internal bitmap rendering relies on a truecolor color model or uses. bitmap output only.   
[URL](../dot-language/attributes/url.md) | Edges, Nodes, Graphs, Clusters | [escString](../dot-language/attribute-types/esc-string.md) | `<none>` |  |  Hyperlinks incorporated into device-dependent output. map, [postscript](/docs/outputs/ps/), [svg](/docs/outputs/svg/) only.   
[vertices](../dot-language/attributes/vertices.md) | Nodes | [pointList](../dot-language/attribute-types/point-list.md) |  |  |  Sets the coordinates of the vertices of the node's polygon, in inches. write only.   
[viewport](../dot-language/attributes/viewport.md) | Graphs | [viewPort](../dot-language/attribute-types/view-port.md) | `""` |  |  Clipping window on final drawing.   
[voro_margin](../dot-language/attributes/voro_margin.md) | Graphs | [double](../dot-language/attribute-types/double.md) | `0.05` | `0.0` |  Tuning margin of Voronoi technique. [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/), [twopi](/docs/layouts/twopi/), [circo](/docs/layouts/circo/) only.   
[weight](../dot-language/attributes/weight.md) | Edges | [int](../dot-language/attribute-types/int.md), [double](../dot-language/attribute-types/double.md) | `1` | `0(dot,twopi)`  
`1(neato,fdp)` |  Weight of edge.   
[width](../dot-language/attributes/width.md) | Nodes | [double](../dot-language/attribute-types/double.md) | `0.75` | `0.01` |  Width of node, in inches.   
[xdotversion](../dot-language/attributes/xdotversion.md) | Graphs | [string](../dot-language/attribute-types/string.md) |  |  |  Determines the version of `xdot` used in output. [xdot](/docs/outputs/canon/) only.   
[xlabel](../dot-language/attributes/xlabel.md) | Edges, Nodes | [lblString](../dot-language/attribute-types/lbl-string.md) | `""` |  |  External label for a node or edge.   
[xlp](../dot-language/attributes/xlp.md) | Nodes, Edges | [point](../dot-language/attribute-types/point.md) |  |  |  Position of an exterior label, [in points](/doc/info/attrs.html#points). write only.   
[z](../dot-language/attributes/z.md) | Nodes | [double](../dot-language/attribute-types/double.md) | `0.0` |  |  Z-coordinate value for 3D layouts and displays.   
  
###  _background

A string in the [xdot` format](../dot-language/attribute-types/xdot.md) specifying an arbitrary background

type: _[xdot](../dot-language/attribute-types/xdot.md), default: `<none>`_

During rendering, the canvas is first filled as described in the [bgcolor` attribute](../dot-language/attributes/bgcolor.md).

Then, if `_background` is defined, the graphics operations described in the string are performed on the canvas.

See [xdot` format](../dot-language/attribute-types/xdot.md) page for more information.

Render a red square in the background 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  _background="c 7 -#ff0000 p 4 4 4 36 4 36 36 4 36";
  a -&gt; b
}</code></pre>
</div>

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"_background"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22_background%22)

###  area

Indicates the preferred area for a node or empty cluster

type: _[double](../dot-language/attribute-types/double.md), default: `1.0`, minimum: `>0`_

Example: Australian Coins, area proportional to value 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  layout="patchwork"
  node [style=filled]
  "5c"  [area=  5 fillcolor=silver]
  "10c" [area= 10 fillcolor=silver]
  "20c" [area= 20 fillcolor=silver]
  "50c" [area= 50 fillcolor=silver]
  "$1"  [area=100 fillcolor=gold]
  "$2"  [area=200 fillcolor=gold]
}</code></pre>
</div>

_Valid on:_

  * Nodes
  * Clusters



**Note:** [patchwork](/docs/layouts/patchwork/) only. _

[ Search the Graphviz codebase for `"area"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22area%22)

###  arrowhead

Style of arrowhead on the head node of an edge

type: _[arrowType](../dot-language/attribute-types/arrow-type.md), default: `normal`_

This will only appear if the [dir` attribute](../dot-language/attributes/dir.md) is `forward` or `both`.

See the [limitation](#undir_note).

See also:

  * [arrowtail](../dot-language/attributes/arrowtail.md)

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"arrowhead"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22arrowhead%22)

###  arrowsize

Multiplicative scale factor for arrowheads

type: _[double](../dot-language/attribute-types/double.md), default: `1.0`, minimum: `0.0`_

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  quiver -&gt; "0.5" [arrowsize=0.5]
  quiver -&gt; "1"
  quiver -&gt; "2" [arrowsize=2]
  quiver -&gt; "3" [arrowsize=3]
}</code></pre>
</div>

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"arrowsize"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22arrowsize%22)

###  arrowtail

Style of arrowhead on the tail node of an edge

type: _[arrowType](../dot-language/attribute-types/arrow-type.md), default: `normal`_

This will only appear if the [dir` attribute](../dot-language/attributes/dir.md) is `back` or `both`.

See the [limitation](#undir_note).

See also:

  * [arrowhead](../dot-language/attributes/arrowhead.md)

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"arrowtail"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22arrowtail%22)

###  bb

Bounding box of drawing in points

type: _[rect](../dot-language/attribute-types/rect.md)_

_Valid on:_

  * Clusters
  * Graphs



**Note:**  write only._

[ Search the Graphviz codebase for `"bb"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22bb%22)

###  beautify

Whether to draw leaf nodes uniformly in a circle around the root node in sfdp.

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

Whether to try to draw leaf nodes uniformly on a circle around the root node.

Prior to Graphviz 8.0.1, this is affected by [Issue 2283](https://gitlab.com/graphviz/graphviz/-/issues/2283): rendering one fewer sector than necessary, overlapping the first and last nodes.

Examples:

Beautify 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
    layout="sfdp"
    beautify=true

    N0 -&gt; {N1; N2; N3; N4; N5; N6}
}</code></pre>
</div>

No beautify 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
    layout="sfdp"
    beautify=false

    N0 -&gt; {N1; N2; N3; N4; N5; N6}
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"beautify"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22beautify%22)

###  bgcolor

Canvas background color

type: _[color](../dot-language/attribute-types/color.md) | [colorList](../dot-language/attribute-types/color-list.md), default: `<none>`_

When attached to the root graph, this color is used as the background for entire canvas.

When a cluster attribute, it is used as the initial background for the cluster. If a cluster has a filled [style](../dot-language/attributes/style.md), the cluster's [fillcolor](../dot-language/attributes/fillcolor.md) will overlay the background color.

If the value is a [colorList](../dot-language/attribute-types/color-list.md), a gradient fill is used. By default, this is a linear fill; setting `[style](../dot-language/attributes/style.md)=radial` will cause a radial fill. Only two colors are used. If the second color (after a colon) is missing, the default color is used for it. See also the [gradientangle](../dot-language/attributes/gradientangle.md) attribute for setting the gradient angle.

For certain output formats, such as PostScript, no fill is done for the root graph unless `bgcolor` is explicitly set.

For bitmap formats, however, the bits need to be initialized to something, so the canvas is filled with white by default. This means that if the bitmap output is included in some other document, all of the bits within the bitmap's bounding box will be set, overwriting whatever color or graphics were already on the page. If this effect is not desired, and you only want to set bits explicitly assigned in drawing the graph, set `bgcolor="transparent"`.

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  bgcolor="lightblue"
  label="Home"
  subgraph cluster_ground_floor {
    bgcolor="lightgreen"
    label="Ground Floor"
    Lounge
    Kitchen
  }
  subgraph cluster_top_floor {
    bgcolor="lightyellow"
    label="Top Floor"
    Bedroom
    Bathroom
  }
}</code></pre>
</div>

_Valid on:_

  * Graphs
  * Clusters



[ Search the Graphviz codebase for `"bgcolor"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22bgcolor%22)

###  center

Whether to center the drawing in the output canvas

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

Can be `true` or `false`.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"center"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22center%22)

###  charset

Character encoding used when interpreting string input as a text label.

type: _[string](../dot-language/attribute-types/string.md), default: `"UTF-8"`_

The default value is `"UTF-8"`. The other legal values are:

  * `"utf-8"` / `"utf8"` (default value)
  * `"iso-8859-1"` / `"ISO_8859-1"` / `"ISO8859-1"` / `"ISO-IR-100"` / `"Latin1"` / `"l1"` / `"latin-1"`
  * `"big-5"` / `"big5"`: the [Big-5 Chinese encoding](https://en.wikipedia.org/wiki/Big5)



The `charset` attribute is case-insensitive.

Note that if the character encoding used in the input does not match the `charset` value, the resulting output may be very strange.

It is not possible to use [HTML-like labels](/doc/info/shapes.html#html) in combination with Big-5 encoding.

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  charset="UTF-8"
  "🍔" -&gt; "💩"
}</code></pre>
</div>

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"charset"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22charset%22)

###  class

Classnames to attach to the node, edge, graph, or cluster's SVG element

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

Combine with [stylesheet](../dot-language/attributes/stylesheet.md) for styling SVG output using CSS classnames.

Multiple space-separated classes are supported.

See also:

  * [stylesheet](../dot-language/attributes/stylesheet.md)
  * [id](../dot-language/attributes/id.md)



Example:

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  graph [class="cats"];

  subgraph cluster_big {
    graph [class="big_cats"];

    "Lion" [class="yellow social"];
    "Snow Leopard" [class="white solitary"];
  }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Clusters
  * Graphs



**Note:** [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"class"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22class%22)

###  cluster

Whether the subgraph is a cluster

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

Subgraph clusters are rendered differently, e.g. [dot](/docs/layouts/dot/) renders a box around subgraph clusters, but doesn't draw a box around non-subgraph clusters.

Example:

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph cats {
  subgraph cluster_big_cats {
    // This subgraph is a cluster, because the name begins with "cluster"
    
    "Lion";
    "Snow Leopard";
  }

  subgraph domestic_cats {
    // This subgraph is also a cluster, because cluster=true.
    cluster=true;

    "Siamese";
    "Persian";
  }

  subgraph not_a_cluster {
    // This subgraph is not a cluster, because it doesn't start with "cluster",
    // nor sets cluster=true.
    
    "Wildcat";
  }
}</code></pre>
</div>

_Valid on:_

  * Clusters
  * Subgraphs



[ Search the Graphviz codebase for `"cluster"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22cluster%22)

###  clusterrank

Mode used for handling clusters

type: _[clusterMode](../dot-language/attribute-types/cluster-mode.md), default: `local`_

If `clusterrank=local`, a subgraph whose name begins with `cluster` is given special treatment.

The subgraph is laid out separately, and then integrated as a unit into its parent graph, with a bounding rectangle drawn about it. If the cluster has a [label](../dot-language/attributes/label.md) parameter, this label is displayed within the rectangle.

Note also that there can be clusters within clusters.

The modes `clusterrank=global` and `clusterrank=none` appear to be identical, both turning off the special cluster processing.

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"clusterrank"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22clusterrank%22)

###  color

Basic drawing color for graphics, not text

type: _[color](../dot-language/attribute-types/color.md) | [colorList](../dot-language/attribute-types/color-list.md), default: `black`_

For the latter, use the [fontcolor](../dot-language/attributes/fontcolor.md) attribute.

For edges, the value can either be a single color or a [colorList](../dot-language/attribute-types/color-list.md).

In the latter case, if `colorList` has no fractions, the edge is drawn using parallel splines or lines, one for each color in the list, in the order given.

The head arrow, if any, is drawn using the first color in the list, and the tail arrow, if any, the second color. This supports the common case of drawing opposing edges, but using parallel splines instead of separately routed multiedges.

If any fraction is used, the colors are drawn in series, with each color being given roughly its specified fraction of the edge.

For example, the graph:

Edge Color Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  a -&gt; b [dir=both color="red:blue"]
  c -&gt; d [dir=none color="green:red;0.25:blue"]
}</code></pre>
</div>

yields:

![](/doc/info/colorlist.svg)

Subgraph & Node Color Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  subgraph cluster_yellow {
    color="yellow"
    a [color="red"]
    b [color="green"]
  }
}</code></pre>
</div>

yields:

![](/doc/info/subgraph_node_color.svg)

See also:

  * [colorscheme](../dot-language/attributes/colorscheme.md)

_Valid on:_

  * Edges
  * Nodes
  * Clusters



[ Search the Graphviz codebase for `"color"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22color%22)

###  colorscheme

A color scheme namespace: the context for interpreting color names

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

In particular, if a [color](../dot-language/attribute-types/color.md) value has form `"xxx"` or `"//xxx"`, then the color `xxx` will be evaluated according to the current color scheme. If no color scheme is set, the standard [X11 naming](/doc/info/colors.html#x11) is used.

For example, if `colorscheme=oranges9` (from [Brewer color schemes](/doc/info/colors.html#brewer)), then `color=7` is interpreted as `color="/oranges9/7"`, the 7th color in the `oranges9` colorscheme.

Orange Colorscheme 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  node [colorscheme=oranges9] # Apply colorscheme to all nodes
  1 [color=1]
  2 [color=2]
  3 [color=3]
  4 [color=4]
  5 [color=5]
  6 [color=6]
  7 [color=7]
  8 [color=8]
  9 [color=9]
}</code></pre>
</div>

Green Colorscheme 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  node [colorscheme=greens9] # Apply colorscheme to all nodes
  1 [color=1]
  2 [color=2]
  3 [color=3]
  4 [color=4]
  5 [color=5]
  6 [color=6]
  7 [color=7]
  8 [color=8]
  9 [color=9]
}</code></pre>
</div>

See also:

  * [color](../dot-language/attributes/color.md)

_Valid on:_

  * Edges
  * Nodes
  * Clusters
  * Graphs



[ Search the Graphviz codebase for `"colorscheme"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22colorscheme%22)

###  comment

Comments are inserted into output

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

Device-dependent.

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  comment="I am a graph"
  A [comment="I am node A"]
  B [comment="I am node B"]
  A-&gt;B [comment="I am an edge"]
}</code></pre>
</div>

Outputs SVG with comments:
    
    
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
     "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
    <!-- Generated by graphviz version 2.47.1 (20210417.1919)
     -->
    <!-- This is a graph -->
    <!-- Pages: 1 -->
    <svg width="62pt" height="116pt"
     viewBox="0.00 0.00 62.00 116.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g id="graph0" class="graph" transform="scale(1 1) rotate(0) translate(4 112)">
    <polygon fill="white" stroke="transparent" points="-4,4 -4,-112 58,-112 58,4 -4,4"/>
    <!-- A -->
    <!-- I am node A -->
    <g id="node1" class="node">
    <title>A</title>
    <ellipse fill="none" stroke="black" cx="27" cy="-90" rx="27" ry="18"/>
    <text text-anchor="middle" x="27" y="-86.3" font-family="Times,serif" font-size="14.00">A</text>
    </g>
    <!-- B -->
    <!-- I am node B -->
    <g id="node2" class="node">
    <title>B</title>
    <ellipse fill="none" stroke="black" cx="27" cy="-18" rx="27" ry="18"/>
    <text text-anchor="middle" x="27" y="-14.3" font-family="Times,serif" font-size="14.00">B</text>
    </g>
    <!-- A&#45;&gt;B -->
    <!-- I am an edge -->
    <g id="edge1" class="edge">
    <title>A&#45;&gt;B</title>
    <path fill="none" stroke="black" d="M27,-71.7C27,-63.98 27,-54.71 27,-46.11"/>
    <polygon fill="black" stroke="black" points="30.5,-46.1 27,-36.1 23.5,-46.1 30.5,-46.1"/>
    </g>
    </g>
    </svg>
    

_Valid on:_

  * Edges
  * Nodes
  * Graphs



[ Search the Graphviz codebase for `"comment"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22comment%22)

###  compound

If true, allow edges between clusters

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

See [lhead](../dot-language/attributes/lhead.md) and [ltail](../dot-language/attributes/ltail.md).

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  compound=true;

  subgraph cluster_a {
    label="Cluster A";
    node1; node3; node5; node7;
  }
  subgraph cluster_b {
    label="Cluster B";
    node2; node4; node6; node8;
  }

  node1 -&gt; node2 [label="1"];
  node3 -&gt; node4 [label="2" ltail="cluster_a"];
  
  node5 -&gt; node6 [label="3" lhead="cluster_b"];
  node7 -&gt; node8 [label="4" ltail="cluster_a" lhead="cluster_b"];
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"compound"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22compound%22)

###  concentrate

If true, use edge concentrators

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

This merges multiedges into a single edge and causes partially parallel edges to share part of their paths. The latter feature is not yet available outside of `dot`.  
Only works for non-contiguous nodes.

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    concentrate=true
    a -&gt; b [label="1"]
    c -&gt; b
    d -&gt; b
}</code></pre>
</div>

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"concentrate"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22concentrate%22)

###  constraint

If false, the edge is not used in ranking the nodes

type: _[bool](../dot-language/attribute-types/bool.md), default: `true`_

For example in the graph:

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  a -&gt; c;
  a -&gt; b;
  b -&gt; c [constraint=false];
}</code></pre>
</div>

the edge `b -> c` does not add a constraint during rank assignment, so the only constraints are that `a` be above `b` and `c`, yielding the graph:

![](/doc/info/constraint.gif)

_Valid on:_

  * Edges



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"constraint"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22constraint%22)

###  Damping

Factor damping force motions.

type: _[double](../dot-language/attribute-types/double.md), default: `0.99`, minimum: `0.0`_

On each iteration, a node's movement is limited to this factor of its potential motion. By being less than `1.0`, the system tends to "cool", thereby preventing cycling.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _

[ Search the Graphviz codebase for `"Damping"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22Damping%22)

###  decorate

Whether to connect the edge label to the edge with a line

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

If true, attach edge label to edge by a 2-segment polyline, underlining the label, then going to the closest point of spline.

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  a -&gt; a [label="AA" decorate=true]
  a -&gt; b [label="AB" decorate=true]
  b -&gt; b [label="BB" decorate=false]
}</code></pre>
</div>

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"decorate"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22decorate%22)

###  defaultdist

The distance between nodes in separate connected components

type: _[double](../dot-language/attribute-types/double.md), default: `1+(avg. len)*sqrt(|V|)`, minimum: `epsilon`_

If set too small, connected components may overlap.

Only applicable if `[pack](../dot-language/attributes/pack.md)=false`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _

[ Search the Graphviz codebase for `"defaultdist"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22defaultdist%22)

###  dim

Set the number of dimensions used for the layout

type: _[int](../dot-language/attribute-types/int.md), default: `2`, minimum: `2`_

The maximum value allowed is `10`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"dim"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22dim%22)

###  dimen

Set the number of dimensions used for rendering

type: _[int](../dot-language/attribute-types/int.md), default: `2`, minimum: `2`_

The maximum value allowed is `10`.

If both `dimen` and `dim` are set, the latter specifies the dimension used for layout, and the former for rendering. If only `dimen` is set, this is used for both layout and rendering dimensions.

Note that, at present, all aspects of rendering are 2D. This includes the shape and size of nodes, overlap removal, and edge routing. Thus, for `dimen > 2`, the only valid information is the `pos` attribute of the nodes.

All other coordinates will be 2D and, at best, will reflect a projection of a higher-dimensional point onto the plane.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"dimen"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22dimen%22)

###  dir

Edge type for drawing arrowheads

type: _[dirType](../dot-language/attribute-types/dir-type.md), default: `forward` (directed) , `none` (undirected) _

Indicates which ends of the edge should be decorated with an arrowhead.

The actual style of the arrowhead can be specified using the [arrowhead](../dot-language/attributes/arrowhead.md) and [arrowtail](../dot-language/attributes/arrowtail.md) attributes.

See [limitation](#undir_note).

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  A-&gt;B [dir=forward]
  C-&gt;D [dir=back]
  E-&gt;F [dir=both]
  G-&gt;H [dir=none]
}</code></pre>
</div>

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"dir"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22dir%22)

###  diredgeconstraints

Whether to constrain most edges to point downwards

type: _[string](../dot-language/attribute-types/string.md) | [bool](../dot-language/attribute-types/bool.md), default: `false`_

If true, constraints are generated for each edge in the largest (heuristic) directed acyclic subgraph such that the edge must point downwards.

Only valid when `[mode](../dot-language/attributes/mode.md)="ipsep"`.

If `hier`, generates level constraints similar to those used with `[mode](../dot-language/attributes/mode.md)="hier"`. The main difference is that, in the latter case, only these constraints are involved, so a faster solver can be used.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _

[ Search the Graphviz codebase for `"diredgeconstraints"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22diredgeconstraints%22)

###  distortion

Distortion factor for `[shape](../dot-language/attributes/shape.md)=[polygon](/doc/info/shapes.html#polygon)`

type: _[double](../dot-language/attribute-types/double.md), default: `0.0`, minimum: `-100.0`_

Positive values cause top part to be larger than bottom; negative values do the opposite.

See also [skew](../dot-language/attributes/skew.md).

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  LargeBottom [shape=polygon sides=4 distortion=-.5]
  LargeTop    [shape=polygon sides=4 distortion=.5]
}</code></pre>
</div>

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"distortion"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22distortion%22)

###  dpi

Specifies the expected number of pixels per inch on a display device

type: _[double](../dot-language/attribute-types/double.md), default: `96.0`, minimum: `0.0`_

For `bitmap` output, `dpi` guarantees that text rendering will be done more accurately, both in size and in placement.

For SVG output, `dpi` guarantees the dimensions in the output correspond to the correct number of points or inches.

_Valid on:_

  * Graphs



**Note:**  bitmap output,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"dpi"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22dpi%22)

###  edgehref

Synonym for [edgeURL](../dot-language/attributes/edge-url.md)

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"edgehref"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22edgehref%22)

###  edgetarget

Browser window to use for the [edgeURL](../dot-language/attributes/edge-url.md) link

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `<none>`_

If the edge has a [URL](../dot-language/attributes/url.md) or [edgeURL](../dot-language/attributes/edge-url.md) attribute, `edgetarget` determines which window of the browser is used for the URL attached to the non-label part of the edge.

Setting `edgetarget=_graphviz` will open a new window if it doesn't already exist, or reuse it if it does.

If undefined, the value of the [target](../dot-language/attributes/target.md) is used instead.

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"edgetarget"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22edgetarget%22)

###  edgetooltip

Tooltip annotation attached to the non-label part of an edge

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

  * [headtooltip](../dot-language/attributes/headtooltip.md).
  * [labeltooltip](../dot-language/attributes/labeltooltip.md).
  * [tailtooltip](../dot-language/attributes/tailtooltip.md).
  * [tooltip](../dot-language/attributes/tooltip.md).

_Valid on:_

  * Edges



**Note:** [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"edgetooltip"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22edgetooltip%22)

###  edgeURL

The link for the non-label parts of an edge

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

`edgeURL` overrides any [URL](../dot-language/attributes/url.md) defined for the edge.

Also, `edgeURL` is used near the head or tail node unless overridden by [headURL](../dot-language/attributes/head-url.md) or [tailURL](../dot-language/attributes/tail-url.md), respectively.

See [limitation](#undir_note).

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"edgeURL"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22edgeURL%22)

###  epsilon

Terminating condition

type: _[double](../dot-language/attribute-types/double.md), default: `.0001 * # nodes` (mode == KK) , `.0001` (mode == major) , `.01` (mode == sgd) _

If the length squared of all energy gradients are less than `epsilon`, the algorithm stops.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _

[ Search the Graphviz codebase for `"epsilon"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22epsilon%22)

###  esep

Margin used around polygons for purposes of spline edge routing

type: _[addDouble](../dot-language/attribute-types/add-double.md) | [addPoint](../dot-language/attribute-types/add-point.md), default: `+3`_

The interpretation is the same as given for [sep](../dot-language/attributes/sep.md). `esep` should normally be strictly less than [sep](../dot-language/attributes/sep.md).

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/), osage, [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only. _

[ Search the Graphviz codebase for `"esep"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22esep%22)

###  fillcolor

Color used to fill the background of a node or cluster

type: _[color](../dot-language/attribute-types/color.md) | [colorList](../dot-language/attribute-types/color-list.md), default: `lightgrey` (nodes) , `black` (clusters) _

Assuming `[style](../dot-language/attributes/style.md)=filled`, or a filled [arrowhead](../dot-language/attributes/arrowhead.md).

If `fillcolor` is not defined, [color](../dot-language/attributes/color.md) is used. (For clusters, if `color` is not defined, [bgcolor](../dot-language/attributes/bgcolor.md) is used.) If this is not defined, the default is used, except for `[shape](../dot-language/attributes/shape.md)=point` or when the output format is `MIF`, which use black by default.

If the value is a [colorList](../dot-language/attribute-types/color-list.md), a gradient fill is used. By default, this is a linear fill; setting `[style](../dot-language/attributes/style.md)=radial` will cause a radial fill. At present, only two colors are used. If the second color (after a colon) is missing, the default color is used for it.

See also the [gradientangle](../dot-language/attributes/gradientangle.md) attribute for setting the gradient angle.

Note that a cluster inherits the root graph's attributes if defined. Thus, if the root graph has defined a `fillcolor`, this will override a [color](../dot-language/attributes/color.md) or [bgcolor](../dot-language/attributes/bgcolor.md) attribute set for the cluster.

_Valid on:_

  * Nodes
  * Edges
  * Clusters



[ Search the Graphviz codebase for `"fillcolor"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22fillcolor%22)

###  fixedsize

Whether to use the specified width and height attributes to choose node size (rather than sizing to fit the node contents)

type: _[bool](../dot-language/attribute-types/bool.md) | [string](../dot-language/attribute-types/string.md), default: `false`_

If `false`, the size of a node is determined by smallest width and height needed to contain its label and image, if any, with a margin specified by the [margin](../dot-language/attributes/margin.md) attribute.

The width and height must also be at least as large as the sizes specified by the [width](../dot-language/attributes/width.md) and [height](../dot-language/attributes/height.md) attributes, which specify the minimum values for these parameters.

If `true`, the node size is specified by the values of the [width](../dot-language/attributes/width.md) and [height](../dot-language/attributes/height.md) attributes only and is not expanded to contain the text label. There will be a warning if the label (with margin) cannot fit within these limits.

If the [fixedsize](../dot-language/attributes/fixedsize.md) attribute is set to `shape`, the [width](../dot-language/attributes/width.md) and [height](../dot-language/attributes/height.md) attributes also determine the size of the node shape, but the label can be much larger. Both the label and shape sizes are used when avoiding node overlap, but all edges to the node ignore the label and only contact the node shape. No warning is given if the label is too large.

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"fixedsize"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22fixedsize%22)

###  fontcolor

Color used for text

type: _[color](../dot-language/attribute-types/color.md), default: `black`_

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters



[ Search the Graphviz codebase for `"fontcolor"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22fontcolor%22)

###  fontname

Font used for text

type: _[string](../dot-language/attribute-types/string.md), default: `"Times-Roman"`_

This very much depends on the output format and, for non-bitmap output such as PostScript or SVG, the availability of the font when the graph is displayed or printed. As such, it is best to rely on font faces that are generally available, such as Times-Roman, Helvetica or Courier.

How font names are resolved also depends on the underlying library that handles font name resolution. If Graphviz was built using the [fontconfig library](https://www.freedesktop.org/wiki/Software/fontconfig/), fontconfig will be used to search for the font. See the commands `fc-list`, `fc-match` and the other fontconfig commands for how names are resolved and which fonts are available. Other systems may provide their own font package, such as Quartz for OS X.

Note that various font attributes, such as weight and slant, can be built into the font name. Unfortunately, the syntax varies depending on which font system is dominant. Thus, using `fontname="times bold italic"` will produce a bold, slanted Times font using Pango, the usual main font library. Alternatively, `fontname="times:italic"` will produce a slanted Times font from fontconfig, while `fontname="times-bold"` will resolve to a bold Times using Quartz. You will need to ascertain which package is used by your Graphviz system and refer to the relevant documentation.

If Graphviz is not built with a high-level font library, fontname will be considered the name of a Type 1 or True Type font file. If you specify `fontname=schlbk`, the tool will look for a file named `schlbk.ttf` or `schlbk.pfa` or `schlbk.pfb` in one of the directories specified by the [fontpath](../dot-language/attributes/fontpath.md) attribute. The lookup does support various aliases for the common fonts.

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    label="Comic Sans MS"
    fontname="Comic Sans MS"
    subgraph cluster_a {
      label="Courier New"
      fontname="Courier New"
      Arial [fontname="Arial"];
      Arial -&gt; Arial [label="Impact" fontname="Impact"]
    }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters



[ Search the Graphviz codebase for `"fontname"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22fontname%22)

###  fontnames

Allows user control of how basic fontnames are represented in SVG output

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

If `fontnames` is undefined or `hd`, fontconfig font conventions are used. The default `Times-Roman` font will be mapped to an equivalent available system font, such as `Times New Roman` (Windows) or `Times` (some Linux).

If `fontnames` is set to `svg`, the output will use known SVG fontnames. If `fontnames` is set to `ps`, PostScript font names like `Times-Roman` are used directly.

In all cases, the basic SVG font `serif` is used as a fallback for the named font. (So, a diagram containing text in `Times-Roman` might have that text represented in the SVG output by a `<text>` tag with the attribute `font-family="Times-Roman,serif"`.)

_Valid on:_

  * Graphs



**Note:** [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"fontnames"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22fontnames%22)

###  fontpath

Directory list used by [libgd](https://libgd.github.io/) to search for bitmap fonts

type: _[string](../dot-language/attribute-types/string.md), default: `<system-dependent>`_

Used if Graphviz was not built with the [fontconfig library](https://www.freedesktop.org/wiki/Software/fontconfig/).

If `fontpath` is not set, the environment variable `DOTFONTPATH` is checked.

If `DOTFONTPATH` is not set, `GDFONTPATH` is checked.

If `GDFONTPATH` not set, libgd uses its compiled-in font path.

Note that `fontpath` is an attribute of the root graph.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"fontpath"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22fontpath%22)

###  fontsize

Font size, [in points](/doc/info/attrs.html#points), used for text

type: _[double](../dot-language/attribute-types/double.md), default: `14.0`, minimum: `1.0`_

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    label="40pt Graph Label"
    fontsize="40"
    subgraph cluster_a {
      label="30pt Cluster Label"
      fontsize="30pt"
      "20pt Node" [fontsize="20pt"];
      "20pt Node"-&gt; "20pt Node" [label="10pt Edge" fontsize="10"]
    }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters



[ Search the Graphviz codebase for `"fontsize"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22fontsize%22)

###  forcelabels

Whether to force placement of all [xlabels](../dot-language/attributes/xlabel.md), even if overlapping

type: _[bool](../dot-language/attribute-types/bool.md), default: `true`_

If true, all [xlabel](../dot-language/attributes/xlabel.md) attributes are placed, even if there is some overlap with nodes or other labels.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"forcelabels"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22forcelabels%22)

###  gradientangle

If a gradient fill is being used, this determines the angle of the fill

type: _[int](../dot-language/attribute-types/int.md), default: `0`, minimum: `0`_

For linear fills, the colors transform along a line specified by the angle and the center of the object. For radial fills, a value of zero causes the colors to transform radially from the center; for non-zero values, the colors transform from a point near the object's periphery as specified by the value.

If unset, the default angle is 0.

_Valid on:_

  * Nodes
  * Clusters
  * Graphs



[ Search the Graphviz codebase for `"gradientangle"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22gradientangle%22)

###  group

Name for a group of nodes, for bundling edges avoiding crossings.

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

If the end points of an edge belong to the same group, i.e., have the same `group` attribute, parameters are set to avoid crossings and keep the edges straight.

_Valid on:_

  * Nodes



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"group"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22group%22)

###  head_lp

Center position of an edge's head label

type: _[point](../dot-language/attribute-types/point.md)_

[In points](/doc/info/attrs.html#points).

_Valid on:_

  * Edges



**Note:**  write only._

[ Search the Graphviz codebase for `"head_lp"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22head_lp%22)

###  headclip

If true, the head of an edge is clipped to the boundary of the head node

type: _[bool](../dot-language/attribute-types/bool.md), default: `true`_

Otherwise, the end of the edge goes to the center of the node, or the center of a port, if applicable.

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"headclip"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22headclip%22)

###  headhref

Synonym for [headURL](../dot-language/attributes/head-url.md)

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"headhref"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22headhref%22)

###  headlabel

Text label to be placed near head of edge

type: _[lblString](../dot-language/attribute-types/lbl-string.md), default: `""`_

See [limitation](#undir_note).

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"headlabel"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22headlabel%22)

###  headport

Indicates where on the head node to attach the head of the edge

type: _[portPos](../dot-language/attribute-types/port-pos.md), default: `center`_

In the default case, the edge is aimed towards the center of the node, and then clipped at the node boundary.

See [limitation](#undir_note).

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"headport"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22headport%22)

###  headtarget

Browser window to use for the [headURL](../dot-language/attributes/head-url.md) link

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `<none>`_

If the edge has a [headURL](../dot-language/attributes/head-url.md), `headtarget` determines which window of the browser is used for the URL. Setting `headURL=_graphviz` will open a new window if the window doesn't already exist, or reuse the window if it does.

If undefined, the value of the [target](../dot-language/attributes/target.md) is used.

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"headtarget"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22headtarget%22)

###  headtooltip

Tooltip annotation attached to the head of an edge

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

Used only if the edge has a [headURL](../dot-language/attributes/head-url.md) attribute.

See also:

  * [edgetooltip](../dot-language/attributes/edgetooltip.md).
  * [labeltooltip](../dot-language/attributes/labeltooltip.md).
  * [tailtooltip](../dot-language/attributes/tailtooltip.md).
  * [tooltip](../dot-language/attributes/tooltip.md).

_Valid on:_

  * Edges



**Note:** [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"headtooltip"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22headtooltip%22)

###  headURL

If defined, `headURL` is output as part of the head label of the edge

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

Also, this value is used near the head node, overriding any [URL](../dot-language/attributes/url.md) value.

See [limitation](#undir_note).

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"headURL"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22headURL%22)

###  height

Height of node, in inches

type: _[double](../dot-language/attribute-types/double.md), default: `0.5`, minimum: `0.02`_

This is taken as the initial, minimum height of the node. If [fixedsize](../dot-language/attributes/fixedsize.md) is true, this will be the final height of the node. Otherwise, if the node label requires more height to fit, the node's height will be increased to contain the label.

If the output format is `dot`, the value given to `height` will be the final value.

If the node shape is regular, the width and height are made identical:

  * If both the `width` and the `height` are set explicitly, the maximum of the two values is used.
  * If one of `width` or `height` is set explicitly, that value is used for both `width` and `height`.
  * If neither is set explicitly, the minimum of the two default values is used.



If a value below the minimum value (0.02) is set, it will be rounded up to this minimum.

Height Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  "default"
  "1in" [height=1]
  "2in" [height=2]
}</code></pre>
</div>

See also:

  * [width](../dot-language/attributes/width.md)

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"height"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22height%22)

###  href

Synonym for [URL](../dot-language/attributes/url.md)

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Graphs
  * Clusters
  * Nodes
  * Edges



**Note:**  map,[postscript](/docs/outputs/ps/), [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"href"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22href%22)

###  id

Identifier for graph objects

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

Allows the graph author to provide an identifier for graph objects which is to be included in the output.

Normal `\N`, `\E`, `\G` substitutions are applied.

If provided, it is the responsibility of the provider to keep `id` values unique for its intended downstream use.

Note, in particular, that `\E` does not provide a unique id for multi-edges.

If no `id` attribute is provided, then a unique internal id is used. However, this value is unpredictable by the graph writer.

If the graph provides an `id` attribute, this will be used as a prefix for internally generated attributes. By making internally-used attributes distinct, the user can include multiple image maps in the same document.

_Valid on:_

  * Graphs
  * Clusters
  * Nodes
  * Edges



**Note:**  map,[postscript](/docs/outputs/ps/), [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"id"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22id%22)

###  image

Gives the name of a file containing an image to be displayed inside a node

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

The image file must be in one of the recognized [formats](/docs/outputs/#image-formats), typically JPEG, PNG, GIF, BMP, SVG, or Postscript, and be able to be converted into the desired output format.

The file must contain the image size information:

  * Bitmap formats usually already contain image size.
  * PostScript files must contain a line starting with `%%BoundingBox:` followed by four integers specifying the lower left x and y coordinates and the upper right x and y coordinates of the bounding box for the image, the coordinates being in points.
  * An SVG image file must contain width and height attributes, typically as part of the svg element. The values for these should have the form of a floating point number, followed by optional units, e.g., `width="76pt"`. Recognized units are in, px, pc, pt, cm and mm for inches, pixels, picas, points, centimeters and millimeters, respectively. The default unit is points.



Unlike with the [shapefile](../dot-language/attributes/shapefile.md) attribute, the image is treated as node content rather than the entire node. In particular, an image can be contained in a node of any shape, not just a rectangle.

Only paths to local resources are supported. If you want to use a URL to a remote resource, see the [dot_url_resolve.py](https://gitlab.com/graphviz/graphviz/-/blob/main/contrib/dot_url_resolve.py) script.

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"image"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22image%22)

###  imagepath

A list of directories in which to look for image files

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

When specified by the [image](../dot-language/attributes/image.md) attribute or using the `IMG` element in [HTML-like labels](/doc/info/shapes.html#html).

`imagepath` should be a list of (absolute or relative) pathnames, each separated by a semicolon `;` (for Windows) or a colon `:` (all other OS).

The first directory in which a file of the given name is found will be used to load the image.

If `imagepath` is not set, relative pathnames for the image file will be interpreted with respect to the current working directory.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"imagepath"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22imagepath%22)

###  imagepos

Controls how an image is positioned within its containing node

type: _[string](../dot-language/attribute-types/string.md), default: `"mc"`_

`imagepos` only has an effect when the image is smaller than the containing node.

The default is to be centered both horizontally and vertically.

Valid values:

  * `tl` \- Top Left
  * `tc` \- Top Centered
  * `tr` \- Top Right
  * `ml` \- Middle Left
  * `mc` \- Middle Centered _(the default)_
  * `mr` \- Middle Right
  * `bl` \- Bottom Left
  * `bc` \- Bottom Centered
  * `br` \- Bottom Right

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"imagepos"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22imagepos%22)

###  imagescale

Controls how an image fills its containing node

type: _[bool](../dot-language/attribute-types/bool.md) | [string](../dot-language/attribute-types/string.md), default: `false`_

In general, the image is given its natural size, (cf. [dpi](../dot-language/attributes/dpi.md)), and the node size is made large enough to contain its image, its label, its margin, and its peripheries.

Its width and height will also be at least as large as its minimum [width](../dot-language/attributes/width.md) and [height](../dot-language/attributes/height.md). If, however, `fixedsize=true`, the width and height attributes specify the exact size of the node.

  * During rendering, in the default case (`imagescale=false`), the image retains its natural size.
  * If `imagescale=true`, the image is uniformly scaled (i.e., its aspect ratio is preserved) to fit inside the node. At least one dimension of the image will be as large as possible given the size of the node.
  * When `imagescale=width`, the width of the image is scaled to fill the node width.
  * The corresponding property holds when `imagescale=height`.
  * When `imagescale=both`, both the height and the width are scaled separately to fill the node.



In all cases, if a dimension of the image is larger than the corresponding dimension of the node, that dimension of the image is scaled down to fit the node.

As with the case of expansion, if `imagescale=true`, width and height are scaled uniformly.

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"imagescale"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22imagescale%22)

###  inputscale

Scales the input [positions](../dot-language/attributes/pos.md) to convert between length units

type: _[double](../dot-language/attribute-types/double.md), default: `<none>`_

For layout algorithms that support initial input positions (specified by the [pos](../dot-language/attributes/pos.md) attribute), this attribute can be used to appropriately scale the values.

By default, [fdp](/docs/layouts/fdp/) and [neato](/docs/layouts/neato/) interpret the x and y values of [pos](../dot-language/attributes/pos.md) as being in inches. (**NOTE:** `neato -n(2)` treats the coordinates as being in points, being the unit used by the layout algorithms for the pos attribute.) Thus, if the graph has pos attributes in points, one should set `inputscale=72`. This can also be set on the command line using the [-s` flag](/doc/info/command.html#-s).

If unset, no scaling is done and the units on input are treated as inches.

`inputscale=0` is equivalent to `inputscale=72`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only. _

[ Search the Graphviz codebase for `"inputscale"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22inputscale%22)

###  K

Spring constant used in virtual physical model

type: _[double](../dot-language/attribute-types/double.md), default: `0.3`, minimum: `0`_

It roughly corresponds to an ideal edge length (in inches), in that increasing `K` tends to increase the distance between nodes.

Note that the edge attribute [len](../dot-language/attributes/len.md) can be used to override this value for adjacent nodes.

_Valid on:_

  * Graphs
  * Clusters



**Note:** [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"K"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22K%22)

###  label

Text label attached to objects

type: _[lblString](../dot-language/attribute-types/lbl-string.md), default: `"\N"` (nodes) , `""` (otherwise) _

If a node's [shape](../dot-language/attributes/shape.md) is record, then the label can have a [special format](/doc/info/shapes.html#record) which describes the record layout.

Note that a node's default label is `"\N"`, so the node's name or ID becomes its label.

Technically, a node's name can be an HTML string but this will not mean that the node's label will be interpreted as an [HTML-like label](/doc/info/shapes.html#html). This is because the node's actual label is an ordinary string, which will be replaced by the raw bytes stored in the node's name.

To get an HTML-like label, the label attribute value itself must be an HTML string.

Example: Van Gogh Paintings 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  label="Vincent van Gogh Paintings"

  subgraph cluster_self_portraits {
    label="Self-portraits"

    spwgfh [label="Self-Portrait with Grey Felt Hat"]
    spaap [label="Self-Portrait as a Painter"]
  }
  
  subgraph cluster_flowers {
    label="Flowers"

    sf [label="Sunflowers"]
    ab [label="Almond Blossom"]
  }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters



[ Search the Graphviz codebase for `"label"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22label%22)

###  label_scheme

Whether to treat a node whose name has the form `|edgelabel|*` as a special node representing an edge label.

type: _[int](../dot-language/attribute-types/int.md), default: `0`, minimum: `0`_

  * The default, `label_scheme=0`, produces no effect.
  * If `label_scheme=1`, `sfdp` uses a penalty-based method to make that kind of node close to the center of its neighbor.
  * With `label_scheme=2`, `sfdp` uses a penalty-based method to make that kind of node close to the old center of its neighbor.
  * Finally, `label_scheme=3` invokes a two-step process of overlap removal and straightening.

_Valid on:_

  * Graphs



**Note:** [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"label_scheme"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22label_scheme%22)

###  labelangle

The angle (in degrees) in polar coordinates of the head & tail edge labels.

type: _[double](../dot-language/attribute-types/double.md), default: `-25.0`, minimum: `-180.0`_

Determines, along with [labeldistance](../dot-language/attributes/labeldistance.md), where the [headlabel](../dot-language/attributes/headlabel.md) / [taillabel](../dot-language/attributes/taillabel.md) are placed with respect to the head / tail in polar coordinates.

The origin in the coordinate system is the point where the edge touches the node. The ray of 0 degrees goes from the origin back along the edge, parallel to the edge at the origin.

The angle, in degrees, specifies the rotation from the 0 degree ray, with positive angles moving counterclockwise and negative angles moving clockwise.

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"labelangle"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labelangle%22)

###  labeldistance

Scaling factor for the distance of [headlabel](../dot-language/attributes/headlabel.md) / [taillabel](../dot-language/attributes/taillabel.md) from the head / tail nodes.

type: _[double](../dot-language/attribute-types/double.md), default: `1.0`, minimum: `0.0`_

The default distance is 10 points.

`labeldistance` multiplies that default.

See [labelangle](../dot-language/attributes/labelangle.md) for more details.

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"labeldistance"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labeldistance%22)

###  labelfloat

If true, allows edge labels to be less constrained in position

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

In particular, it may appear on top of other edges.

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"labelfloat"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labelfloat%22)

###  labelfontcolor

Color used for [headlabel](../dot-language/attributes/headlabel.md) and [taillabel](../dot-language/attributes/taillabel.md).

type: _[color](../dot-language/attribute-types/color.md), default: `black`_

If not set, defaults to edge's [fontcolor](../dot-language/attributes/fontcolor.md).

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"labelfontcolor"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labelfontcolor%22)

###  labelfontname

Font for `headlabel` and `taillabel`

type: _[string](../dot-language/attribute-types/string.md), default: `"Times-Roman"`_

Font used for [headlabel](../dot-language/attributes/headlabel.md) and [taillabel](../dot-language/attributes/taillabel.md).

If not set, defaults to edge's [fontname](../dot-language/attributes/fontname.md).

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"labelfontname"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labelfontname%22)

###  labelfontsize

Font size of `headlabel` and `taillabel`

type: _[double](../dot-language/attribute-types/double.md), default: `14.0`, minimum: `1.0`_

Font size, [in points](/doc/info/attrs.html#points), used for [headlabel](../dot-language/attributes/headlabel.md) and [taillabel](../dot-language/attributes/taillabel.md).

If not set, defaults to edge's [fontsize](../dot-language/attributes/fontsize.md).

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"labelfontsize"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labelfontsize%22)

###  labelhref

Synonym for [labelURL](../dot-language/attributes/label-url.md)

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"labelhref"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labelhref%22)

###  labeljust

Justification for graph & cluster labels

type: _[string](../dot-language/attribute-types/string.md), default: `"c"`_

  * If `labeljust=r`, the label is right-justified within bounding rectangle
  * If `labeljust=l`, left-justified
  * Else the label is centered.



Note that a subgraph inherits attributes from its parent. Thus, if the root graph sets `labeljust=l`, the subgraph inherits this value.

Graph label justifications 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  label="l"
  labeljust=l
  a
}</code></pre>
</div>

Graph label justifications 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  label="r"
  labeljust=r
  b
}</code></pre>
</div>

Cluster label justifications 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  subgraph cluster_l {
    label="l"
    labeljust=l
    a
  }
  subgraph cluster_c {
    label="c"
    labeljust=c
    b
  }
  subgraph cluster_r {
    label="r"
    labeljust=r
    c
  }
}</code></pre>
</div>

_Valid on:_

  * Graphs
  * Clusters



[ Search the Graphviz codebase for `"labeljust"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labeljust%22)

###  labelloc

Vertical placement of labels for nodes, root graphs and clusters

type: _[string](../dot-language/attribute-types/string.md), default: `"t"` (clusters) , `"b"` (root graphs) , `"c"` (nodes) _

For graphs and clusters, only `labelloc=t` and `labelloc=b` are allowed, corresponding to placement at the top and bottom, respectively.

By default, root graph labels go on the bottom and cluster labels go on the top.

Note that a subgraph inherits attributes from its parent. Thus, if the root graph sets `labelloc=b`, the subgraph inherits this value.

For nodes, this attribute is used only when the height of the node is larger than the height of its label.

If `labelloc=t`, `labelloc=c`, `labelloc=b`, the label is aligned with the top, centered, or aligned with the bottom of the node, respectively.

By default, the label is vertically centered.

Label at top of graph 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  labelloc="t"
  label="Title"
  a -&gt; b
}</code></pre>
</div>

Label at bottom of graph 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  labelloc="b"
  label="Title"
  a -&gt; b
}</code></pre>
</div>

Cluster Label Locations 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  label="Graph Title"
  subgraph cluster_t {
    labelloc="t"
    label="Cluster Top"
    a -&gt; b
  }
  subgraph cluster_b {
    labelloc="b"
    label="Cluster Bottom"
    c -&gt; d
  }
}</code></pre>
</div>

Node label positions 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  t [labelloc=t]
  c [labelloc=c]
  b [labelloc=b]
}</code></pre>
</div>

_Valid on:_

  * Nodes
  * Graphs
  * Clusters



[ Search the Graphviz codebase for `"labelloc"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labelloc%22)

###  labeltarget

Browser window to open [labelURL](../dot-language/attributes/label-url.md) links in

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `<none>`_

If the edge has a [URL](../dot-language/attributes/url.md) or [labelURL](../dot-language/attributes/label-url.md) attribute, this attribute determines which window of the browser is used for the URL attached to the label.

Setting `labeltarget=_graphviz` will open a new window if it doesn't already exist, or reuse it if it does.

If undefined, the value of the [target](../dot-language/attributes/target.md) is used.

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"labeltarget"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labeltarget%22)

###  labeltooltip

Tooltip annotation attached to label of an edge

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

  * [edgetooltip](../dot-language/attributes/edgetooltip.md).
  * [headtooltip](../dot-language/attributes/headtooltip.md).
  * [tailtooltip](../dot-language/attributes/tailtooltip.md).
  * [tooltip](../dot-language/attributes/tooltip.md).

_Valid on:_

  * Edges



**Note:** [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"labeltooltip"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labeltooltip%22)

###  labelURL

If defined, `labelURL` is the link used for the label of an edge

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

`labelURL` overrides any [URL](../dot-language/attributes/url.md) defined for the edge.

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"labelURL"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22labelURL%22)

###  landscape

If true, the graph is rendered in landscape mode

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

Synonymous with `[rotate](../dot-language/attributes/rotate.md)=90` or `[orientation](../dot-language/attributes/orientation.md)=landscape`.

Rotations 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  landscape=true
  a -&gt; b
}</code></pre>
</div>

See also:

  * [rotate](../dot-language/attributes/rotate.md)
  * [orientation](../dot-language/attributes/orientation.md)

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"landscape"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22landscape%22)

###  layer

Specifies layers in which the node, edge or cluster is present

type: _[layerRange](../dot-language/attribute-types/layer-range.md), default: `""`_

_Valid on:_

  * Edges
  * Nodes
  * Clusters



[ Search the Graphviz codebase for `"layer"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22layer%22)

###  layerlistsep

The separator characters used to split attributes of type [layerRange](../dot-language/attribute-types/layer-range.md) into a list of ranges.

type: _[string](../dot-language/attribute-types/string.md), default: `","`_

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"layerlistsep"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22layerlistsep%22)

###  layers

A linearly ordered list of layer names attached to the graph

type: _[layerList](../dot-language/attribute-types/layer-list.md), default: `""`_

The graph is then output in separate layers. Only those components belonging to the current output layer appear.

See [How to use drawing layers (overlays)](https://www.graphviz.org/faq/#FaqOverlays).

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"layers"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22layers%22)

###  layerselect

Selects a list of layers to be emitted

type: _[layerRange](../dot-language/attribute-types/layer-range.md), default: `""`_

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"layerselect"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22layerselect%22)

###  layersep

The separator characters for splitting the [layers](../dot-language/attributes/layers.md) attribute into a list of layer names.

type: _[string](../dot-language/attribute-types/string.md), default: `":\t "`_

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"layersep"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22layersep%22)

###  layout

Which [layout engine](/docs/layouts/) to use

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

Specifies the name of the [layout engine](/docs/layouts/) to use, such as `dot` or `neato`.

Normally, graphs should be kept independent of a type of layout. In some cases, however, it can be convenient to embed the type of layout desired within the graph.

For example, a graph containing position information from a layout might want to record what the associated layout engine was.

This attribute takes precedence over the [-K` flag](/doc/info/command.html#-K) or the actual command name used.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"layout"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22layout%22)

###  len

Preferred edge length, in inches

type: _[double](../dot-language/attribute-types/double.md), default: `1.0` (neato) , `0.3` (fdp) _

See also:

  * [minlen](../dot-language/attributes/minlen.md)

_Valid on:_

  * Edges



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only. _

[ Search the Graphviz codebase for `"len"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22len%22)

###  levels

Number of levels allowed in the multilevel scheme

type: _[int](../dot-language/attribute-types/int.md), default: `INT_MAX`, minimum: `0.0`_

_Valid on:_

  * Graphs



**Note:** [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"levels"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22levels%22)

###  levelsgap

strictness of neato level constraints

type: _[double](../dot-language/attribute-types/double.md), default: `0.0`_

Specifies strictness of level constraints in [neato](/docs/layouts/neato/) when `[mode](../dot-language/attributes/mode.md)="ipsep"` or `[mode](../dot-language/attributes/mode.md)=hier`.

Larger positive values mean stricter constraints, which demand more separation between levels. On the other hand, negative values will relax the constraints by allowing some overlap between the levels.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _

[ Search the Graphviz codebase for `"levelsgap"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22levelsgap%22)

###  lhead

Logical head of an edge

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

When [compound](../dot-language/attributes/compound.md) is true, if `lhead` is defined and is the name of a cluster containing the real head, the edge is clipped to the boundary of the cluster.

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  compound=true;

  subgraph cluster_a {
    label="Cluster A";
    node1; node3; node5; node7;
  }
  subgraph cluster_b {
    label="Cluster B";
    node2; node4; node6; node8;
  }

  node1 -&gt; node2 [label="1"];
  node3 -&gt; node4 [label="2" ltail="cluster_a"];
  
  node5 -&gt; node6 [label="3" lhead="cluster_b"];
  node7 -&gt; node8 [label="4" ltail="cluster_a" lhead="cluster_b"];
}</code></pre>
</div>

See [limitation](#undir_note).

_Valid on:_

  * Edges



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"lhead"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22lhead%22)

###  lheight

Height of graph or cluster label, in inches

type: _[double](../dot-language/attribute-types/double.md)_

_Valid on:_

  * Graphs
  * Clusters



**Note:**  write only._

[ Search the Graphviz codebase for `"lheight"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22lheight%22)

###  linelength

How long strings should get before overflowing to next line, for text output.

type: _[int](../dot-language/attribute-types/int.md), default: `128`, minimum: `60`_

Example, where an 80-character long string (`"a " * 40`) is broken up onto two lines, when printed as [canonical output](/docs/outputs/canon/):
    
    
    $ echo 'digraph G { linelength=60; N0 [label="a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a "]; }' | dot -Tcanon
    digraph G {
            graph [linelength=60];
            node [label="\N"];
            N0      [label="a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a \
    a a a a a a a a a a "];
    }
    

The text overflows when the _label_ reaches the given size.

Despite the `linelength` name, this is the length of the attribute string, _not_ the length of the overall line (which includes the node ID and attribute key).

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"linelength"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22linelength%22)

###  lp

Label center position

type: _[point](../dot-language/attribute-types/point.md)_

Label center position, [in points](/doc/info/attrs.html#points).

_Valid on:_

  * Edges
  * Graphs
  * Clusters



**Note:**  write only._

[ Search the Graphviz codebase for `"lp"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22lp%22)

###  ltail

Logical tail of an edge

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

When `[compound](../dot-language/attributes/compound.md)=true`, if `ltail` is defined and is the name of a cluster containing the real tail, the edge is clipped to the boundary of the cluster.

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  compound=true;

  subgraph cluster_a {
    label="Cluster A";
    node1; node3; node5; node7;
  }
  subgraph cluster_b {
    label="Cluster B";
    node2; node4; node6; node8;
  }

  node1 -&gt; node2 [label="1"];
  node3 -&gt; node4 [label="2" ltail="cluster_a"];
  
  node5 -&gt; node6 [label="3" lhead="cluster_b"];
  node7 -&gt; node8 [label="4" ltail="cluster_a" lhead="cluster_b"];
}</code></pre>
</div>

See [limitation](#undir_note).

_Valid on:_

  * Edges



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"ltail"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22ltail%22)

###  lwidth

Width of graph or cluster label, in inches

type: _[double](../dot-language/attribute-types/double.md)_

_Valid on:_

  * Graphs
  * Clusters



**Note:**  write only._

[ Search the Graphviz codebase for `"lwidth"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22lwidth%22)

###  margin

For graphs, this sets x and y margins of canvas, in inches

type: _[double](../dot-language/attribute-types/double.md) | [point](../dot-language/attribute-types/point.md), default: `<device-dependent>`_

If the margin is a single double, both margins are set equal to the given value.

Note that the margin is not part of the drawing but just empty space left around the drawing. The margin basically corresponds to a translation of drawing, as would be necessary to center a drawing on a page. Nothing is actually drawn in the margin. To actually extend the background of a drawing, see the [pad](../dot-language/attributes/pad.md) attribute.

For clusters, `margin` specifies the space between the nodes in the cluster and the cluster bounding box. By default, this is 8 points.

For nodes, this attribute specifies space left around the node's label. By default, the value is `0.11,0.055`.

Nodes Example: Wide Margins, Tall Margins, and Equal Margins 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  "1.5x0.5" [shape=rect margin="1.5,0.5"] # in inches
  "0.5x1.5" [shape=rect margin="0.5,1.5"] # in inches
  "1.5x1.5" [shape=rect margin="1.5"]     # in inches
}</code></pre>
</div>

Example: Cluster and Graph Margins 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
    bgcolor=lightgray
    margin=0 # in inches
    
    subgraph cluster_one {
      margin=8 # in points
      a
      b
    }
    subgraph cluster_two {
      margin=16 # in points
      c
      d
    }
}</code></pre>
</div>

_Valid on:_

  * Nodes
  * Clusters
  * Graphs



[ Search the Graphviz codebase for `"margin"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22margin%22)

###  maxiter

Sets the number of iterations used

type: _[int](../dot-language/attribute-types/int.md), default: `100 * # nodes` (mode == KK) , `200` (mode == major) , `30` (mode == sgd) , `600` (fdp) _

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only. _

[ Search the Graphviz codebase for `"maxiter"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22maxiter%22)

###  mclimit

Scale factor for mincross (mc) edge crossing minimizer parameters

type: _[double](../dot-language/attribute-types/double.md), default: `1.0`_

Multiplicative scale factor used to alter the `MinQuit` (default = 8) and `MaxIter` (default = 24) parameters used during crossing minimization.

These correspond to the number of tries without improvement before quitting and the maximum number of iterations in each pass.

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"mclimit"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22mclimit%22)

###  mindist

Specifies the minimum separation between all nodes

type: _[double](../dot-language/attribute-types/double.md), default: `1.0`, minimum: `0.0`_

_Valid on:_

  * Graphs



**Note:** [circo](/docs/layouts/circo/) only. _

[ Search the Graphviz codebase for `"mindist"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22mindist%22)

###  minlen

Minimum edge length (rank difference between head and tail)

type: _[int](../dot-language/attribute-types/int.md), default: `1`, minimum: `0`_

See also:

  * [len](../dot-language/attributes/len.md)

_Valid on:_

  * Edges



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"minlen"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22minlen%22)

###  mode

Technique for optimizing the layout

type: _[string](../dot-language/attribute-types/string.md), default: `major`_

[neato](/docs/layouts/neato/) supports modes:

  * `mode="major"`: `neato` uses stress majorization1.
  * `mode="KK"`: `neato` uses the Kamada-Kawai2 version of the gradient descent method. `KK` is sometimes appreciably faster for small (number of nodes < 100) graphs. A significant disadvantage is that `KK` may cycle.
  * `mode="sgd"`: `neato` uses a version of the Stochastic Gradient Descent3 method. `sgd`'s advantage is faster and more reliable convergence than both the previous methods, while `sgd`'s disadvantage is that it runs in a fixed number of iterations and may require larger values of [maxiter](../dot-language/attributes/maxiter.md) in some graphs.



There are two experimental modes in `neato`:

  * `mode="hier"`, which adds a top-down directionality similar to the layout used in `dot`, and
  * `mode="ipsep"`, which allows the graph to specify minimum vertical and horizontal distances between nodes. (See the [sep](../dot-language/attributes/sep.md) attribute.)



* * *

  1. [Gansner, E.R., Koren, Y., North, S. (2005). Graph Drawing by Stress Majorization. In: Pach, J. (eds) Graph Drawing. GD 2004. Lecture Notes in Computer Science, vol 3383. Springer, Berlin, Heidelberg.](/documentation/GKN04.pdf) ↩︎

  2. [Tomihisa Kamada, Satoru Kawai, An algorithm for drawing general undirected graphs, Information Processing Letters, Volume 31, Issue 1, 1989, Pages 7-15.](https://doi.org/10.1016%2F0020-0190%2889%2990102-6) ↩︎

  3. [J. X. Zheng, S. Pawar and D. F. M. Goodman, "Graph Drawing by Stochastic Gradient Descent," in IEEE Transactions on Visualization and Computer Graphics, vol. 25, no. 9, pp. 2738-2748, 1 Sept. 2019, doi: 10.1109/TVCG.2018.2859997.](https://ieeexplore.ieee.org/document/8419285) ↩︎




_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _

[ Search the Graphviz codebase for `"mode"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22mode%22)

###  model

Specifies how the distance matrix is computed for the input graph

type: _[string](../dot-language/attribute-types/string.md), default: `shortpath`_

The distance matrix specifies the ideal distance between every pair of nodes. `neato` attempts to find a layout which best achieves these distances. By default, it uses the length of the shortest path, where the length of each edge is given by its [len](../dot-language/attributes/len.md) attribute.

  * If `model="circuit"`, neato uses the circuit resistance model to compute the distances. This tends to emphasize clusters.
  * If `model="subset"`, neato uses the subset model. This sets the edge length to be the number of nodes that are neighbors of exactly one of the end points, and then calculates the shortest paths. This helps to separate nodes with high degree.



For more control of distances, one can use `model=mds`. In this case, the [len](../dot-language/attributes/len.md) of an edge is used as the ideal distance between its vertices.

A shortest path calculation is only used for pairs of nodes not connected by an edge. Thus, by supplying a complete graph, the input can specify all of the relevant distances.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _

[ Search the Graphviz codebase for `"model"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22model%22)

###  newrank

Whether to use a single global ranking, ignoring clusters

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

The original ranking algorithm in `dot` is recursive on clusters. This can produce fewer ranks and a more compact layout, but sometimes at the cost of a head node being place on a higher rank than the tail node. It also assumes that a node is not constrained in separate, incompatible subgraphs. For example, a node cannot be in a cluster and also be constrained by `rank=same` with a node not in the cluster.

This allows nodes to be subject to multiple constraints. Rank constraints will usually take precedence over edge constraints.

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"newrank"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22newrank%22)

###  nodesep

In `dot`, `nodesep` specifies the minimum space between two adjacent nodes in the same rank, in inches

type: _[double](../dot-language/attribute-types/double.md), default: `0.25`, minimum: `0.02`_

For other layouts, `nodesep` affects the spacing between loops on a single node, or multiedges between a pair of nodes.

Small node separation 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    nodesep=0.1;
    node1; node2; node3;
}</code></pre>
</div>

Large node separation 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    nodesep=0.5;
    node1; node2; node3;
}</code></pre>
</div>

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"nodesep"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22nodesep%22)

###  nojustify

Whether to justify multiline text vs the previous text line (rather than the side of the container).

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

By default, the justification of multi-line labels is done within the largest context that makes sense. Thus, in the label of a polygonal node, a left-justified line will align with the left side of the node (shifted by the prescribed [margin](../dot-language/attributes/margin.md)). In record nodes, left-justified line will line up with the left side of the enclosing column of fields. If `nojustify=true`, multi-line labels will be justified in the context of itself.

For example, if `nojustify` is set, the first label line is long, and the second is shorter and left-justified, the second will align with the left-most character in the first line, regardless of how large the node might be.

See this example containing the `\l` (left-justify) escape-string:

Nojustify causes text to align with previous text line, not left side of box 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  node [width=3 shape=box]
  a [nojustify=false label="The first line is longer\nnojustify=false\l"]
  b [nojustify=true label="The first line is longer\nnojustify=true\l"]
  a -&gt; b
}</code></pre>
</div>

Nojustify causes text to align with previous text line, not record column 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G{
  c [nojustify=false shape=record label="{Records Example - Long Line\n | Title - Shorter Line\nnojustify=false\l}"]
  d [nojustify=true shape=record label="{Records Example - Long Line\n | Title - Shorter Line\nnojustify=true\l}"]
  c -&gt; d
}</code></pre>
</div>

_Valid on:_

  * Graphs
  * Clusters
  * Nodes
  * Edges



[ Search the Graphviz codebase for `"nojustify"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22nojustify%22)

###  normalize

normalizes coordinates of final layout

type: _[double](../dot-language/attribute-types/double.md) | [bool](../dot-language/attribute-types/bool.md), default: `false`_

So that the first point is at the origin, and then rotates the layout so that the angle of the first edge is specified by the value of `normalize` in degrees.

If `normalize` is not a number, it is evaluated as a bool, with `true` corresponding to `0` degrees.

**NOTE:** Since the attribute is evaluated first as a number, `0` and `1` cannot be used for `false` and `true`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/), [twopi](/docs/layouts/twopi/), [circo](/docs/layouts/circo/) only. _

[ Search the Graphviz codebase for `"normalize"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22normalize%22)

###  notranslate

Whether to avoid translating layout to the origin point

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

By default, the final layout is translated so that the lower-left corner of the bounding box is at the origin.

This can be annoying if some nodes are pinned or if the user runs `neato -n`.

To avoid this translation, set `notranslate=true`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _

[ Search the Graphviz codebase for `"notranslate"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22notranslate%22)

###  nslimit

Sets number of iterations in network simplex applications

type: _[double](../dot-language/attribute-types/double.md)_

`nslimit` is used in computing `node x coordinates`.

If defined, `# iterations = nslimit * # nodes`; otherwise, `# iterations = INT_MAX`.

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"nslimit"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22nslimit%22)

###  nslimit1

Sets number of iterations in network simplex applications

type: _[double](../dot-language/attribute-types/double.md)_

`nslimit1` is used for ranking nodes.

If defined, `# iterations = nslimit * # nodes`; otherwise, `# iterations = INT_MAX`.

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"nslimit1"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22nslimit1%22)

###  oneblock

Whether to draw circo graphs around one circle.

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

Observe two examples of rendering the same graph:

Example: Multiple Blocks 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
    layout="circo"
    oneblock=false

    N0 -&gt; N1
    N1 -&gt; N2
    N2 -&gt; N3
    N3 -&gt; N4
    N4 -&gt; N0
    
    N4 -&gt; N5
    N5 -&gt; N6
    N6 -&gt; N7
    N7 -&gt; N8
    N8 -&gt; N5
}</code></pre>
</div>

Example: One Block 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
    layout="circo"
    oneblock=true

    N0 -&gt; N1
    N1 -&gt; N2
    N2 -&gt; N3
    N3 -&gt; N4
    N4 -&gt; N0
    
    N4 -&gt; N5
    N5 -&gt; N6
    N6 -&gt; N7
    N7 -&gt; N8
    N8 -&gt; N5
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [circo](/docs/layouts/circo/) only. _

[ Search the Graphviz codebase for `"oneblock"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22oneblock%22)

###  ordering

Constrains the left-to-right ordering of node edges.

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

If `ordering="out"`, then the outedges of a node, that is, edges with the node as its tail node, must appear left-to-right in the same order in which they are defined in the input.

If `ordering="in"`, then the inedges of a node must appear left-to-right in the same order in which they are defined in the input.

If defined as a graph or subgraph attribute, the value is applied to all nodes in the graph or subgraph.

Note that the graph attribute takes precedence over the node attribute.

_Valid on:_

  * Graphs
  * Nodes



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"ordering"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22ordering%22)

###  orientation

node shape rotation angle, or graph orientation

type: _[double](../dot-language/attribute-types/double.md) | [string](../dot-language/attribute-types/string.md), default: `0.0`, `""`, minimum: `-360.0`_

When used on nodes: Angle, in degrees, to rotate polygon node shapes. For any number of polygon sides, 0 degrees rotation results in a flat base. When used on graphs: If `"[lL]*"`, sets graph orientation to landscape.

Used only if [rotate](../dot-language/attributes/rotate.md) is not defined.

Node Orientations 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  layout=neato       # Render in a circular layout
  node [shape=house] # Make all nodes have 'house' shape

    0 [orientation=0]
   45 [orientation=45]
   90 [orientation=90]
  135 [orientation=135]
  180 [orientation=180]
  225 [orientation=225]
  270 [orientation=270]
  315 [orientation=315]
  0 -&gt; 45 -&gt; 90 -&gt; 135 -&gt; 180 -&gt; 225 -&gt; 270 -&gt; 315 -&gt; 0
}</code></pre>
</div>

Landscape Graph Orientation 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  orientation=L
  a -&gt; b
}</code></pre>
</div>

See also:

  * [orientation](../dot-language/attributes/orientation.md)
  * [rotate](../dot-language/attributes/rotate.md)

_Valid on:_

  * Nodes
  * Graphs



[ Search the Graphviz codebase for `"orientation"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22orientation%22)

###  outputorder

Specify order in which nodes and edges are drawn

type: _[outputMode](../dot-language/attribute-types/output-mode.md), default: `breadthfirst`_

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"outputorder"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22outputorder%22)

###  overlap

Determines if and how node overlaps should be removed

type: _[string](../dot-language/attribute-types/string.md) | [bool](../dot-language/attribute-types/bool.md), default: `true`_

Nodes are first enlarged using the [sep](../dot-language/attributes/sep.md) attribute. If `true` , overlaps are retained. If the value is `"scale"`, overlaps are removed by uniformly scaling in x and y. If the value converts to `"false"`, and it is available, Prism, a proximity graph-based algorithm, is used to remove node overlaps. This can also be invoked explicitly with `overlap=prism`. This technique starts with a small scaling up, controlled by the [overlap_scaling](../dot-language/attributes/overlap_scaling.md) attribute, which can remove a significant portion of the overlap. The prism option also accepts an optional non-negative integer suffix. This can be used to control the number of attempts made at overlap removal. By default, `overlap="prism"` is equivalent to `overlap="prism1000"`. Setting `overlap="prism0"` causes only the scaling phase to be run.

If Prism is not available, or the version of Graphviz is earlier than 2.28, `"overlap=false"` uses a Voronoi-based technique. This can always be invoked explicitly with `"overlap=voronoi"`.

If `overlap="scalexy"`, x and y are separately scaled to remove overlaps.

If `overlap="compress"`, the layout will be scaled down as much as possible without introducing any overlaps, obviously assuming there are none to begin with.

**N.B.** The remaining allowed values of `overlap` correspond to algorithms which, at present, can produce bad aspect ratios. In addition, we deprecate the use of the `"ortho*"` and `"portho*"`.

If the value is `"vpsc"`, overlap removal is done as a quadratic optimization to minimize node displacement while removing node overlaps.

If the value is `"orthoxy"` or `"orthoyx"`, overlaps are moved by optimizing two constraint problems, one for the x axis and one for the y. The suffix indicates which axis is processed first. If the value is "ortho", the technique is similar to "orthoxy" except a heuristic is used to reduce the bias between the two passes. If the value is `"ortho_yx"`, the technique is the same as `"ortho"`, except the roles of x and y are reversed. The values `"portho"`, `"porthoxy"`, `"porthoxy"`, and `"portho_yx"` are similar to the previous four, except only pseudo-orthogonal ordering is enforced.

If the layout is done by neato with `[mode](../dot-language/attributes/mode.md)="ipsep"`, then one can use `overlap=ipsep`. In this case, the overlap removal constraints are incorporated into the layout algorithm itself. N.B. At present, this only supports one level of clustering.

Except for `fdp` and `sfdp`, the layouts assume `overlap="true"` as the default. Fdp first uses a number of passes using a built-in, force-directed technique to try to remove overlaps. Thus, `fdp` accepts `overlap` with an integer prefix followed by a colon, specifying the number of tries. If there is no prefix, no initial tries will be performed. If there is nothing following a colon, none of the above methods will be attempted. By default, `fdp` uses `overlap="9:prism"`. Note that `overlap="true"`, `overlap="0:true"` and `overlap="0:"` all turn off all overlap removal.

By default, `sfdp` uses `overlap="prism0"`.

Except for the Voronoi and prism methods, all of these transforms preserve the orthogonal ordering of the original layout. That is, if the x coordinates of two nodes are originally the same, they will remain the same, and if the x coordinate of one node is originally less than the x coordinate of another, this relation will still hold in the transformed layout. The similar properties hold for the y coordinates. This is not quite true for the `"porth*"` cases. For these, orthogonal ordering is only preserved among nodes related by an edge.

_Valid on:_

  * Graphs



**Note:** [fdp](/docs/layouts/fdp/), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only. _

[ Search the Graphviz codebase for `"overlap"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22overlap%22)

###  overlap_scaling

Scale layout by factor, to reduce node overlap.

type: _[double](../dot-language/attribute-types/double.md), default: `-4`, minimum: `-1e+10`_

When `[overlap](../dot-language/attributes/overlap.md)=prism`, the layout is scaled by this factor, thereby removing a fair amount of node overlap, and making node overlap removal faster and better able to retain the graph's shape.

  * If `overlap_scaling` is negative, the layout is scaled by `-1*overlap_scaling` times the average label size.

  * If `overlap_scaling` is positive, the layout is scaled by `overlap_scaling`.

  * If `overlap_scaling` is zero, no scaling is done.


_Valid on:_

  * Graphs



**Note:** [prism](../dot-language/attributes/overlap.md), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), [fdp](/docs/layouts/fdp/), [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only. _

[ Search the Graphviz codebase for `"overlap_scaling"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22overlap_scaling%22)

###  overlap_shrink

Whether the overlap removal algorithm should perform a compression pass to reduce the size of the layout

type: _[bool](../dot-language/attribute-types/bool.md), default: `true`_

_Valid on:_

  * Graphs



**Note:** [prism](../dot-language/attributes/overlap.md) only. _

[ Search the Graphviz codebase for `"overlap_shrink"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22overlap_shrink%22)

###  pack

Whether each connected component of the graph should be laid out separately, and then the graphs packed together.

type: _[bool](../dot-language/attribute-types/bool.md) | [int](../dot-language/attribute-types/int.md), default: `false`_

If `pack` has an integral value, this is used as the size, in [points](/doc/info/attrs.html#points),of a margin around each part; otherwise, a default margin of `8` is used.

If pack is interpreted as `false`, the entire graph is laid out together. The granularity and method of packing is influenced by the [packmode](../dot-language/attributes/packmode.md) attribute.

For layouts which always do packing, such as `twopi`, the `pack` attribute is just used to set the margin.

`pack` is treated as true if the value of pack is `true` (case-insensitive) or a non-negative integer.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"pack"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22pack%22)

###  packmode

How connected components should be packed

type: _[packMode](../dot-language/attribute-types/pack-mode.md), default: `node`_

(cf [packMode](../dot-language/attribute-types/pack-mode.md)). Note that defining `packmode` will automatically turn on packing as though one had set `pack=true`.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"packmode"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22packmode%22)

###  pad

Inches to extend the drawing area around the minimal area needed to draw the graph

type: _[double](../dot-language/attribute-types/double.md) | [point](../dot-language/attribute-types/point.md), default: `0.0555` (4 points)_

If `pad` is a single double, both the x and y pad values are set equal to the given value. This area is part of the drawing and will be filled with the background color, if appropriate.

Normally, a small `pad` is used for aesthetic reasons, especially when a background color is used, to avoid having nodes and edges abutting the boundary of the drawn region.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"pad"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22pad%22)

###  page

Width and height of output pages, in inches

type: _[double](../dot-language/attribute-types/double.md) | [point](../dot-language/attribute-types/point.md)_

If only a single value is given, this is used for both the width and height.

If `page` is set and is smaller than the size of the layout, a rectangular array of pages of the specified page size is overlaid on the layout, with origins aligned in the lower-left corner, thereby partitioning the layout into pages. The pages are then produced one at a time, in [pagedir](../dot-language/attributes/pagedir.md) order.

At present, `page` only works for PostScript output. For other types of output, use another tool to split the output into multiple output files, or use [viewport](../dot-language/attributes/viewport.md) to generate multiple files.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"page"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22page%22)

###  pagedir

The order in which pages are emitted

type: _[pagedir](../dot-language/attribute-types/pagedir.md), default: `BL`_

Used only if [page](../dot-language/attributes/page.md) is set and applicable.

Limited to one of the 8 row or column major orders.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"pagedir"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22pagedir%22)

###  pencolor

Color used to draw the bounding box around a cluster

type: _[color](../dot-language/attribute-types/color.md), default: `black`_

If `pencolor` is not defined, [color](../dot-language/attributes/color.md) is used.

If [color](../dot-language/attributes/color.md) is not defined, [bgcolor](../dot-language/attributes/bgcolor.md) is used.

If [bgcolor](../dot-language/attributes/bgcolor.md) is not defined, the default is used.

Note that a cluster inherits the root graph's attributes if defined. Thus, if the root graph has defined a `pencolor`, this will override a [color](../dot-language/attributes/color.md) or [bgcolor](../dot-language/attributes/bgcolor.md) attribute set for the cluster.

_Valid on:_

  * Clusters



[ Search the Graphviz codebase for `"pencolor"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22pencolor%22)

###  penwidth

Specifies the width of the pen, in points, used to draw lines and curves

type: _[double](../dot-language/attribute-types/double.md), default: `1.0`, minimum: `0.0`_

including the boundaries of edges and clusters.

`penwidth` value is inherited by subclusters, and has no effect on text.

Previous to 31 January 2008, the effect of `penwidth=W` was achieved by including `setlinewidth(W)` as part of a [style](../dot-language/attributes/style.md) specification.

If both attributes are set, `penwidth` will be used.

_Valid on:_

  * Clusters
  * Nodes
  * Edges



[ Search the Graphviz codebase for `"penwidth"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22penwidth%22)

###  peripheries

Set number of peripheries used in polygonal shapes and cluster boundaries

type: _[int](../dot-language/attribute-types/int.md), default: `<shape default>` (nodes) , `1` (clusters) , minimum: `0`_

Note that [user-defined shapes](/doc/info/shapes.html#epsf) are treated as a form of box shape, so the default peripheries value is 1 and the user-defined shape will be drawn in a bounding rectangle. Setting `peripheries=0` will turn this off.

`peripheries=1` is the maximum value for clusters.

_Valid on:_

  * Nodes
  * Clusters



[ Search the Graphviz codebase for `"peripheries"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22peripheries%22)

###  pin

Keeps the node at the node's given input position

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

If true and the node has a [pos](../dot-language/attributes/pos.md) attribute on input, `neato` or `fdp` prevents the node from moving from the input position. This property can also be specified in the [pos](../dot-language/attributes/pos.md) attribute itself (cf. the [point](../dot-language/attribute-types/point.md) type).

**Note:** Due to an artifact of the implementation, previous to 27 Feb 2014, final coordinates are translated to the origin. Thus, if you look at the output coordinates given in the (x)dot or plain format, pinned nodes will not have the same output coordinates as were given on input. If this is important, a simple workaround is to maintain the coordinates of a pinned node. The vector difference between the old and new coordinates will give the translation, which can then be subtracted from all of the appropriate coordinates.

After 27 Feb 2014, this translation can be avoided in `neato` by setting `[notranslate](../dot-language/attributes/notranslate.md)=true`. However, if the graph specifies [node overlap removal](../dot-language/attributes/overlap.md) or a change in aspect [ratio](../dot-language/attributes/ratio.md), node coordinates may still change.

_Valid on:_

  * Nodes



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only. _

[ Search the Graphviz codebase for `"pin"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22pin%22)

###  pos

Position of node, or spline control points

type: _[point](../dot-language/attribute-types/point.md) | [splineType](../dot-language/attribute-types/spline-type.md)_

For nodes, the position indicates the center of the node. On output, the coordinates are in [points](/doc/info/attrs.html#points).

In `neato` and `fdp`, `pos` can be used to set the initial position of a node. By default, the coordinates are assumed to be in inches. However, the [-s](/doc/info/command.html#-s) command line flag can be used to specify different units. As the output coordinates are in points, feeding the output of a graph laid out by a Graphviz program into `neato` or `fdp` will almost always require the [-s](/doc/info/command.html#-s) flag.

When the [-n](/doc/info/command.html#-n) command line flag is used with `neato`, it is assumed the positions have been set by one of the layout programs, and are therefore in points. Thus, `neato -n` can accept input correctly without requiring a [-s](/doc/info/command.html#-s) flag and, in fact, ignores any such flag.

_Valid on:_

  * Edges
  * Nodes



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only. _

[ Search the Graphviz codebase for `"pos"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22pos%22)

###  quadtree

Quadtree scheme to use

type: _[quadType](../dot-language/attribute-types/quad-type.md) | [bool](../dot-language/attribute-types/bool.md), default: `normal`_

  * `quadtree=true` aliases `quadtree=normal`
  * `quadtree=false` aliases `quadtree=none`
  * `quadtree=2` aliases `quadtree=fast`

_Valid on:_

  * Graphs



**Note:** [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"quadtree"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22quadtree%22)

###  quantum

If `quantum > 0.0`, node label dimensions will be rounded to integral multiples of the quantum

type: _[double](../dot-language/attribute-types/double.md), default: `0.0`, minimum: `0.0`_

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"quantum"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22quantum%22)

###  radius

Radius of rounded corners on orthogonal edges

type: _[double](../dot-language/attribute-types/double.md), default: `0`, minimum: `0`_

Controls the radius of rounded corners on orthogonal edges. This attribute only has an effect when [splines=ortho](../dot-language/attributes/splines.md) is set in the graph. When set to a value greater than 0, edge corners are rendered as smooth circular arcs instead of sharp 90-degree angles. The value specifies the radius of the arc in points. A value of 0 (default) produces square corners.

Available from Graphviz version ≥ 14.1.0.

Orthogonal Edges with Rounded Corners 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph RoundedEdges {
  splines = ortho;
  nodesep = 1.0;
  ranksep = 1.0;

  // Default: square corners
  A -&gt; X [xlabel="radius=0 (default)"];

  // Small rounded corners
  B -&gt; X [radius=8, xlabel="radius=8", color=blue];

  // Medium rounded corners
  C -&gt; X [radius=12, xlabel="radius=12", color=green];

  // Large rounded corners
  D -&gt; X [radius=20, xlabel="radius=20", color=red];
}</code></pre>
</div>

See also:

  * [splines](../dot-language/attributes/splines.md)

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"radius"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22radius%22)

###  rank

Rank constraints on the nodes in a subgraph

type: _[rankType](../dot-language/attribute-types/rank-type.md)_

  * If `rank="same"`, all nodes are placed on the same rank.
  * If `rank="min"`, all nodes are placed on the minimum rank.
  * If `rank="source"`, all nodes are placed on the minimum rank, and the only nodes on the minimum rank belong to some subgraph with `rank="source"` or `rank="min"`.



Analogous criteria hold for `rank="max"` and `rank="sink"`.

(Note: the minimum rank is topmost or leftmost, and the maximum rank is bottommost or rightmost.)

For more information check [this answer in Stack Overflow](https://stackoverflow.com/a/6155783/3416774)

_Valid on:_

  * Subgraphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"rank"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22rank%22)

###  rankdir

Sets direction of graph layout

type: _[rankdir](../dot-language/attribute-types/rankdir.md), default: `TB`_

For example, if `rankdir="LR"`, and barring cycles, an edge `T -> H;` will go from left to right. By default, graphs are laid out from top to bottom.

This attribute also has a side-effect in determining how record nodes are interpreted. See [record shapes](/doc/info/shapes.html#record).

Top to bottom (default) 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    rankdir="TB"
    a -&gt; b -&gt; c;
}</code></pre>
</div>

Bottom to top 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    rankdir="BT"
    a -&gt; b -&gt; c;
}</code></pre>
</div>

Left to right 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    rankdir="LR"
    a -&gt; b -&gt; c;
}</code></pre>
</div>

Right to left 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    rankdir="RL"
    a -&gt; b -&gt; c;
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"rankdir"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22rankdir%22)

###  ranksep

Specifies separation between ranks

type: _[double](../dot-language/attribute-types/double.md) | [doubleList](../dot-language/attribute-types/double-list.md), default: `0.5` (dot) , `1.0` (twopi) , minimum: `0.02`_

In `dot`, sets the desired rank separation, in inches.

This is the minimum vertical distance between the bottom of the nodes in one rank and the tops of nodes in the next. If the value contains `equally`, the centers of all ranks are spaced equally apart. Note that both settings are possible, e.g., `ranksep="1.2 equally"`.

In `twopi`, this attribute specifies the radial separation of concentric circles. For `twopi`, `ranksep` can also be a list of doubles. The first double specifies the radius of the inner circle; the second double specifies the increase in radius from the first circle to the second; etc. If there are more circles than numbers, the last number is used as the increment for the remainder.

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/), [twopi](/docs/layouts/twopi/) only. _

[ Search the Graphviz codebase for `"ranksep"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22ranksep%22)

###  ratio

Sets the aspect ratio (drawing height/drawing width) for the drawing

type: _[double](../dot-language/attribute-types/double.md) | [string](../dot-language/attribute-types/string.md)_

Note that this is adjusted before the [size](../dot-language/attributes/size.md) attribute constraints are enforced.

In addition, the calculations usually ignore the node sizes, so the final drawing size may only approximate what is desired.

If `ratio` is numeric, `ratio` is taken as the desired aspect ratio. Then, if the actual aspect ratio is less than the desired ratio, the drawing height is scaled up to achieve the desired ratio; if the actual ratio is greater than that desired ratio, the drawing width is scaled up.

If `ratio="fill"` and the [size](../dot-language/attributes/size.md) attribute is set, node positions are scaled, separately in both x and y, so that the final drawing exactly fills the specified size. If both [size](../dot-language/attributes/size.md) values exceed the width and height of the drawing, then both coordinate values of each node are scaled up accordingly. However, if either size dimension is smaller than the corresponding dimension in the drawing, one dimension is scaled up so that the final drawing has the same aspect ratio as specified by [size](../dot-language/attributes/size.md). Then, when rendered, the layout will be scaled down uniformly in both dimensions to fit the given [size](../dot-language/attributes/size.md), which may cause nodes and text to shrink as well. This may not be what the user wants, but it avoids the hard problem of how to reposition the nodes in an acceptable fashion to reduce the drawing size.

If `ratio="compress"` and the [size](../dot-language/attributes/size.md) attribute is set, dot attempts to compress the initial layout to fit in the given size. This achieves a tighter packing of nodes but reduces the balance and symmetry. This feature only works in dot.

If `ratio="expand"`, the [size](../dot-language/attributes/size.md) attribute is set, and both the width and the height of the graph are less than the value in [size](../dot-language/attributes/size.md), node positions are scaled uniformly until at least one dimension fits [size](../dot-language/attributes/size.md) exactly. Note that this is distinct from using [size](../dot-language/attributes/size.md) as the desired size, as here the drawing is expanded before edges are generated and all node and text sizes remain unchanged.

If `ratio="auto"`, the [page](../dot-language/attributes/page.md) attribute is set and the graph cannot be drawn on a single page, then [size](../dot-language/attributes/size.md) is set to an "ideal" value.

In particular, the size in a given dimension will be the smallest integral multiple of the page size in that dimension which is at least half the current size. The two dimensions are then scaled independently to the new size. This feature only works in `dot`.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"ratio"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22ratio%22)

###  rects

Rectangles for fields of records, [in points](/doc/info/attrs.html#points)

type: _[rect](../dot-language/attribute-types/rect.md)_

_Valid on:_

  * Nodes



**Note:**  write only._

[ Search the Graphviz codebase for `"rects"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22rects%22)

###  regular

If true, force polygon to be regular.

type: _[bool](../dot-language/attribute-types/bool.md), default: `false`_

If true, the vertices of the polygon will lie on a circle whose center is the center of the node.

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    "pentagon1" [shape="pentagon"];
    "pentagon2" [shape="pentagon" regular=true]
    "hexagon1" [shape="hexagon"];
    "hexagon2" [shape="hexagon" regular=true];
}</code></pre>
</div>

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"regular"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22regular%22)

###  remincross

If there are multiple clusters, whether to run edge crossing minimization a second time.

type: _[bool](../dot-language/attribute-types/bool.md), default: `true`_

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"remincross"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22remincross%22)

###  repulsiveforce

The power of the repulsive force used in an extended Fruchterman-Reingold

type: _[double](../dot-language/attribute-types/double.md), default: `1.0`, minimum: `0.0`_

force directed model. Values larger than `1` tend to reduce the warping effect at the expense of less clustering.

_Valid on:_

  * Graphs



**Note:** [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"repulsiveforce"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22repulsiveforce%22)

###  resolution

Synonym for [dpi](../dot-language/attributes/dpi.md).

type: _[double](../dot-language/attribute-types/double.md), default: `96.0`, minimum: `0.0`_

_Valid on:_

  * Graphs



**Note:**  bitmap output,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"resolution"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22resolution%22)

###  root

Specifies nodes to be used as the center of the layout

type: _[string](../dot-language/attribute-types/string.md) | [bool](../dot-language/attribute-types/bool.md), default: `<none>` (graphs) , `false` (nodes) _

The center of the layout will be the root of the generated spanning tree.

  * As a graph attribute, this gives the name of the node.
  * As a node attribute, it specifies that the node should be used as a central node.



In `twopi`, `root` will actually be the central node. In `circo`, the block containing the node will be central in the drawing of its connected component. If not defined, `twopi` will pick a most central node, and `circo` will pick a random node.

If the root attribute is defined as the empty string, `twopi` will reset it to name of the node picked as the root node.

For `twopi`, it is possible to have multiple roots, presumably one for each component. If more than one node in a component is marked as the `root`, `twopi` will pick one.

_Valid on:_

  * Graphs
  * Nodes



**Note:** [twopi](/docs/layouts/twopi/), [circo](/docs/layouts/circo/) only. _

[ Search the Graphviz codebase for `"root"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22root%22)

###  rotate

If `rotate=90`, sets drawing orientation to landscape

type: _[int](../dot-language/attribute-types/int.md), default: `0`_

Rotations 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  rotate=90
  a -&gt; b
}</code></pre>
</div>

See also:

  * [landscape](../dot-language/attributes/landscape.md)
  * [orientation](../dot-language/attributes/orientation.md)

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"rotate"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22rotate%22)

###  rotation

Rotates the final layout counter-clockwise by the specified number of degrees

type: _[double](../dot-language/attribute-types/double.md), default: `0`_

_Valid on:_

  * Graphs



**Note:** [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"rotation"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22rotation%22)

###  samehead

Edges with the same head and the same `samehead` value are aimed at the same point on the head

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

This has no effect on loops.

Prior to Graphviz 8.0.1, each node can have at most 5 unique `samehead` values.

See [limitation](#undir_note).

See also [sametail](../dot-language/attributes/sametail.md).

_Valid on:_

  * Edges



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"samehead"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22samehead%22)

###  sametail

Edges with the same tail and the same `sametail` value are aimed at the same point on the tail.

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

This has no effect on loops.

Prior to Graphviz 8.0.1, each node can have at most 5 unique `sametail` values.

See [limitation](#undir_note).

See also [samehead](../dot-language/attributes/samehead.md).

_Valid on:_

  * Edges



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"sametail"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22sametail%22)

###  samplepoints

Gives the number of points used for a circle/ellipse node

type: _[int](../dot-language/attribute-types/int.md), default: `8` (output) , `20` (overlap and image maps) _

Used if the input graph defines the [vertices](../dot-language/attributes/vertices.md) attribute, and output is `dot` or `xdot`.

It plays the same role in `neato`, when adjusting the layout to avoid overlapping nodes, and in image maps.

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"samplepoints"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22samplepoints%22)

###  scale

Scales layout by the given factor after the initial layout

type: _[double](../dot-language/attribute-types/double.md) | [point](../dot-language/attribute-types/point.md)_

If only a single number is given, that number scales both width and height.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [twopi](/docs/layouts/twopi/) only. _

[ Search the Graphviz codebase for `"scale"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22scale%22)

###  searchsize

During network simplex, the maximum number of edges with negative cut values to search when looking for an edge with minimum cut value.

type: _[int](../dot-language/attribute-types/int.md), default: `30`_

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"searchsize"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22searchsize%22)

###  sep

Margin to leave around nodes when removing node overlap

type: _[addDouble](../dot-language/attribute-types/add-double.md) | [addPoint](../dot-language/attribute-types/add-point.md), default: `+4`_

This guarantees a minimal non-zero distance between nodes.

If the attribute begins with a plus sign `'+'`, an additive margin is specified. That is, `"+w,h"` causes the node's bounding box to be increased by `w` points on the left and right sides, and by `h` points on the top and bottom.

Without a plus sign, the node is scaled by `1 + w` in the x coordinate and `1 + h` in the y coordinate.

If only a single number is given, this is used for both dimensions.

If unset but [esep](../dot-language/attributes/esep.md) is defined, the `sep` values will be set to the [esep](../dot-language/attributes/esep.md) values divided by `0.8`. If [esep](../dot-language/attributes/esep.md) is unset, the default value is used.

Example: No separation 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
    layout="fdp"
    sep="0"
    A -- B
    B -- C
    C -- D
    D -- A
}</code></pre>
</div>

Example: separation of 3 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
    layout="fdp"
    sep="3"
    A -- B
    B -- C
    C -- D
    D -- A
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [fdp](/docs/layouts/fdp/), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), osage, [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only. _

[ Search the Graphviz codebase for `"sep"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22sep%22)

###  shape

Sets the [shape](/doc/info/shapes.html) of a node

type: _[shape](../dot-language/attribute-types/shape.md), default: `ellipse`_

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    "pentagon" [shape="pentagon"];
    "hexagon" [shape="hexagon"];
}</code></pre>
</div>

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"shape"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22shape%22)

###  shapefile

A file containing user-supplied node content

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

_(Deprecated)_.

Sets the node's `[shape](../dot-language/attributes/shape.md)="[box](/doc/info/shapes.html#polygon)"`. The image in the shapefile must be rectangular. The image formats supported as well as the precise semantics of how the file is used depends on the [output format](/docs/outputs/). For further details, see [Image Formats](/docs/outputs/#image-formats) and [External PostScript files](https://www.graphviz.org/faq/#ext_image).

There is one exception to this usage: If `[shape](../dot-language/attributes/shape.md)="epsf"`, `shapefile` gives a filename containing a definition of the node in PostScript. The graphics defined must be contain all of the node content, including any desired boundaries. For further details, see [External PostScript files](https://www.graphviz.org/faq/#ext_ps_file).

Only paths to local resources are supported. If you want to use a URL to a remote resource, see the [dot_url_resolve.py](https://gitlab.com/graphviz/graphviz/-/blob/main/contrib/dot_url_resolve.py) script.

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"shapefile"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22shapefile%22)

###  showboxes

Print guide boxes for debugging

type: _[int](../dot-language/attribute-types/int.md), default: `0`, minimum: `0`_

Print guide boxes in PostScript at the beginning of routesplines if `showboxes=1`, or at the end if `showboxes=2`. (Debugging, TB mode only!)

_Valid on:_

  * Edges
  * Nodes
  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"showboxes"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22showboxes%22)

###  sides

Number of sides when `[shape](../dot-language/attributes/shape.md)=polygon`

type: _[int](../dot-language/attribute-types/int.md), default: `4`, minimum: `0`_

Example: Polygons with 3-6 sides 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  Triangle  [shape=polygon sides=3]
  Rectangle [shape=polygon sides=4]
  Pentagon  [shape=polygon sides=5]
  Hexagon   [shape=polygon sides=6]
}</code></pre>
</div>

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"sides"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22sides%22)

###  size

Maximum width and height of drawing, in inches

type: _[double](../dot-language/attribute-types/double.md) | [point](../dot-language/attribute-types/point.md)_

If only a single number is given, this is used for both the width and the height.

If defined and the drawing is larger than the given size, the drawing is uniformly scaled down so that it fits within the given size.

If `size` ends in an exclamation point `"!"`, then `size` is taken to be the desired minimum size. In this case, if both dimensions of the drawing are less than `size`, the drawing is scaled up uniformly until at least one dimension equals its dimension in `size`.

There is some interaction between the `size` and [ratio](../dot-language/attributes/ratio.md) attributes.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"size"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22size%22)

###  skew

Skew factor for `[shape](../dot-language/attributes/shape.md)=polygon`

type: _[double](../dot-language/attribute-types/double.md), default: `0.0`, minimum: `-100.0`_

Positive values skew top of polygon to right; negative to left.

See also [distortion](../dot-language/attributes/distortion.md).

Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  SkewLeft  [shape=polygon sides=4 skew=-.5]
  SkewRight [shape=polygon sides=4 skew=.5]
}</code></pre>
</div>

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"skew"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22skew%22)

###  smoothing

Specifies a post-processing step used to smooth out an uneven distribution of nodes.

type: _[smoothType](../dot-language/attribute-types/smooth-type.md), default: `"none"`_

_Valid on:_

  * Graphs



**Note:** [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"smoothing"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22smoothing%22)

###  sortv

Sort order of graph components for ordering [packmode](../dot-language/attributes/packmode.md) packing.

type: _[int](../dot-language/attribute-types/int.md), default: `0`, minimum: `0`_

If [packmode](../dot-language/attributes/packmode.md) indicates an array packing, `sortv` specifies an insertion order among the components, with smaller values inserted first.

_Valid on:_

  * Graphs
  * Clusters
  * Nodes



[ Search the Graphviz codebase for `"sortv"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22sortv%22)

###  splines

Controls how, and if, edges are represented

type: _[bool](../dot-language/attribute-types/bool.md) | [string](../dot-language/attribute-types/string.md)_

If `splines=true`, edges are drawn as splines routed around nodes; if `splines=false`, edges are drawn as line segments. If `splines=none` or `splines=""`, no edges are drawn at all.

(1 March 2007) `splines=line` and `splines=spline` can be used as synonyms for `splines=false` and `splines=true`, respectively.

In addition, `splines=polyline` specifies that edges should be drawn as polylines.

(28 Sep 2010) `splines=ortho` specifies edges should be routed as polylines of axis-aligned segments. Currently, the routing does not handle ports or, in dot, edge labels.

(25 Sep 2012) `splines=curved` specifies edges should be drawn as curved arcs.

![](/doc/info/spline_none.png) | ![](/doc/info/spline_line.png)  
---|---  
splines=none  
splines="" | splines=line  
splines=false  
![](/doc/info/spline_polyline.png) | ![](/doc/info/spline_curved.png)  
splines=polyline | splines=curved  
![](/doc/info/spline_ortho.png) | ![](/doc/info/spline_spline.png)  
splines=ortho | splines=spline  
splines=true  
  
By default, `splines` is unset. How this is interpreted depends on the layout engine. For `dot`, the default is to draw edges as splines. For all other layouts, the default is to draw edges as line segments.

Note that for these latter layouts, if `splines="true"`, this requires non-overlapping nodes (cf. [overlap](../dot-language/attributes/overlap.md)). If `fdp` is used for layout and `splines="compound"`, then the edges are drawn to avoid clusters as well as nodes.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"splines"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22splines%22)

###  start

Parameter used to determine the initial layout of nodes

type: _[startType](../dot-language/attribute-types/start-type.md), default: `""`_

If unset, the nodes are randomly placed in a unit square with the same seed is always used for the random number generator, so the initial placement is repeatable.

The following examples have the same graph, but render differently due to their `start` values:

Set random seed to 1 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
    layout="fdp"
    start=1
    A -- B; B -- C; C -- D; D -- A
}</code></pre>
</div>

Set random seed to 2, graph looks different 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
    layout="fdp"
    start=2
    A -- B; B -- C; C -- D; D -- A
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only. _

[ Search the Graphviz codebase for `"start"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22start%22)

###  style

Set style information for components of the graph

type: _[style](../dot-language/attribute-types/style.md), default: `""`_

For cluster subgraphs, if `style="filled"`, the cluster box's background is filled.

If the default style attribute has been set for a component, an individual component can use `style=""` to revert to the normal default. For example, if the graph has

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  edge [style="invis"]
  a -&gt; b
}</code></pre>
</div>

making all edges invisible, the `b->c` edge can override this via:

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  edge [style="invis"]
  a -&gt; b
  b -&gt; c [style=""]
}</code></pre>
</div>

Of course, the component can also explicitly set its `style` attribute to the desired value.

_Valid on:_

  * Edges
  * Nodes
  * Clusters
  * Graphs



[ Search the Graphviz codebase for `"style"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22style%22)

###  stylesheet

A URL or pathname specifying an XML style sheet, used in SVG output

type: _[string](../dot-language/attribute-types/string.md), default: `""`_

Combine with [class](../dot-language/attributes/class.md) to style elements using CSS selectors.

See also:

  * [class](../dot-language/attributes/class.md)
  * [id](../dot-language/attributes/id.md)

_Valid on:_

  * Graphs



**Note:** [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"stylesheet"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22stylesheet%22)

###  tail_lp

Position of an edge's tail label, [in points](/doc/info/attrs.html#points).

type: _[point](../dot-language/attribute-types/point.md)_

The position indicates the center of the label.

_Valid on:_

  * Edges



**Note:**  write only._

[ Search the Graphviz codebase for `"tail_lp"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22tail_lp%22)

###  tailclip

If true, the tail of an edge is clipped to the boundary of the tail node

type: _[bool](../dot-language/attribute-types/bool.md), default: `true`_

otherwise, the end of the edge goes to the center of the node, or the center of a port, if applicable.

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"tailclip"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22tailclip%22)

###  tailhref

Synonym for [tailURL](../dot-language/attributes/tail-url.md).

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"tailhref"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22tailhref%22)

###  taillabel

Text label to be placed near tail of edge

type: _[lblString](../dot-language/attribute-types/lbl-string.md), default: `""`_

See [limitation](#undir_note).

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"taillabel"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22taillabel%22)

###  tailport

Indicates where on the tail node to attach the tail of the edge

type: _[portPos](../dot-language/attribute-types/port-pos.md), default: `center`_

See [limitation](#undir_note).

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"tailport"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22tailport%22)

###  tailtarget

Browser window to use for the [tailURL](../dot-language/attributes/tail-url.md) link

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `<none>`_

If the edge has a [tailURL](../dot-language/attributes/tail-url.md), `tailtarget` determines which window of the browser is used for the URL.

Setting `tailtarget=_graphviz` will open a new window if it doesn't already exist, or reuse it if it does.

If undefined, the value of the [target](../dot-language/attributes/target.md) is used.

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"tailtarget"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22tailtarget%22)

###  tailtooltip

Tooltip annotation attached to the tail of an edge

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

Used only if the edge has a [tailURL](../dot-language/attributes/tail-url.md) attribute.

  * [edgetooltip](../dot-language/attributes/edgetooltip.md).
  * [headtooltip](../dot-language/attributes/headtooltip.md).
  * [labeltooltip](../dot-language/attributes/labeltooltip.md).
  * [tooltip](../dot-language/attributes/tooltip.md).

_Valid on:_

  * Edges



**Note:** [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"tailtooltip"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22tailtooltip%22)

###  tailURL

If defined, `tailURL` is output as part of the tail label of the edge

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

Also, this value is used near the tail node, overriding any [URL](../dot-language/attributes/url.md) value.

See [limitation](#undir_note).

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"tailURL"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22tailURL%22)

###  target

If the object has a [URL](../dot-language/attributes/url.md), this attribute determines which window of the browser is used for the URL.

type: _[escString](../dot-language/attribute-types/esc-string.md) | [string](../dot-language/attribute-types/string.md), default: `<none>`_

See [W3C documentation](http://www.w3.org/TR/html401/present/frames.html#adef-target).

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters



**Note:**  map,[svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"target"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22target%22)

###  TBbalance

Which [rank](../dot-language/attributes/rank.md) to move floating (loose) nodes to

type: _[string](../dot-language/attribute-types/string.md), default: `''`_

Valid options:

  * `"min"`: Move floating (loose) nodes to minimum [rank](../dot-language/attributes/rank.md).
  * `"max"`: Move floating (loose) nodes to maximum [rank](../dot-language/attributes/rank.md).
  * Otherwise, floating nodes are placed anywhere.



Despite the name `TBbalance` ("Top-Bottom Balance"), this also works with left-right ranks, e.g. [rankdir=LR](../dot-language/attributes/rankdir.md).

Examples:

Default Behaviour 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    layout="dot"

    { rank="min"; "min" }
    { rank="max"; "max" }
    "min" -&gt; "middle" -&gt; "max"
    
    "Floater 1"
    "Floater 2"
}</code></pre>
</div>

Floating nodes moved to min rank 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    layout="dot"
    TBbalance="min"

    { rank="min"; "min" }
    { rank="max"; "max" }
    "min" -&gt; "middle" -&gt; "max"
    
    "Floater 1"
    "Floater 2"
}</code></pre>
</div>

Floating nodes moved to max rank 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    layout="dot"
    TBbalance="max"

    { rank="min"; "min" }
    { rank="max"; "max" }
    "min" -&gt; "middle" -&gt; "max"
    
    "Floater 1"
    "Floater 2"
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only. _

[ Search the Graphviz codebase for `"TBbalance"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22TBbalance%22)

###  tooltip

Tooltip (mouse hover text) attached to the node, edge, cluster, or graph

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `""`_

If `tooltip` is unset, Graphviz will use the object's [label](../dot-language/attributes/label.md) if defined.

Note that if the `label` is a record specification or an HTML-like label, the resulting tooltip may be unhelpful. In this case, if tooltips will be generated, the user should set a `tooltip` attribute explicitly.

Tooltips 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  label="Graph Label"
  tooltip="Graph Tooltip"
  subgraph cluster_a {
    label="Cluster Label"
    tooltip="Cluster Tooltip"
    Node1 [tooltip="Node1 Tooltip"]
    Node1 -&gt; Node2 [label="Edge" tooltip="Edge Tooltip"]
  }
}</code></pre>
</div>

See also:

  * [edgetooltip](../dot-language/attributes/edgetooltip.md).
  * [headtooltip](../dot-language/attributes/headtooltip.md).
  * [labeltooltip](../dot-language/attributes/labeltooltip.md).
  * [tailtooltip](../dot-language/attributes/tailtooltip.md).

_Valid on:_

  * Nodes
  * Edges
  * Clusters
  * Graphs



**Note:** [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"tooltip"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22tooltip%22)

###  truecolor

Whether internal bitmap rendering relies on a truecolor color model or uses

type: _[bool](../dot-language/attribute-types/bool.md)_

color palette.

If `truecolor` is unset, `truecolor` is not used unless there is a [shapefile](../dot-language/attributes/shapefile.md) property for some node in the graph. The output model will use the input model when possible.

Use of color palettes results in less memory usage during creation of the bitmaps and smaller output files.

Usually, the only time it is necessary to specify the `truecolor` model is if the graph uses more than 256 colors. However, if one uses `[bgcolor](../dot-language/attributes/bgcolor.md)=transparent` with a color palette, font antialiasing can show up as a fuzzy white area around characters. Using `truecolor=true` avoids this problem.

_Valid on:_

  * Graphs



**Note:**  bitmap output only._

[ Search the Graphviz codebase for `"truecolor"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22truecolor%22)

###  URL

Hyperlinks incorporated into device-dependent output

type: _[escString](../dot-language/attribute-types/esc-string.md), default: `<none>`_

At present, used in `ps2`, `cmap`, `i*map` and `svg` formats. For all these formats, URLs can be attached to nodes, edges and clusters. URL attributes can also be attached to the root graph in `ps2`, `cmap` and `i*map` formats. This serves as the base URL for relative URLs in the former, and as the default image map file in the latter.

For `svg`, `cmapx` and `imap` output, the active area for a node is its visible image. For example, an unfilled node with no drawn boundary will only be active on its label. For other output, the active area is its bounding box. The active area for a cluster is its bounding box. For edges, the active areas are small circles where the edge contacts its head and tail nodes. In addition, for `svg`, `cmapx` and `imap`, the active area includes a thin polygon approximating the edge. The circles may overlap the related node, and the edge URL dominates. If the edge has a label, this will also be active. Finally, if the edge has a head or tail label, this will also be active.

For edges, the attributes [headURL](../dot-language/attributes/head-url.md), [tailURL](../dot-language/attributes/tail-url.md), [labelURL](../dot-language/attributes/label-url.md) and [edgeURL](../dot-language/attributes/edge-url.md) allow control of various parts of an edge.

if active areas of two edges overlap, it is unspecified which area dominates.

See also:

  * [edgehref](../dot-language/attributes/edgehref.md), [edgeURL](../dot-language/attributes/edge-url.md)
  * [headhref](../dot-language/attributes/headhref.md), [headURL](../dot-language/attributes/head-url.md)
  * [labelhref](../dot-language/attributes/labelhref.md), [labelURL](../dot-language/attributes/label-url.md)
  * [tailhref](../dot-language/attributes/tailhref.md), [tailURL](../dot-language/attributes/tail-url.md)
  * [href](../dot-language/attributes/href.md), [URL](../dot-language/attributes/url.md)



Example: Van Gogh Paintings with Links 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  label="Vincent van Gogh Paintings"
  URL="https://en.wikipedia.org/wiki/Vincent_van_Gogh"

  subgraph cluster_self_portraits {
    URL="https://en.wikipedia.org/wiki/Portraits_of_Vincent_van_Gogh"
    label="Self-portraits"

    "Self-Portrait with Grey Felt Hat" [URL="https://www.vangoghmuseum.nl/en/collection/s0016V1962"]
    "Self-Portrait as a Painter" [URL="https://www.vangoghmuseum.nl/en/collection/s0022V1962"]
  }
  
  subgraph cluster_flowers {
    URL="https://en.wikipedia.org/wiki/Sunflowers_(Van_Gogh_series)"
    label="Flowers"

    "Sunflowers" [URL="https://www.nationalgallery.org.uk/paintings/vincent-van-gogh-sunflowers"]
    "Almond Blossom" [URL="https://www.vangoghmuseum.nl/en/collection/s0176V1962"]
  }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters



**Note:**  map,[postscript](/docs/outputs/ps/), [svg](/docs/outputs/svg/) only. _

[ Search the Graphviz codebase for `"URL"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22URL%22)

###  vertices

Sets the coordinates of the vertices of the node's polygon, in inches

type: _[pointList](../dot-language/attribute-types/point-list.md)_

Used if the node is polygonal, and output is `dot` or `xdot`.

If the node is an ellipse or circle, the [samplepoints](../dot-language/attributes/samplepoints.md) attribute affects the output.

_Valid on:_

  * Nodes



**Note:**  write only._

[ Search the Graphviz codebase for `"vertices"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22vertices%22)

###  viewport

Clipping window on final drawing

type: _[viewPort](../dot-language/attribute-types/view-port.md), default: `""`_

`viewport` supersedes any [size](../dot-language/attributes/size.md) attribute. The width and height of the viewport specify precisely the final size of the output.

_Valid on:_

  * Graphs



[ Search the Graphviz codebase for `"viewport"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22viewport%22)

###  voro_margin

Tuning margin of Voronoi technique

type: _[double](../dot-language/attribute-types/double.md), default: `0.05`, minimum: `0.0`_

Factor to scale up drawing to allow margin for expansion in [Voronoi technique](https://en.wikipedia.org/wiki/Voronoi_diagram). `dim' = (1+2*margin)*dim`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/), [twopi](/docs/layouts/twopi/), [circo](/docs/layouts/circo/) only. _

[ Search the Graphviz codebase for `"voro_margin"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22voro_margin%22)

###  weight

Weight of edge

type: _[int](../dot-language/attribute-types/int.md) | [double](../dot-language/attribute-types/double.md), default: `1`, minimum: `0(dot,twopi)`, `1(neato,fdp)`_

In `dot`, the heavier the weight, the shorter, straighter and more vertical the edge is.

For `twopi`, `weight=0` indicates the edge should not be used in constructing a spanning tree from the root.

For other layouts, a larger weight encourages the layout to make the edge length closer to that specified by the [len](../dot-language/attributes/len.md) attribute.

Weights in `dot` must be integers.

Edge Weights 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  root -&gt; a
  root -&gt; b [weight=2]
  root -&gt; c [weight=3]
}</code></pre>
</div>

_Valid on:_

  * Edges



[ Search the Graphviz codebase for `"weight"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22weight%22)

###  width

Width of node, in inches

type: _[double](../dot-language/attribute-types/double.md), default: `0.75`, minimum: `0.01`_

This is taken as the initial, minimum width of the node. If [fixedsize](../dot-language/attributes/fixedsize.md) is true, this will be the final width of the node. Otherwise, if the node label requires more width to fit, the node's width will be increased to contain the label.

If the output format is `dot`, the value given to `width` will be the final value.

If the node shape is regular, the width and height are made identical:

  * If either the width or the height is set explicitly, that value is used.
  * If both the width or the height are set explicitly, the maximum of the two values is used.
  * If neither is set explicitly, the minimum of the two default values is used.



If a value below the minimum value (0.01) is set, it will be rounded up to this minimum.

Width Example 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  "d" # default
  "1in" [width=1]
  "2in" [width=2]
}</code></pre>
</div>

_Valid on:_

  * Nodes



[ Search the Graphviz codebase for `"width"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22width%22)

###  xdotversion

Determines the version of `xdot` used in output

type: _[string](../dot-language/attribute-types/string.md)_

Only used for `xdot` output.

If unset, graphviz will set this attribute to the `xdot` version used for output.

_Valid on:_

  * Graphs



**Note:** [xdot](/docs/outputs/canon/) only. _

[ Search the Graphviz codebase for `"xdotversion"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22xdotversion%22)

###  xlabel

External label for a node or edge

type: _[lblString](../dot-language/attribute-types/lbl-string.md), default: `""`_

  * For nodes, the label will be placed outside of the node but near it.
  * For edges, the label will be placed near the center of the edge. This can be useful in dot to avoid the occasional problem when the use of edge labels distorts the layout.
  * For other layouts, the xlabel attribute can be viewed as a synonym for the [label](../dot-language/attributes/label.md) attribute.



These labels are added after all nodes and edges have been placed.

The labels will be placed so that they do not overlap any node or label. This means it may not be possible to place all of them. To force placing all of them, set `[forcelabels](../dot-language/attributes/forcelabels.md)=true`.

External Labels on Nodes and Edges 

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  "⚡" [xlabel="Sparks"]
  "🔥" [xlabel="Fires"]
  "⚡"-&gt;"🔥" [xlabel="Sometimes" label="Cause"]
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes



[ Search the Graphviz codebase for `"xlabel"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22xlabel%22)

###  xlp

Position of an exterior label, [in points](/doc/info/attrs.html#points)

type: _[point](../dot-language/attribute-types/point.md)_

The position indicates the center of the label.

_Valid on:_

  * Nodes
  * Edges



**Note:**  write only._

[ Search the Graphviz codebase for `"xlp"` __](https://gitlab.com/search?group_id=1996273&project_id=4207231&repository_ref=main&scope=blobs&search=%22xlp%22)

###  z

Z-coordinate value for 3D layouts and displays

type: _[double](../dot-language/attribute-types/double.md), default: `0.0`_

**Deprecated:** Use [pos](../dot-language/attributes/pos.md) attribute, along with [dimen](../dot-language/attributes/dimen.md) and/or [dim](../dot-language/attributes/dim.md) to specify dimensions.

If the graph has [dim](../dot-language/attributes/dim.md) set to 3 (or more), neato will use a node's `z` value for the z coordinate of its initial position if its [pos](../dot-language/attributes/pos.md) attribute is also defined.

Even if no `z` values are specified in the input, it is necessary to declare a `z` attribute for nodes, e.g, using `node[z=""]` in order to get z values on output. Thus, setting `[dim](../dot-language/attributes/dim.md)=3` but not declaring `z` will cause `neato -Tvrml` to layout the graph in 3D but project the layout onto the xy-plane for the rendering. If the `z` attribute is declared, the final rendering will be in 3D.

_Valid on:_

  * Nodes
