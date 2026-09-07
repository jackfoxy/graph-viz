# skew

Skew factor for `[shape](shape.md)=polygon`

type: [double](../attribute-types/double.md), default: `0.0`, minimum: `-100.0`

Positive values skew top of polygon to right; negative to left.

See also [distortion](distortion.md).

Example

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  SkewLeft  [shape=polygon sides=4 skew=-.5]
  SkewRight [shape=polygon sides=4 skew=.5]
}</code></pre>
</div>

_Valid on:_

  * Nodes
