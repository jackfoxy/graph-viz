# image

Gives the name of a file containing an image to be displayed inside a node

type: [string](../attribute-types/string.md), default: `""`

The image file must be in one of the recognized [formats](/docs/outputs/#image-formats), typically JPEG, PNG, GIF, BMP, SVG, or Postscript, and be able to be converted into the desired output format.

The file must contain the image size information:

  * Bitmap formats usually already contain image size.
  * PostScript files must contain a line starting with `%%BoundingBox:` followed by four integers specifying the lower left x and y coordinates and the upper right x and y coordinates of the bounding box for the image, the coordinates being in points.
  * An SVG image file must contain width and height attributes, typically as part of the svg element. The values for these should have the form of a floating point number, followed by optional units, e.g., `width="76pt"`. Recognized units are in, px, pc, pt, cm and mm for inches, pixels, picas, points, centimeters and millimeters, respectively. The default unit is points.



Unlike with the [shapefile](shapefile.md) attribute, the image is treated as node content rather than the entire node. In particular, an image can be contained in a node of any shape, not just a rectangle.

Only paths to local resources are supported. If you want to use a URL to a remote resource, see the [dot_url_resolve.py](https://gitlab.com/graphviz/graphviz/-/blob/main/contrib/dot_url_resolve.py) script.

_Valid on:_

  * Nodes
