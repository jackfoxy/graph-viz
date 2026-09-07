# overlap

Determines if and how node overlaps should be removed

type: [string](../attribute-types/string.md) | [bool](../attribute-types/bool.md), default: `true`

Nodes are first enlarged using the [sep](sep.md) attribute. If `true` , overlaps are retained. If the value is `"scale"`, overlaps are removed by uniformly scaling in x and y. If the value converts to `"false"`, and it is available, Prism, a proximity graph-based algorithm, is used to remove node overlaps. This can also be invoked explicitly with `overlap=prism`. This technique starts with a small scaling up, controlled by the [overlap_scaling](overlap_scaling.md) attribute, which can remove a significant portion of the overlap. The prism option also accepts an optional non-negative integer suffix. This can be used to control the number of attempts made at overlap removal. By default, `overlap="prism"` is equivalent to `overlap="prism1000"`. Setting `overlap="prism0"` causes only the scaling phase to be run.

If Prism is not available, or the version of Graphviz is earlier than 2.28, `"overlap=false"` uses a Voronoi-based technique. This can always be invoked explicitly with `"overlap=voronoi"`.

If `overlap="scalexy"`, x and y are separately scaled to remove overlaps.

If `overlap="compress"`, the layout will be scaled down as much as possible without introducing any overlaps, obviously assuming there are none to begin with.

**N.B.** The remaining allowed values of `overlap` correspond to algorithms which, at present, can produce bad aspect ratios. In addition, we deprecate the use of the `"ortho*"` and `"portho*"`.

If the value is `"vpsc"`, overlap removal is done as a quadratic optimization to minimize node displacement while removing node overlaps.

If the value is `"orthoxy"` or `"orthoyx"`, overlaps are moved by optimizing two constraint problems, one for the x axis and one for the y. The suffix indicates which axis is processed first. If the value is "ortho", the technique is similar to "orthoxy" except a heuristic is used to reduce the bias between the two passes. If the value is `"ortho_yx"`, the technique is the same as `"ortho"`, except the roles of x and y are reversed. The values `"portho"`, `"porthoxy"`, `"porthoxy"`, and `"portho_yx"` are similar to the previous four, except only pseudo-orthogonal ordering is enforced.

If the layout is done by neato with `[mode](mode.md)="ipsep"`, then one can use `overlap=ipsep`. In this case, the overlap removal constraints are incorporated into the layout algorithm itself. N.B. At present, this only supports one level of clustering.

Except for `fdp` and `sfdp`, the layouts assume `overlap="true"` as the default. Fdp first uses a number of passes using a built-in, force-directed technique to try to remove overlaps. Thus, `fdp` accepts `overlap` with an integer prefix followed by a colon, specifying the number of tries. If there is no prefix, no initial tries will be performed. If there is nothing following a colon, none of the above methods will be attempted. By default, `fdp` uses `overlap="9:prism"`. Note that `overlap="true"`, `overlap="0:true"` and `overlap="0:"` all turn off all overlap removal.

By default, `sfdp` uses `overlap="prism0"`.

Except for the Voronoi and prism methods, all of these transforms preserve the orthogonal ordering of the original layout. That is, if the x coordinates of two nodes are originally the same, they will remain the same, and if the x coordinate of one node is originally less than the x coordinate of another, this relation will still hold in the transformed layout. The similar properties hold for the y coordinates. This is not quite true for the `"porth*"` cases. For these, orthogonal ordering is only preserved among nodes related by an edge.

_Valid on:_

  * Graphs



**Note:** [fdp](/docs/layouts/fdp/), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only.
