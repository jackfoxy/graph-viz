# shapefile

A file containing user-supplied node content

type: [string](../attribute-types/string.md), default: `""`

_(Deprecated)_.

Sets the node's `[shape](shape.md)="[box](../node-shapes.md#polygon)"`. The image in the shapefile must be rectangular. The image formats supported as well as the precise semantics of how the file is used depends on the [output format](/docs/outputs/). For further details, see [Image Formats](/docs/outputs/#image-formats) and [External PostScript files](https://www.graphviz.org/faq/#ext_image).

There is one exception to this usage: If `[shape](shape.md)="epsf"`, `shapefile` gives a filename containing a definition of the node in PostScript. The graphics defined must be contain all of the node content, including any desired boundaries. For further details, see [External PostScript files](https://www.graphviz.org/faq/#ext_ps_file).

Only paths to local resources are supported. If you want to use a URL to a remote resource, see the [dot_url_resolve.py](https://gitlab.com/graphviz/graphviz/-/blob/main/contrib/dot_url_resolve.py) script.

_Valid on:_

  * Nodes
