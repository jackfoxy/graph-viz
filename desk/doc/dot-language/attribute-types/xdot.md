# xdot

List of graphical operations in Graphviz's `xdot` language.

xdot is a custom Graphviz language invented by Emden Gansner, describing ellipses, polygons, polylines, beziers, text, images, colors, gradients, fonts, and styles.

Example: `c 7 -#ff0000 p 4 4 4 36 4 36 36 4 36` renders a red square.

For more information on the `xdot` format, see:

  * [xdot section of dot output format](/docs/outputs/canon/#xdot)
  * [PDF Manpage](https://graphviz.org/pdf/xdot.3.pdf)
  * [parseOp function in lib/xdot/xdot.c](https://gitlab.com/graphviz/graphviz/-/blob/main/lib/xdot/xdot.c#L157)
  * [C struct _xdot_op in lib/xdot/xdot.h](https://gitlab.com/graphviz/graphviz/-/blob/main/lib/xdot/xdot.h#L128)



## Attributes

`xdot` is a valid type for:

  * [_background](../attributes/background.md)
