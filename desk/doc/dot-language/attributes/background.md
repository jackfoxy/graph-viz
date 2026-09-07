# _background

A string in the [`xdot` format](../attribute-types/xdot.md) specifying an arbitrary background

type: [xdot](../attribute-types/xdot.md), default: `<none>`

During rendering, the canvas is first filled as described in the
[`bgcolor` attribute](bgcolor.md).

Then, if `_background` is defined, the graphics
operations described in the string are performed on the canvas.

See [`xdot` format](../attribute-types/xdot.md) page for more information.

Render a red square in the background

```
digraph G {
  _background="c 7 -#ff0000 p 4 4 4 36 4 36 36 4 36";
  a -> b
}
```

*Valid on:*

- Graphs
