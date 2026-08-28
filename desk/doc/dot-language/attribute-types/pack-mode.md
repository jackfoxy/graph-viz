# packMode

How closely to pack together graph components

  * `"node"`
  * `"cluster"`
  * `"graph"`
  * `"array(_flags)?(%d)?"`



The modes `"node"`, `"cluster"` or `"graph"` specify that the components should be packed together tightly, using the specified granularity. A value of `"node"` causes packing at the node and edge level, with no overlapping of these objects. This produces a layout with the least area, but it also allows interleaving, where a node of one component may lie between two nodes in another component. A value of `"graph"` does a packing using the bounding box of the component. Thus, there will be a rectangular region around a component free of elements of any other component. A value of `"cluster"` guarantees that top-level clusters are kept intact. What effect a value has also depends on the layout algorithm. For example, `neato` does not support clusters, so a value of `"cluster"` will have the same effect as the default `"node"` value.

The mode `"array(_flag)?(%d)?"` indicates that the components should be packed at the graph level into an array of graphs. By default, the components are in row-major order, with the number of columns roughly the square root of the number of components. If the optional flags contains `'c'`, then column-major order is used. Finally, if the optional integer suffix is used, this specifies the number of columns for row-major or the number of rows for column-major. Thus, the mode `"array_c4"` indicates array packing, with 4 rows, starting in the upper left and going down the first column, then down the second column, etc., until all components are used.

If a graph is smaller than the array cell it occupies, it is centered by default. The optional flags may contain `'t'`, `'b'`, `'l'`, or `'r'`, indicating that the graphs should be aligned along the top, bottom, left or right, respectively.

By default, the insertion order is determined by sorting the graphs by size, largest to smallest. If the optional flags contains `'u'`, this causes the insertion order of elements in the array to be determined by user-supplied values. Each component can specify its sort value by a non-negative integer using the [sortv](../attributes/sortv.md) attribute. Components are inserted in order, starting with the one with the smallest sort value. If no sort value is specified, zero is used. The `'i'` flag indicates that no sorting is done, with the graphs inserted in input order.

## Attributes

`packMode` is a valid type for:

  * [packmode](../attributes/packmode.md)
