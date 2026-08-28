# overlap_scaling

Scale layout by factor, to reduce node overlap.

type: [double](../attribute-types/double.md), default: `-4`, minimum: `-1e+10`

When `[overlap](overlap.md)=prism`, the layout is scaled by this factor, thereby removing a fair amount of node overlap, and making node overlap removal faster and better able to retain the graph's shape.

  * If `overlap_scaling` is negative, the layout is scaled by `-1*overlap_scaling` times the average label size.

  * If `overlap_scaling` is positive, the layout is scaled by `overlap_scaling`.

  * If `overlap_scaling` is zero, no scaling is done.


_Valid on:_

  * Graphs



**Note:** [prism](overlap.md), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), [fdp](/docs/layouts/fdp/), [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only.
