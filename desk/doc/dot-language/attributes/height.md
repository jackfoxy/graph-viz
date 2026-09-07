# height

Height of node, in inches

type: [double](../attribute-types/double.md), default: `0.5`, minimum: `0.02`

This is taken as the initial, minimum height of the node. If [fixedsize](fixedsize.md) is true, this will be the final height of the node. Otherwise, if the node label requires more height to fit, the node's height will be increased to contain the label.

If the output format is `dot`, the value given to `height` will be the final value.

If the node shape is regular, the width and height are made identical:

  * If both the `width` and the `height` are set explicitly, the maximum of the two values is used.
  * If one of `width` or `height` is set explicitly, that value is used for both `width` and `height`.
  * If neither is set explicitly, the minimum of the two default values is used.



If a value below the minimum value (0.02) is set, it will be rounded up to this minimum.

Height Example

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  "default"
  "1in" [height=1]
  "2in" [height=2]
}</code></pre>
</div>

See also:

  * [width](width.md)

_Valid on:_

  * Nodes
