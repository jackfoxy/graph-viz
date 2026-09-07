# labeltarget

Browser window to open [labelURL](label-url.md) links in

type: [escString](../attribute-types/escString.md), default: `<none>`

If the edge has a [URL](url.md) or [labelURL](label-url.md) attribute, this attribute determines which window of the browser is used for the URL attached to the label.

Setting `labeltarget=_graphviz` will open a new window if it doesn't already exist, or reuse it if it does.

If undefined, the value of the [target](target.md) is used.

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _
