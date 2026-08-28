# arrowType

Edge arrowhead shape

`normal` | ![](../../info/a_normal.gif) | `inv` | ![](../../info/a_inv.gif)
---|---|---|---
`dot` | ![](../../info/a_dot.gif) | `invdot` | ![](../../info/a_invdot.gif)
`odot` | ![](../../info/a_odot.gif) | `invodot` | ![](../../info/a_invodot.gif)
`none` | ![](../../info/a_none.gif) | `tee` | ![](../../info/a_tee.gif)
`empty` | ![](../../info/a_empty.gif) | `invempty` | ![](../../info/a_invempty.gif)
`diamond` | ![](../../info/a_diamond.gif) | `odiamond` | ![](../../info/a_odiamond.gif)
`ediamond` | ![](../../info/a_ediamond.gif) | `crow` | ![](../../info/a_crow.gif)
`box` | ![](../../info/a_box.gif) | `obox` | ![](../../info/a_obox.gif)
`open` | ![](../../info/a_open.gif) | `halfopen` | ![](../../info/a_halfopen.gif)
`vee` | ![](../../info/a_open.gif)

The examples above show a set of commonly used arrow shapes. There is a grammar of [arrow shapes](../arrow-shapes.md) which can be used to describe a collection of 3,111,696 arrow combinations of the 42 variations of the primitive set of 11 arrows.

The basic arrows shown above contain:

  * most of the primitive shapes (`box`, `crow`, `diamond`, `dot`, `inv`, `none`, `normal`, `tee`, `vee`)
  * shapes that can be derived from the grammar (`odot`, `invdot`, `invodot`, `obox`, `odiamond`)
  * shapes supported as special cases for backward-compatibility (`ediamond`, `open`, `halfopen`, `empty`, `invempty`).



## Attributes

`arrowType` is a valid type for:

  * [arrowhead](../attributes/arrowhead.md)
  * [arrowtail](../attributes/arrowtail.md)
