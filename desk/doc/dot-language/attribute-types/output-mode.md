# outputMode

The order in which nodes and edges are drawn in output.

  * `"breadthfirst"`

  * `"nodesfirst"`

  * `"edgesfirst"`

  * The default `"breadthfirst"` is the simplest, but when the graph layout does not avoid edge-node overlap, this mode will sometimes have edges drawn over nodes and sometimes on top of nodes.

  * If the mode `"nodesfirst"` is chosen, all nodes are drawn first, followed by the edges. This guarantees an edge-node overlap will not be mistaken for an edge ending at a node.

  * On the other hand, usually for aesthetic reasons, it may be desirable that all edges appear beneath nodes, even if the resulting drawing is ambiguous. This can be achieved by choosing `"edgesfirst"`.




## Attributes

`outputMode` is a valid type for:

  * [outputorder](../attributes/outputorder.md)
