# notranslate

Whether to avoid translating layout to the origin point

type: [bool](../attribute-types/bool.md), default: `false`

By default, the final layout is translated so that the lower-left corner of the bounding box is at the origin.

This can be annoying if some nodes are pinned or if the user runs `neato -n`.

To avoid this translation, set `notranslate=true`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only.
