# TBbalance

Which [rank](rank.md) to move floating (loose) nodes to

type: [string](../attribute-types/string.md), default: `''`

Valid options:

  * `"min"`: Move floating (loose) nodes to minimum [rank](rank.md).
  * `"max"`: Move floating (loose) nodes to maximum [rank](rank.md).
  * Otherwise, floating nodes are placed anywhere.



Despite the name `TBbalance` ("Top-Bottom Balance"), this also works with left-right ranks, e.g. [rankdir=LR](rankdir.md).

Examples:

Default Behaviour

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    layout="dot"

    { rank="min"; "min" }
    { rank="max"; "max" }
    "min" -&gt; "middle" -&gt; "max"

    "Floater 1"
    "Floater 2"
}</code></pre>
</div>

Floating nodes moved to min rank

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    layout="dot"
    TBbalance="min"

    { rank="min"; "min" }
    { rank="max"; "max" }
    "min" -&gt; "middle" -&gt; "max"

    "Floater 1"
    "Floater 2"
}</code></pre>
</div>

Floating nodes moved to max rank

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    layout="dot"
    TBbalance="max"

    { rank="min"; "min" }
    { rank="max"; "max" }
    "min" -&gt; "middle" -&gt; "max"

    "Floater 1"
    "Floater 2"
}</code></pre>
</div>

_Valid on:_

  * Graphs



**Note:** [dot](/docs/layouts/dot/) only.
