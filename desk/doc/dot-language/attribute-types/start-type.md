# startType

How to initially layout nodes

Has the syntax `(style)?(seed)?`.

If `style` is present, it must be one of the strings:

  * `"regular"`: place nodes regularly about a circle
  * `"self"`: run an abbreviated version of neato to obtain the initial layout
  * `"random"`: place nodes randomly in a unit square.



If `seed` is present, it specifies a seed for the random number generator. If `seed` is a positive number, this is used as the seed. If it is anything else, the current time, and possibly the process id, is used to pick a seed, thereby making the choice more random. In this case, the seed value is stored in the graph.

If the value is just `"random"`, a time-based seed is chosen.

Note that input positions, specified by a node's [pos](../attributes/pos.md) attribute, are only used when the style is `"random"`.

## Attributes

`startType` is a valid type for:

  * [start](../attributes/start.md)
