# class

Classnames to attach to the node, edge, graph, or cluster's SVG element

type: [string](../attribute-types/string.md), default: `""`

Combine with [stylesheet](stylesheet.md) for styling SVG output using CSS classnames.

Multiple space-separated classes are supported.

See also:

  * [stylesheet](stylesheet.md)
  * [id](id.md)



Example:

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  graph [class="cats"];

  subgraph cluster_big {
    graph [class="big_cats"];

    "Lion" [class="yellow social"];
    "Snow Leopard" [class="white solitary"];
  }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Clusters
  * Graphs



**Note:** [svg](/docs/outputs/svg/) only.
