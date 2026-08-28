# clusterrank

Mode used for handling clusters

type: [clusterMode](../attribute-types/clusterMode.md), default: `local`

If `clusterrank=local`, a subgraph whose name begins with `cluster` is given special treatment.

The subgraph is laid out separately, and then integrated as a unit into its parent graph, with a bounding rectangle drawn about it. If the cluster has a [label](label.md) parameter, this label is displayed within the rectangle.

Note also that there can be clusters within clusters.

The modes `clusterrank=global` and `clusterrank=none` appear to be identical, both turning off the special cluster processing.

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only.
