# Graph Attributes

Attributes you can set on graphs

- [_background](attributes/background.md) - A string in the [xdot` format](attribute-types/xdot.md) specifying an arbitrary background.
- [bb](attributes/bb.md) - Bounding box of drawing in points.
  For write only.
- [beautify](attributes/beautify.md) - Whether to draw leaf nodes uniformly in a circle around the root node in sfdp.
  For [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [bgcolor](attributes/bgcolor.md) - Canvas background color.
- [center](attributes/center.md) - Whether to center the drawing in the output canvas.
- [charset](attributes/charset.md) - Character encoding used when interpreting string input as a text label.
- [class](attributes/class.md) - Classnames to attach to the node, edge, graph, or cluster's SVG element.
  For [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [clusterrank](attributes/clusterrank.md) - Mode used for handling clusters.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [colorscheme](attributes/colorscheme.md) - A color scheme namespace: the context for interpreting color names.
- [comment](attributes/comment.md) - Comments are inserted into output.
- [compound](attributes/compound.md) - If true, allow edges between clusters.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [concentrate](attributes/concentrate.md) - If true, use edge concentrators.
- [Damping](attributes/damping.md) - Factor damping force motions.
  For [neato](https://www.graphviz.org/docs/layouts/neato/) only.
- [defaultdist](attributes/defaultdist.md) - The distance between nodes in separate connected components.
  For [neato](https://www.graphviz.org/docs/layouts/neato/) only.
- [dim](attributes/dim.md) - Set the number of dimensions used for the layout.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [fdp](https://www.graphviz.org/docs/layouts/fdp/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [dimen](attributes/dimen.md) - Set the number of dimensions used for rendering.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [fdp](https://www.graphviz.org/docs/layouts/fdp/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [diredgeconstraints](attributes/diredgeconstraints.md) - Whether to constrain most edges to point downwards.
  For [neato](https://www.graphviz.org/docs/layouts/neato/) only.
- [dpi](attributes/dpi.md) - Specifies the expected number of pixels per inch on a display device.
  For bitmap output, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [epsilon](attributes/epsilon.md) - Terminating condition.
  For [neato](https://www.graphviz.org/docs/layouts/neato/) only.
- [esep](attributes/esep.md) - Margin used around polygons for purposes of spline edge routing.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [fdp](https://www.graphviz.org/docs/layouts/fdp/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/), osage, [circo](https://www.graphviz.org/docs/layouts/circo/), [twopi](https://www.graphviz.org/docs/layouts/twopi/) only.
- [fontcolor](attributes/fontcolor.md) - Color used for text.
- [fontname](attributes/fontname.md) - Font used for text.
- [fontnames](attributes/fontnames.md) - Allows user control of how basic fontnames are represented in SVG output.
  For [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [fontpath](attributes/fontpath.md) - Directory list used by [libgd](https://libgd.github.io.md) to search for bitmap fonts.
- [fontsize](attributes/fontsize.md) - Font size, [in points](https://www.graphviz.org/doc/info/attrs.html#points), used for text.
- [forcelabels](attributes/forcelabels.md) - Whether to force placement of all [xlabels](attributes/xlabel.md), even if overlapping.
- [gradientangle](attributes/gradientangle.md) - If a gradient fill is being used, this determines the angle of the fill.
- [href](attributes/href.md) - Synonym for [URL](attributes/url.md).
  For map, [postscript](https://www.graphviz.org/docs/outputs/ps.md), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [id](attributes/id.md) - Identifier for graph objects.
  For map, [postscript](https://www.graphviz.org/docs/outputs/ps.md), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [imagepath](attributes/imagepath.md) - A list of directories in which to look for image files.
- [inputscale](attributes/inputscale.md) - Scales the input [positions](attributes/pos.md) to convert between length units.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [fdp](https://www.graphviz.org/docs/layouts/fdp/) only.
- [K](attributes/k.md) - Spring constant used in virtual physical model.
  For [fdp](https://www.graphviz.org/docs/layouts/fdp/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [label](attributes/label.md) - Text label attached to objects.
- [label_scheme](attributes/label_scheme.md) - Whether to treat a node whose name has the form `|edgelabel|*` as a special node representing an edge label.
  For [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [labeljust](attributes/labeljust.md) - Justification for graph & cluster labels.
- [labelloc](attributes/labelloc.md) - Vertical placement of labels for nodes, root graphs and clusters.
- [landscape](attributes/landscape.md) - If true, the graph is rendered in landscape mode.
- [layerlistsep](attributes/layerlistsep.md) - The separator characters used to split attributes of type [layerRange](attribute-types/layer-range.md) into a list of ranges.
- [layers](attributes/layers.md) - A linearly ordered list of layer names attached to the graph.
- [layerselect](attributes/layerselect.md) - Selects a list of layers to be emitted.
- [layersep](attributes/layersep.md) - The separator characters for splitting the [layers](attributes/layers.md) attribute into a list of layer names.
- [layout](attributes/layout.md) - Which [layout engine](https://www.graphviz.org/docs/layouts/) to use.
- [levels](attributes/levels.md) - Number of levels allowed in the multilevel scheme.
  For [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [levelsgap](attributes/levelsgap.md) - strictness of neato level constraints.
  For [neato](https://www.graphviz.org/docs/layouts/neato/) only.
- [lheight](attributes/lheight.md) - Height of graph or cluster label, in inches.
  For write only.
- [linelength](attributes/linelength.md) - How long strings should get before overflowing to next line, for text output.
- [lp](attributes/lp.md) - Label center position.
  For write only.
- [lwidth](attributes/lwidth.md) - Width of graph or cluster label, in inches.
  For write only.
- [margin](attributes/margin.md) - For graphs, this sets x and y margins of canvas, in inches.
- [maxiter](attributes/maxiter.md) - Sets the number of iterations used.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [fdp](https://www.graphviz.org/docs/layouts/fdp/) only.
- [mclimit](attributes/mclimit.md) - Scale factor for mincross (mc) edge crossing minimizer parameters.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [mindist](attributes/mindist.md) - Specifies the minimum separation between all nodes.
  For [circo](https://www.graphviz.org/docs/layouts/circo/) only.
- [mode](attributes/mode.md) - Technique for optimizing the layout.
  For [neato](https://www.graphviz.org/docs/layouts/neato/) only.
- [model](attributes/model.md) - Specifies how the distance matrix is computed for the input graph.
  For [neato](https://www.graphviz.org/docs/layouts/neato/) only.
- [newrank](attributes/newrank.md) - Whether to use a single global ranking, ignoring clusters.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [nodesep](attributes/nodesep.md) - In `dot`, `nodesep` specifies the minimum space between two adjacent nodes in the same rank, in inches.
- [nojustify](attributes/nojustify.md) - Whether to justify multiline text vs the previous text line (rather than the side of the container).
- [normalize](attributes/normalize.md) - normalizes coordinates of final layout.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [fdp](https://www.graphviz.org/docs/layouts/fdp/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/), [twopi](https://www.graphviz.org/docs/layouts/twopi/), [circo](https://www.graphviz.org/docs/layouts/circo/) only.
- [notranslate](attributes/notranslate.md) - Whether to avoid translating layout to the origin point.
  For [neato](https://www.graphviz.org/docs/layouts/neato/) only.
- [nslimit](attributes/nslimit.md) - Sets number of iterations in network simplex applications.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [nslimit1](attributes/nslimit1.md) - Sets number of iterations in network simplex applications.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [oneblock](attributes/oneblock.md) - Whether to draw circo graphs around one circle.
  For [circo](https://www.graphviz.org/docs/layouts/circo/) only.
- [ordering](attributes/ordering.md) - Constrains the left-to-right ordering of node edges.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [orientation](attributes/orientation.md) - node shape rotation angle, or graph orientation.
- [outputorder](attributes/outputorder.md) - Specify order in which nodes and edges are drawn.
- [overlap](attributes/overlap.md) - Determines if and how node overlaps should be removed.
  For [fdp](https://www.graphviz.org/docs/layouts/fdp/), [neato](https://www.graphviz.org/docs/layouts/neato/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/), [circo](https://www.graphviz.org/docs/layouts/circo/), [twopi](https://www.graphviz.org/docs/layouts/twopi/) only.
- [overlap_scaling](attributes/overlap_scaling.md) - Scale layout by factor, to reduce node overlap.
  For [prism](attributes/overlap.md), [neato](https://www.graphviz.org/docs/layouts/neato/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/), [fdp](https://www.graphviz.org/docs/layouts/fdp/), [circo](https://www.graphviz.org/docs/layouts/circo/), [twopi](https://www.graphviz.org/docs/layouts/twopi/) only.
- [overlap_shrink](attributes/overlap_shrink.md) - Whether the overlap removal algorithm should perform a compression pass to reduce the size of the layout.
  For [prism](attributes/overlap.md) only.
- [pack](attributes/pack.md) - Whether each connected component of the graph should be laid out separately, and then the graphs packed together.
- [packmode](attributes/packmode.md) - How connected components should be packed.
- [pad](attributes/pad.md) - Inches to extend the drawing area around the minimal area needed to draw the graph.
- [page](attributes/page.md) - Width and height of output pages, in inches.
- [pagedir](attributes/pagedir.md) - The order in which pages are emitted.
- [quadtree](attributes/quadtree.md) - Quadtree scheme to use.
  For [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [quantum](attributes/quantum.md) - If `quantum > 0.0`, node label dimensions will be rounded to integral multiples of the quantum.
- [rankdir](attributes/rankdir.md) - Sets direction of graph layout.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [ranksep](attributes/ranksep.md) - Specifies separation between ranks.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md), [twopi](https://www.graphviz.org/docs/layouts/twopi/) only.
- [ratio](attributes/ratio.md) - Sets the aspect ratio (drawing height/drawing width) for the drawing.
- [remincross](attributes/remincross.md) - If there are multiple clusters, whether to run edge crossing minimization a second time.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [repulsiveforce](attributes/repulsiveforce.md) - The power of the repulsive force used in an extended Fruchterman-Reingold.
  For [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [resolution](attributes/resolution.md) - Synonym for [dpi](attributes/dpi.md).
  For bitmap output, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [root](attributes/root.md) - Specifies nodes to be used as the center of the layout.
  For [twopi](https://www.graphviz.org/docs/layouts/twopi/), [circo](https://www.graphviz.org/docs/layouts/circo/) only.
- [rotate](attributes/rotate.md) - If `rotate=90`, sets drawing orientation to landscape.
- [rotation](attributes/rotation.md) - Rotates the final layout counter-clockwise by the specified number of degrees.
  For [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [scale](attributes/scale.md) - Scales layout by the given factor after the initial layout.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [twopi](https://www.graphviz.org/docs/layouts/twopi/) only.
- [searchsize](attributes/searchsize.md) - During network simplex, the maximum number of edges with negative cut values to search when looking for an edge with minimum cut value.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [sep](attributes/sep.md) - Margin to leave around nodes when removing node overlap.
  For [fdp](https://www.graphviz.org/docs/layouts/fdp/), [neato](https://www.graphviz.org/docs/layouts/neato/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/), osage, [circo](https://www.graphviz.org/docs/layouts/circo/), [twopi](https://www.graphviz.org/docs/layouts/twopi/) only.
- [showboxes](attributes/showboxes.md) - Print guide boxes for debugging.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [size](attributes/size.md) - Maximum width and height of drawing, in inches.
- [smoothing](attributes/smoothing.md) - Specifies a post-processing step used to smooth out an uneven distribution of nodes.
  For [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [sortv](attributes/sortv.md) - Sort order of graph components for ordering [packmode](attributes/packmode.md) packing.
- [splines](attributes/splines.md) - Controls how, and if, edges are represented.
- [start](attributes/start.md) - Parameter used to determine the initial layout of nodes.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [fdp](https://www.graphviz.org/docs/layouts/fdp/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/) only.
- [style](attributes/style.md) - Set style information for components of the graph.
- [stylesheet](attributes/stylesheet.md) - A URL or pathname specifying an XML style sheet, used in SVG output.
  For [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [target](attributes/target.md) - If the object has a [URL](attributes/url.md), this attribute determines which window of the browser is used for the URL.
  For map, [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [TBbalance](attributes/t-bbalance.md) - Which [rank](attributes/rank.md) to move floating (loose) nodes to.
  For [dot](https://www.graphviz.org/docs/layouts/dot.md) only.
- [tooltip](attributes/tooltip.md) - Tooltip (mouse hover text) attached to the node, edge, cluster, or graph.
  For [cmap](https://www.graphviz.org/docs/outputs/cmap.md), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [truecolor](attributes/truecolor.md) - Whether internal bitmap rendering relies on a truecolor color model or uses.
  For bitmap output only.
- [URL](attributes/url.md) - Hyperlinks incorporated into device-dependent output.
  For map, [postscript](https://www.graphviz.org/docs/outputs/ps.md), [svg](https://www.graphviz.org/docs/outputs/svg/) only.
- [viewport](attributes/viewport.md) - Clipping window on final drawing.
- [voro_margin](attributes/voro_margin.md) - Tuning margin of Voronoi technique.
  For [neato](https://www.graphviz.org/docs/layouts/neato/), [fdp](https://www.graphviz.org/docs/layouts/fdp/), [sfdp](https://www.graphviz.org/docs/layouts/sfdp/), [twopi](https://www.graphviz.org/docs/layouts/twopi/), [circo](https://www.graphviz.org/docs/layouts/circo/) only.
- [xdotversion](attributes/xdotversion.md) - Determines the version of `xdot` used in output.
  For [xdot](https://www.graphviz.org/docs/outputs/canon/) only.
