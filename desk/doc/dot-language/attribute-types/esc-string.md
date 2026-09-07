# escString

String with backslashed escape sequences

A [string](string.md) allowing escape sequences which are replaced according to the context. For node attributes, the substring `\N` is replaced by the name of the node, and the substring `\G` by the name of the graph. For graph or cluster attributes, the substring `\G` is replaced by the name of the graph or cluster. For edge attributes, the substring `\E` is replaced by the name of the edge, the substring `\G` is replaced by the name of the graph or cluster, and the substrings `\T` and `\H` by the names of the tail and head nodes, respectively. The name of an edge is the string formed from the name of the tail node, the appropriate edge operator (`--` or `->`) and the name of the head node. In all cases, the substring `\L` is replaced by the object's label attribute.

In addition, if the associated attribute is [label](../attributes/label.md), [headlabel](../attributes/headlabel.md) or [taillabel](../attributes/taillabel.md), the escape sequences `\n`, `\l` and `\r` divide the label into lines, centered, left-justified, and right-justified, respectively.

Obviously, one can use `\\` to get a single backslash. A backslash appearing before any character not listed above is ignored.

## Attributes

`escString` is a valid type for:

  * [edgehref](../attributes/edgehref.md)
  * [edgetarget](../attributes/edgetarget.md)
  * [edgetooltip](../attributes/edgetooltip.md)
  * [edgeURL](../attributes/edge-url.md)
  * [headhref](../attributes/headhref.md)
  * [headtarget](../attributes/headtarget.md)
  * [headtooltip](../attributes/headtooltip.md)
  * [headURL](../attributes/head-url.md)
  * [href](../attributes/href.md)
  * [id](../attributes/id.md)
  * [labelhref](../attributes/labelhref.md)
  * [labeltarget](../attributes/labeltarget.md)
  * [labeltooltip](../attributes/labeltooltip.md)
  * [labelURL](../attributes/label-url.md)
  * [tailhref](../attributes/tailhref.md)
  * [tailtarget](../attributes/tailtarget.md)
  * [tailtooltip](../attributes/tailtooltip.md)
  * [tailURL](../attributes/tail-url.md)
  * [target](../attributes/target.md)
  * [tooltip](../attributes/tooltip.md)
  * [URL](../attributes/url.md)
