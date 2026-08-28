# imagepos

Controls how an image is positioned within its containing node

type: [string](../attribute-types/string.md), default: `"mc"`

`imagepos` only has an effect when the image is smaller than the containing node.

The default is to be centered both horizontally and vertically.

Valid values:

  * `tl` \- Top Left
  * `tc` \- Top Centered
  * `tr` \- Top Right
  * `ml` \- Middle Left
  * `mc` \- Middle Centered _(the default)_
  * `mr` \- Middle Right
  * `bl` \- Bottom Left
  * `bc` \- Bottom Centered
  * `br` \- Bottom Right

_Valid on:_

  * Nodes
