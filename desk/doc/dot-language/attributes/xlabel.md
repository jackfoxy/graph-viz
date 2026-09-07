# xlabel

External label for a node or edge

type: [lblString](../attribute-types/lblString.md), default: `""`

  * For nodes, the label will be placed outside of the node but near it.
  * For edges, the label will be placed near the center of the edge. This can be useful in dot to avoid the occasional problem when the use of edge labels distorts the layout.
  * For other layouts, the xlabel attribute can be viewed as a synonym for the [label](label.md) attribute.



These labels are added after all nodes and edges have been placed.

The labels will be placed so that they do not overlap any node or label. This means it may not be possible to place all of them. To force placing all of them, set `[forcelabels](forcelabels.md)=true`.

External Labels on Nodes and Edges

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  "⚡" [xlabel="Sparks"]
  "🔥" [xlabel="Fires"]
  "⚡"-&gt;"🔥" [xlabel="Sometimes" label="Cause"]
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
