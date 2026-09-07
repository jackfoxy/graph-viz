# epsilon

Terminating condition

type: [double](../attribute-types/double.md), default: `.0001 * # nodes` (mode == KK) , `.0001` (mode == major) , `.01` (mode == sgd)

If the length squared of all energy gradients are less than `epsilon`, the algorithm stops.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only.
