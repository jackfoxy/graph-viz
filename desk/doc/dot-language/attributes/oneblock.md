# oneblock

Whether to draw circo graphs around one circle.

type: [bool](../attribute-types/bool.md), default: `false`

Observe two examples of rendering the same graph:

Example: Multiple Blocks

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
    layout="circo"
    oneblock=false

    N0 -&gt; N1
    N1 -&gt; N2
    N2 -&gt; N3
    N3 -&gt; N4
    N4 -&gt; N0

    N4 -&gt; N5
    N5 -&gt; N6
    N6 -&gt; N7
    N7 -&gt; N8
    N8 -&gt; N5
}</code></pre>
</div>

Example: One Block

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
    layout="circo"
    oneblock=true

    N0 -&gt; N1
    N1 -&gt; N2
    N2 -&gt; N3
    N3 -&gt; N4
    N4 -&gt; N0

    N4 -&gt; N5
    N5 -&gt; N6
    N6 -&gt; N7
    N7 -&gt; N8
    N8 -&gt; N5
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [circo](/docs/layouts/circo/) only.
