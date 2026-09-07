# normalize

normalizes coordinates of final layout

type: [double](../attribute-types/double.md) | [bool](../attribute-types/bool.md), default: `false`

So that the first point is at the origin, and then rotates the layout so that the angle of the first edge is specified by the value of `normalize` in degrees.

If `normalize` is not a number, it is evaluated as a bool, with `true` corresponding to `0` degrees.

**NOTE:** Since the attribute is evaluated first as a number, `0` and `1` cannot be used for `false` and `true`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/), [twopi](/docs/layouts/twopi/), [circo](/docs/layouts/circo/) only.
