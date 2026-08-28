# sep

Margin to leave around nodes when removing node overlap

type: [addDouble](../attribute-types/addDouble.md) | [addPoint](../attribute-types/addPoint.md), default: `+4`

This guarantees a minimal non-zero distance between nodes.

If the attribute begins with a plus sign `'+'`, an additive margin is specified. That is, `"+w,h"` causes the node's bounding box to be increased by `w` points on the left and right sides, and by `h` points on the top and bottom.

Without a plus sign, the node is scaled by `1 + w` in the x coordinate and `1 + h` in the y coordinate.

If only a single number is given, this is used for both dimensions.

If unset but [esep](esep.md) is defined, the `sep` values will be set to the [esep](esep.md) values divided by `0.8`. If [esep](esep.md) is unset, the default value is used.

Example: No separation

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
    layout="fdp"
    sep="0"
    A -- B
    B -- C
    C -- D
    D -- A
}</code></pre>
</div>

Example: separation of 3

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
    layout="fdp"
    sep="3"
    A -- B
    B -- C
    C -- D
    D -- A
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [fdp](/docs/layouts/fdp/), [neato](/docs/layouts/neato/), [sfdp](/docs/layouts/sfdp/), osage, [circo](/docs/layouts/circo/), [twopi](/docs/layouts/twopi/) only.
