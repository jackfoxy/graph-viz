# K

Spring constant used in virtual physical model

type: [double](../attribute-types/double.md), default: `0.3`, minimum: `0`

It roughly corresponds to an ideal edge length (in inches), in that increasing `K` tends to increase the distance between nodes.

Note that the edge attribute [len](len.md) can be used to override this value for adjacent nodes.

_Valid on:_

  * Graphs
  * Clusters



**Note:** [fdp](/docs/layouts/fdp/), [sfdp](/docs/layouts/sfdp/) only.
