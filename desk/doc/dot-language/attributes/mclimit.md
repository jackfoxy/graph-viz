# mclimit

Scale factor for mincross (mc) edge crossing minimizer parameters

type: [double](../attribute-types/double.md), default: `1.0`

Multiplicative scale factor used to alter the `MinQuit` (default = 8) and `MaxIter` (default = 24) parameters used during crossing minimization.

These correspond to the number of tries without improvement before quitting and the maximum number of iterations in each pass.

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only.
