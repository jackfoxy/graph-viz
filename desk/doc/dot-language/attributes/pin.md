# pin

Keeps the node at the node's given input position

type: [bool](../attribute-types/bool.md), default: `false`

If true and the node has a [pos](pos.md) attribute on input, `neato` or `fdp` prevents the node from moving from the input position. This property can also be specified in the [pos](pos.md) attribute itself (cf. the [point](../attribute-types/point.md) type).

**Note:** Due to an artifact of the implementation, previous to 27 Feb 2014, final coordinates are translated to the origin. Thus, if you look at the output coordinates given in the (x)dot or plain format, pinned nodes will not have the same output coordinates as were given on input. If this is important, a simple workaround is to maintain the coordinates of a pinned node. The vector difference between the old and new coordinates will give the translation, which can then be subtracted from all of the appropriate coordinates.

After 27 Feb 2014, this translation can be avoided in `neato` by setting `[notranslate](notranslate.md)=true`. However, if the graph specifies [node overlap removal](overlap.md) or a change in aspect [ratio](ratio.md), node coordinates may still change.

_Valid on:_

  * Nodes



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only.
