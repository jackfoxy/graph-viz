# margin

For graphs, this sets x and y margins of canvas, in inches

type: [double](../attribute-types/double.md) | [point](../attribute-types/point.md), default: `<device-dependent>`

If the margin is a single double, both margins are set equal to the given value.

Note that the margin is not part of the drawing but just empty space left around the drawing. The margin basically corresponds to a translation of drawing, as would be necessary to center a drawing on a page. Nothing is actually drawn in the margin. To actually extend the background of a drawing, see the [pad](pad.md) attribute.

For clusters, `margin` specifies the space between the nodes in the cluster and the cluster bounding box. By default, this is 8 points.

For nodes, this attribute specifies space left around the node's label. By default, the value is `0.11,0.055`.

Nodes Example: Wide Margins, Tall Margins, and Equal Margins

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  "1.5x0.5" [shape=rect margin="1.5,0.5"] # in inches
  "0.5x1.5" [shape=rect margin="0.5,1.5"] # in inches
  "1.5x1.5" [shape=rect margin="1.5"]     # in inches
}</code></pre>
</div>

Example: Cluster and Graph Margins

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
    bgcolor=lightgray
    margin=0 # in inches

    subgraph cluster_one {
      margin=8 # in points
      a
      b
    }
    subgraph cluster_two {
      margin=16 # in points
      c
      d
    }
}</code></pre>
</div>

_Valid on:_

  * Nodes
  * Clusters
  * Graphs
