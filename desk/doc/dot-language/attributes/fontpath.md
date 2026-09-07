# fontpath

Directory list used by [libgd](https://libgd.github.io/) to search for bitmap fonts

type: [string](../attribute-types/string.md), default: `<system-dependent>`

Used if Graphviz was not built with the [fontconfig library](https://www.freedesktop.org/wiki/Software/fontconfig/).

If `fontpath` is not set, the environment variable `DOTFONTPATH` is checked.

If `DOTFONTPATH` is not set, `GDFONTPATH` is checked.

If `GDFONTPATH` not set, libgd uses its compiled-in font path.

Note that `fontpath` is an attribute of the root graph.

_Valid on:_

  * Graphs
