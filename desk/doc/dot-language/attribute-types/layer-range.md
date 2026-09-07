# layerRange

A list of layers defined by the [layers](../attributes/layers.md) attribute

It consists of a list of layer intervals separated by any collection of characters from the [layerlistsep](../attributes/layerlistsep.md) attribute. Each layer interval is specified as either a layerId or a layerId**s** layerId, where layerId = `"all"`, a decimal integer or a [layer](../attributes/layer.md) name. (An integer i corresponds to layer i, layers being numbered from 1.)

The string **s** consists of 1 or more separator characters specified by the [layersep](../attributes/layersep.md) attribute.

Thus, assuming the default values for [layersep](../attributes/layersep.md) and [layerlistsep](../attributes/layerlistsep.md), if `layers="a:b:c:d:e:f:g:h"`, the layerRange string `layers="a:b,d,f:all"` would denote the layers `a b d f g h`.

## Attributes

`layerRange` is a valid type for:

  * [layer](../attributes/layer.md)
  * [layerselect](../attributes/layerselect.md)
