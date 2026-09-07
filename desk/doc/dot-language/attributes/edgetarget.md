# edgetarget

Browser window to use for the [edgeURL](edge-url.md) link

type: [escString](../attribute-types/escString.md), default: `<none>`

If the edge has a [URL](url.md) or [edgeURL](edge-url.md) attribute, `edgetarget` determines which window of the browser is used for the URL attached to the non-label part of the edge.

Setting `edgetarget=_graphviz` will open a new window if it doesn't already exist, or reuse it if it does.

If undefined, the value of the [target](target.md) is used instead.

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only.
