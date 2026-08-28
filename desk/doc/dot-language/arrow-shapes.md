# Arrow Shapes

Arrow shapes can be specified and named using the following simple grammar. Example: `A -> B [arrowhead="curve"]` Terminals are shown in bold font and nonterminals in italics. Literal characters are given in single quotes. Square brackets `[ and `]` enclose optional items. Vertical bars `|` separate alternatives.

## Grammar

_arrowname_ | : | _aname_ [ _aname_ [ _aname_ [ _aname_ ] ] ]  
---|---|---  
_aname_ | : | [ _modifiers_ ] _shape_  
_modifiers_ | : | [ **'o'** ] [ _side_ ]  
_side_ | : | **'l'**  
| | \| | **'r'**  
_shape_ | : | **box**  
| | \| | **crow**  
| | \| | **curve**  
| | \| | **icurve**  
| | \| | **diamond**  
| | \| | **dot**  
| | \| | **inv**  
| | \| | **none**  
| | \| | **normal**  
| | \| | **tee**  
| | \| | **vee**  
  
## Primitive Shapes

Shape | Image  
---|---  
`box` | ![](../info/a_box.gif)  
`crow` | ![](../info/a_crow.gif)  
`curve` | ![](../info/a_curve.gif)  
`diamond` | ![](../info/a_diamond.gif)  
`dot` | ![](../info/a_dot.gif)  
`icurve` | ![](../info/a_icurve.gif)  
`inv` | ![](../info/a_inv.gif)  
`none` | ![](../info/a_none.gif)  
`normal` | ![](../info/a_normal.gif)  
`tee` | ![](../info/a_tee.gif)  
`vee` | ![](../info/a_open.gif)  
  
## Shape Modifiers

As for the modifiers:

`'l'`
    Clip the shape, leaving only the part to the left of the edge.
`'r'`
    Clip the shape, leaving only the part to the right of the edge.
`'o'`
    Use an open (non-filled) version of the shape.

Left and right are defined as those directions determined by looking from the edge towards the point where the arrow "touches" the node.

As an example, the arrow shape `lteeoldiamond` is parsed as `'l' 'tee' 'o' 'l' 'diamond'` and corresponds to the shape:

![](../info/a_lteeoldiamond.gif)

Note that the first arrow shape specified occurs closest to the node. Subsequent arrow shapes, if specified, occur further from the node. Also, a shape of `none` uses space, so, for example, the arrowhead `nonenormal` is not the same as `normal`.

Not all syntactically legal combinations of modifiers are meaningful or semantically valid. For example, none of the modifiers make any sense with `none`. The following table indicates which modifiers are allowed with which shapes.

Modifier | `'l'/'r'` | `o`  
---|---|---  
`box` | ✅ | ✅  
`crow` | ✅ |   
`curve` | ✅ |   
`diamond` | ✅ | ✅  
`dot` |  | ✅  
`icurve` | ✅ |   
`inv` | ✅ | ✅  
`none` |  |   
`normal` | ✅ | ✅  
`tee` | ✅ |   
`vee` | ✅ |   
  
This yields 42 different arrow shapes. The optional second, third, fourth shapes can independently be any of the 42, except the last cannot be `none` as this would create a redundant shape. Thus, there are 41 × 42³ + 41 × 42² + 41 × 42 + 42 = 3,111,696 different combinations.

The following display contains the 42 combinations possible with a single arrow shape. The node attached to the arrow is not drawn but would appear on the right side of the edge.

![](../info/aa_box.gif) | ![](../info/aa_lbox.gif) | ![](../info/aa_rbox.gif) | ![](../info/aa_obox.gif) | ![](../info/aa_olbox.gif) | ![](../info/aa_orbox.gif)  
---|---|---|---|---|---  
box | lbox | rbox | obox | olbox | orbox  
![](../info/aa_crow.gif) | ![](../info/aa_lcrow.gif) | ![](../info/aa_rcrow.gif)  
crow | lcrow | rcrow  
![](../info/aa_diamond.gif) | ![](../info/aa_ldiamond.gif) | ![](../info/aa_rdiamond.gif) | ![](../info/aa_odiamond.gif) | ![](../info/aa_oldiamond.gif) | ![](../info/aa_ordiamond.gif)  
diamond | ldiamond | rdiamond | odiamond | oldiamond | ordiamond  
![](../info/aa_dot.gif) | ![](../info/aa_odot.gif)  
dot | odot  
![](../info/aa_inv.gif) | ![](../info/aa_linv.gif) | ![](../info/aa_rinv.gif) | ![](../info/aa_oinv.gif) | ![](../info/aa_olinv.gif) | ![](../info/aa_orinv.gif)  
inv | linv | rinv | oinv | olinv | orinv  
![](../info/aa_none.gif)  
none  
![](../info/aa_normal.gif) | ![](../info/aa_lnormal.gif) | ![](../info/aa_rnormal.gif) | ![](../info/aa_onormal.gif) | ![](../info/aa_olnormal.gif) | ![](../info/aa_ornormal.gif)  
normal | lnormal | rnormal | onormal | olnormal | ornormal  
![](../info/aa_tee.gif) | ![](../info/aa_ltee.gif) | ![](../info/aa_rtee.gif)  
tee | ltee | rtee  
![](../info/aa_vee.gif) | ![](../info/aa_lvee.gif) | ![](../info/aa_rvee.gif)  
vee | lvee | rvee  
![](../info/aa_curve.gif) | ![](../info/aa_lcurve.gif) | ![](../info/aa_rcurve.gif) | ![](../info/aa_icurve.gif) | ![](../info/aa_licurve.gif) | ![](../info/aa_ricurve.gif)  
curve | lcurve | rcurve | icurve | licurve | ricurve  
