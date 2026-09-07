# fontnames

Allows user control of how basic fontnames are represented in SVG output

type: [string](../attribute-types/string.md), default: `""`

If `fontnames` is undefined or `hd`, fontconfig font conventions are used. The default `Times-Roman` font will be mapped to an equivalent available system font, such as `Times New Roman` (Windows) or `Times` (some Linux).

If `fontnames` is set to `svg`, the output will use known SVG fontnames. If `fontnames` is set to `ps`, PostScript font names like `Times-Roman` are used directly.

In all cases, the basic SVG font `serif` is used as a fallback for the named font. (So, a diagram containing text in `Times-Roman` might have that text represented in the SVG output by a `<text>` tag with the attribute `font-family="Times-Roman,serif"`.)

_Valid on:_

  * Graphs



**Note:** [svg](/docs/outputs/svg/) only.
