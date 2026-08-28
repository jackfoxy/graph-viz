# Damping

Factor damping force motions.

type: [double](../attribute-types/double.md), default: `0.99`, minimum: `0.0`

On each iteration, a node's movement is limited to this factor of its potential motion. By being less than `1.0`, the system tends to "cool", thereby preventing cycling.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only.
