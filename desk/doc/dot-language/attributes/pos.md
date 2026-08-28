# pos

Position of node, or spline control points

type: [point](../attribute-types/point.md) | [splineType](../attribute-types/splineType.md)

For nodes, the position indicates the center of the node. On output, the coordinates are in [points](../attributes.md#points).

In `neato` and `fdp`, `pos` can be used to set the initial position of a node. By default, the coordinates are assumed to be in inches. However, the [-s](/doc/info/command.html#-s) command line flag can be used to specify different units. As the output coordinates are in points, feeding the output of a graph laid out by a Graphviz program into `neato` or `fdp` will almost always require the [-s](/doc/info/command.html#-s) flag.

When the [-n](/doc/info/command.html#-n) command line flag is used with `neato`, it is assumed the positions have been set by one of the layout programs, and are therefore in points. Thus, `neato -n` can accept input correctly without requiring a [-s](/doc/info/command.html#-s) flag and, in fact, ignores any such flag.

_Valid on:_

  * Edges
  * Nodes



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only.
