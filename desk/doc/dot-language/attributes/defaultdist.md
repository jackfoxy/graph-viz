# defaultdist

The distance between nodes in separate connected components

type: [double](../attribute-types/double.md), default: `1+(avg. len)*sqrt(|V|)`, minimum: `epsilon`

If set too small, connected components may overlap.

Only applicable if `[pack](pack.md)=false`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only.
