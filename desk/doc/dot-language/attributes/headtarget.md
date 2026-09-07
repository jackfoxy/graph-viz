# headtarget

Browser window to use for the [headURL](head-url.md) link

type: [escString](../attribute-types/escString.md), default: `<none>`

If the edge has a [headURL](head-url.md), `headtarget` determines which window of the browser is used for the URL. Setting `headURL=_graphviz` will open a new window if the window doesn't already exist, or reuse the window if it does.

If undefined, the value of the [target](target.md) is used.

_Valid on:_

  * Edges



**Note:**  map,[svg](/docs/outputs/svg/) only. _
