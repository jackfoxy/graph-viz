# weight

Weight of edge

type: [int](../attribute-types/int.md) | [double](../attribute-types/double.md), default: `1`, minimum: `0(dot,twopi)`, `1(neato,fdp)`

In `dot`, the heavier the weight, the shorter, straighter and more vertical the edge is.

For `twopi`, `weight=0` indicates the edge should not be used in constructing a spanning tree from the root.

For other layouts, a larger weight encourages the layout to make the edge length closer to that specified by the [len](len.md) attribute.

Weights in `dot` must be integers.

Edge Weights

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  root -&gt; a
  root -&gt; b [weight=2]
  root -&gt; c [weight=3]
}</code></pre>
</div>

_Valid on:_

  * Edges
