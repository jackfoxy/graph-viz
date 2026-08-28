# id

Identifier for graph objects

type: [escString](../attribute-types/escString.md), default: `""`

Allows the graph author to provide an identifier for graph objects which is to be included in the output.

Normal `\N`, `\E`, `\G` substitutions are applied.

If provided, it is the responsibility of the provider to keep `id` values unique for its intended downstream use.

Note, in particular, that `\E` does not provide a unique id for multi-edges.

If no `id` attribute is provided, then a unique internal id is used. However, this value is unpredictable by the graph writer.

If the graph provides an `id` attribute, this will be used as a prefix for internally generated attributes. By making internally-used attributes distinct, the user can include multiple image maps in the same document.

_Valid on:_

  * Graphs
  * Clusters
  * Nodes
  * Edges



**Note:**  map,[postscript](/docs/outputs/ps/), [svg](/docs/outputs/svg/) only.
