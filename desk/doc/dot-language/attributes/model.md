# model

Specifies how the distance matrix is computed for the input graph

type: [string](../attribute-types/string.md), default: `shortpath`

The distance matrix specifies the ideal distance between every pair of nodes. `neato` attempts to find a layout which best achieves these distances. By default, it uses the length of the shortest path, where the length of each edge is given by its [len](len.md) attribute.

  * If `model="circuit"`, neato uses the circuit resistance model to compute the distances. This tends to emphasize clusters.
  * If `model="subset"`, neato uses the subset model. This sets the edge length to be the number of nodes that are neighbors of exactly one of the end points, and then calculates the shortest paths. This helps to separate nodes with high degree.



For more control of distances, one can use `model=mds`. In this case, the [len](len.md) of an edge is used as the ideal distance between its vertices.

A shortest path calculation is only used for pairs of nodes not connected by an edge. Thus, by supplying a complete graph, the input can specify all of the relevant distances.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only.
