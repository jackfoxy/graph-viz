# levelsgap

strictness of neato level constraints

type: [double](../attribute-types/double.md), default: `0.0`

Specifies strictness of level constraints in [neato](/docs/layouts/neato/) when `[mode](mode.md)="ipsep"` or `[mode](mode.md)=hier`.

Larger positive values mean stricter constraints, which demand more separation between levels. On the other hand, negative values will relax the constraints by allowing some overlap between the levels.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only. _
