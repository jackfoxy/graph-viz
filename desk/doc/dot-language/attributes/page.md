# page

Width and height of output pages, in inches

type: [double](../attribute-types/double.md) | [point](../attribute-types/point.md)

If only a single value is given, this is used for both the width and height.

If `page` is set and is smaller than the size of the layout, a rectangular array of pages of the specified page size is overlaid on the layout, with origins aligned in the lower-left corner, thereby partitioning the layout into pages. The pages are then produced one at a time, in [pagedir](pagedir.md) order.

At present, `page` only works for PostScript output. For other types of output, use another tool to split the output into multiple output files, or use [viewport](viewport.md) to generate multiple files.

_Valid on:_

  * Graphs
