# dpi

Specifies the expected number of pixels per inch on a display device

type: [double](../attribute-types/double.md), default: `96.0`, minimum: `0.0`

For `bitmap` output, `dpi` guarantees that text rendering will be done more accurately, both in size and in placement.

For SVG output, `dpi` guarantees the dimensions in the output correspond to the correct number of points or inches.

_Valid on:_

  * Graphs



**Note:**  bitmap output,[svg](/docs/outputs/svg/) only.
