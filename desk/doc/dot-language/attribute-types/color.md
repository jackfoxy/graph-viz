# color

Colors can be specified using one of five formats:

`"#%2x%2x%2x"` | Red-Green-Blue (RGB)
---|---
`"#%1x%1x%1x"` | Shorthand Red-Green-Blue (RGB)
`"#%2x%2x%2x%2x"` | Red-Green-Blue-Alpha (RGBA)
`"H[, ]+S[, ]+V"` | Hue-Saturation-Value (HSV) 0.0 <= H,S,V <= 1.0
`"H[, ]+S[, ]+V[, ]A"` | Hue-Saturation-Value-Alpha (HSVA) 0.0 <= H,S,V,A <= 1.0
string | [color name](../color-names.md)

The specification for the RGB and RGBA formats are the format strings used by `sscanf` to scan the color value. Thus, these values have the form "#RGB" or "#RGBA", where R, G, B, and A each consist of 2 hexadecimal digits, and can be separated by whitespace. As of Graphviz 9.0.0, RGB components can also be given as 1 hexadecimal digit. These are each doubled to form 2-digit components, similar to shorthand HTML colors. HSV colors have the form of 3 or (as of Graphviz 8.0.1) 4 numbers between 0 and 1, separated by whitespace or commas.

String-valued color specifications are case-insensitive and interpreted in the context of the current color scheme, as specified by the [colorscheme](../attributes/colorscheme.md) attribute. If this is undefined, the X11 naming scheme will be used. An initial `"/"` character can be used to override the use of the `colorscheme` attribute. In particular, a single initial `"/"` will cause the string to be evaluated using the default X11 naming. If the color value has the form `"/ssss/yyyy"`, the name `yyyy` is interpreted using the schema `ssss`. If the color scheme name is empty, i.e., the color has the form `"//yyyy"`, the `colorscheme` attribute is used. Thus, the forms `"yyyy"` and `"//yyyy"` are equivalent.

At present, Graphviz recognizes the default color scheme `X11`, and the [Brewer color schemes](../color-names.md#brewer) (cf. [ColorBrewer](https://en.wikipedia.org/wiki/ColorBrewer)). Please note that Brewer color schemes are covered by this [license](../color-names.md#brewer_license).

Examples:

<table>
  <thead>
    <tr>
      <th>Color</th>
      <th>RGB</th>
      <th>HSV</th>
      <th>String</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="background-color: #ffffff; color: #000000;">White</td>
      <td><code>"#ffffff"</code></td>
      <td><code>"0.000 0.000 1.000"</code></td>
      <td><code>"white"</code></td>
    </tr>
    <tr>
      <td style="background-color: #000000; color: #ffffff;">Black</td>
      <td><code>"#000000"</code></td>
      <td><code>"0.000 0.000 0.000"</code></td>
      <td><code>"black"</code></td>
    </tr>
    <tr>
      <td style="background-color: #ff0000; color: #ffffff;">Red</td>
      <td><code>"#ff0000"</code></td>
      <td><code>"0.000 1.000 1.000"</code></td>
      <td><code>"red"</code></td>
    </tr>
    <tr>
      <td style="background-color: #40e0d0; color: #000000;">Turquoise</td>
      <td><code>"#40e0d0"</code></td>
      <td><code>"0.482 0.714 0.878"</code></td>
      <td><code>"turquoise"</code></td>
    </tr>
    <tr>
      <td style="background-color: #a0522d; color: #ffffff;">Sienna</td>
      <td><code>"#a0522d"</code></td>
      <td><code>"0.051 0.718 0.627"</code></td>
      <td><code>"sienna"</code></td>
    </tr>
  </tbody>
</table>

The string value `transparent` can be used to indicate no color. This is only available in the output formats ps, svg, fig, vmrl, and the bitmap formats. It can be used whenever a color is needed but is most useful with the [bgcolor](../attributes/bgcolor.md) attribute. Usually, the same effect can be achieved by setting [style](../attributes/style.md) to `invis`.

## Attributes

`color` is a valid type for:

  * [bgcolor](../attributes/bgcolor.md)
  * [color](../attributes/color.md)
  * [fillcolor](../attributes/fillcolor.md)
  * [fontcolor](../attributes/fontcolor.md)
  * [labelfontcolor](../attributes/labelfontcolor.md)
  * [pencolor](../attributes/pencolor.md)
