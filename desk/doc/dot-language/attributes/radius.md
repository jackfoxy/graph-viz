# radius

Radius of rounded corners on orthogonal edges

type: [double](../attribute-types/double.md), default: `0`, minimum: `0`

Controls the radius of rounded corners on orthogonal edges. This attribute only has an effect when [splines=ortho](splines.md) is set in the graph. When set to a value greater than 0, edge corners are rendered as smooth circular arcs instead of sharp 90-degree angles. The value specifies the radius of the arc in points. A value of 0 (default) produces square corners.

Available from Graphviz version ≥ 14.1.0.

Orthogonal Edges with Rounded Corners

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph RoundedEdges {
  splines = ortho;
  nodesep = 1.0;
  ranksep = 1.0;

  // Default: square corners
  A -&gt; X [xlabel="radius=0 (default)"];

  // Small rounded corners
  B -&gt; X [radius=8, xlabel="radius=8", color=blue];

  // Medium rounded corners
  C -&gt; X [radius=12, xlabel="radius=12", color=green];

  // Large rounded corners
  D -&gt; X [radius=20, xlabel="radius=20", color=red];
}</code></pre>
</div>

See also:

  * [splines](splines.md)

_Valid on:_

  * Edges
