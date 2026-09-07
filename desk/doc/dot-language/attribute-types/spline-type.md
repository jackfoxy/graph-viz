# splineType

`spline ( ';' spline )*`

  * where `spline` = `(endp)? (startp)? point (triple)+`
  * and `triple` = `point point point`
  * and `endp` = `"e,%f,%f"`
  * and `startp` = `"s,%f,%f"`



If a spline has points p₁ p₂ p₃ ... pₙ, (n = 1 (mod 3)), the points correspond to the control points of a cubic B-spline from p₁ to pₙ. If startp is given, it touches one node of the edge, and the arrowhead goes from p₁ to startp. If startp is not given, p₁ touches a node. Similarly for pₙ and endp.

## Attributes

`splineType` is a valid type for:

  * [pos](../attributes/pos.md)
