# style

`styleItem ( ',' styleItem )*`

where styleItem | = | name or name'('args')'
---|---|---
and args | = | name ( ',' name )*

and name can be any string of characters not containing a space, a left or right parenthesis, or a comma. Whitespace characters are ignored.

**NOTE:** _The styles`tapered, striped` and `wedged` are only available in release 2.30 and later._

The recognized style names are,

For nodes and edges:

  * `"dashed"`
  * `"dotted"`
  * `"solid"`
  * `"invis"`
  * `"bold"`



For edges only:

  * `"tapered"`



For nodes only:

  * `"filled"`
  * `"striped"`
  * `"wedged"`
  * `"diagonals"`
  * `"rounded"`



For clusters:

  * `"filled"`
  * `"striped"`
  * `"rounded"`



The style `"radial"` is recognized for nodes, clusters and graphs, and indicates a radial-style gradient fill if applicable.

The style `"striped"` causes the fill to be done as a set of vertical stripes. The colors are specified via a [colorList](/docs/attr-types/colorList/), the colors drawn from left to right in list order. Optional color weights can be specified to indicate the proportional widths of the bars. If the sum of the weights is less than 1, the remainder is divided evenly among the colors with no weight. **Note** : The style `"striped"` is only supported with clusters and rectangularly-shaped nodes.

The style `"wedged"` causes the fill to be done as a set of wedges. The colors are specified via a [colorList](/docs/attr-types/colorList/), with the colors drawn counter-clockwise starting at angle 0. Optional color weights are interpreted analogously to the striped case described above. **Note** : The style `"wedged"` is allowed only for elliptically-shaped nodes.

The following tables illustrate some of the effects of the style settings. Examples of tapered line styles are given below. Examples of linear and radial gradient fill can be seen under [colorList](/docs/attr-types/colorList/).

Basic style settings for nodes `solid` | ![](/doc/info/n_solid.png) | `dashed` | ![](/doc/info/n_dashed.png) | `dotted` | ![](/doc/info/n_dotted.png)
---|---|---|---|---|---
`bold` | ![](/doc/info/n_bold.png) | `rounded` | ![](/doc/info/n_rounded.png) | `diagonals` | ![](/doc/info/n_diagonals.png)
`filled` | ![](/doc/info/n_filled.png) | `striped` | ![](/doc/info/n_striped.png) | `wedged` | ![](/doc/info/n_wedged.png)
Basic style settings for edges `solid` | ![](/doc/info/e_solid.png) | `dashed` | ![](/doc/info/e_dashed.png)
---|---|---|---
`dotted` | ![](/doc/info/e_dotted.png) | `bold` | ![](/doc/info/e_bold.png)
Basic style settings for clusters `solid` | ![](/doc/info/c_solid.png) | `dashed` | ![](/doc/info/c_dashed.png) | `dotted` | ![](/doc/info/c_dotted.png) | `bold` | ![](/doc/info/c_bold.png)
---|---|---|---|---|---|---|---
`rounded` | ![](/doc/info/c_rounded.png) | `filled` | ![](/doc/info/c_filled.png) | `striped` | ![](/doc/info/c_striped.png)

The effect of `style=tapered` depends on the [penwidth](../attributes/penwidth.md), [dir](../attributes/dir.md), [arrowhead](../attributes/arrowhead.md) and [arrowtail](../attributes/arrowtail.md) attributes. The edge starts with width `penwidth` and tapers to width 1, in points. The `dir` attribute determines whether the tapering goes from tail to head (`dir=forward`), from head to tail (`dir=forward`), from the middle to both the head and tail (`dir=both`), or no tapering at all (`dir=none`). If the `dir` is not explicitly set, the default for the graph type is used (see [dir](../attributes/dir.md)). Arrowheads and arrowtails are also drawn, based on the value of `dir`; to avoid this, set `arrowhead` and/or `arrowtail` to `"none"`.

**Note:** At present, the tapered style only allows a simple filled polygon. Additional styles such as `dotted` or `dashed`, or multiple colors supplied via a [colorList](/docs/attr-types/colorList/) are ignored.

The following table illustrates the `style=tapered` with `penwidth=7` and `arrowtail=none`.

`dir` \ `arrowhead` | `normal` | `none`
---|---|---
`forward` | ![](/doc/info/normal_forward.png) | ![](/doc/info/none_forward.png)
`back` | ![](/doc/info/normal_back.png) | ![](/doc/info/none_back.png)
`both` | ![](/doc/info/normal_both.png) | ![](/doc/info/none_both.png)
`none` | ![](/doc/info/normal_none.png) | ![](/doc/info/none_none.png)

Additional styles are available in device-dependent form. Style lists are passed to device drivers, which can use this to generate appropriate output.

The style attribute affects the basic appearance of nodes, edges and graphs, but has no effect on any text used in labels. For this, use the [fontname](../attributes/fontname.md), [fontsize](../attributes/fontsize.md) and [fontcolor](../attributes/fontcolor.md) attributes, or the `<FONT>`, `<B>`, `<I>`, etc. elements in [HTML-like labels](/doc/info/shapes.html#html).

The `setlinewidth` style value can be used for more control over the width of node borders and edges than is allowed by `bold`. This style value takes an argument, specifying the width of the line in [points](/doc/info/attrs.html#points). For example, `style="bold"` is equivalent to `style="setlinewidth(2)"`. **The use of`setlinewidth` is deprecated; one should use the [penwidth](../attributes/penwidth.md) attribute instead.**

## Attributes

`style` is a valid type for:

  * [style](../attributes/style.md)
