# rank

Rank constraints on the nodes in a subgraph

type: [rankType](../attribute-types/rankType.md)

  * If `rank="same"`, all nodes are placed on the same rank.
  * If `rank="min"`, all nodes are placed on the minimum rank.
  * If `rank="source"`, all nodes are placed on the minimum rank, and the only nodes on the minimum rank belong to some subgraph with `rank="source"` or `rank="min"`.



Analogous criteria hold for `rank="max"` and `rank="sink"`.

(Note: the minimum rank is topmost or leftmost, and the maximum rank is bottommost or rightmost.)

For more information check [this answer in Stack Overflow](https://stackoverflow.com/a/6155783/3416774)

_Valid on:_

  * Subgraphs



**Note:** [dot](/docs/layouts/dot/) only.
