# dir

Edge type for drawing arrowheads

type: [dirType](../attribute-types/dirType.md), default: `forward` (directed) , `none` (undirected)

Indicates which ends of the edge should be decorated with an arrowhead.

The actual style of the arrowhead can be specified using the [arrowhead](arrowhead.md) and [arrowtail](arrowtail.md) attributes.

See [limitation](../attributes.md#undir_note).

Example

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  A-&gt;B [dir=forward]
  C-&gt;D [dir=back]
  E-&gt;F [dir=both]
  G-&gt;H [dir=none]
}</code></pre>
</div>

_Valid on:_

  * Edges
