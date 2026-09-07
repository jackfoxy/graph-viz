# inputscale

Scales the input [positions](pos.md) to convert between length units

type: [double](../attribute-types/double.md), default: `<none>`

For layout algorithms that support initial input positions (specified by the [pos](pos.md) attribute), this attribute can be used to appropriately scale the values.

By default, [fdp](/docs/layouts/fdp/) and [neato](/docs/layouts/neato/) interpret the x and y values of [pos](pos.md) as being in inches. (**NOTE:** `neato -n(2)` treats the coordinates as being in points, being the unit used by the layout algorithms for the pos attribute.) Thus, if the graph has pos attributes in points, one should set `inputscale=72`. This can also be set on the command line using the [-s` flag](/doc/info/command.html#-s).

If unset, no scaling is done and the units on input are treated as inches.

`inputscale=0` is equivalent to `inputscale=72`.

_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/), [fdp](/docs/layouts/fdp/) only.
