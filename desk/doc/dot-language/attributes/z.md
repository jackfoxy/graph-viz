# z

Z-coordinate value for 3D layouts and displays

type: [double](../attribute-types/double.md), default: `0.0`

**Deprecated:** Use [pos](pos.md) attribute, along with [dimen](dimen.md) and/or [dim](dim.md) to specify dimensions.

If the graph has [dim](dim.md) set to 3 (or more), neato will use a node's `z` value for the z coordinate of its initial position if its [pos](pos.md) attribute is also defined.

Even if no `z` values are specified in the input, it is necessary to declare a `z` attribute for nodes, e.g, using `node[z=""]` in order to get z values on output. Thus, setting `[dim](dim.md)=3` but not declaring `z` will cause `neato -Tvrml` to layout the graph in 3D but project the layout onto the xy-plane for the rendering. If the `z` attribute is declared, the final rendering will be in 3D.

_Valid on:_

  * Nodes
