# tailtarget

Browser window to use for the [tailURL](tail-url.md) link

type: [escString](../attribute-types/escString.md), default: `<none>`

If the edge has a [tailURL](tail-url.md), `tailtarget` determines which window of the browser is used for the URL.

Setting `tailtarget=_graphviz` will open a new window if it doesn't already exist, or reuse it if it does.

If undefined, the value of the [target](target.md) is used.

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only.
