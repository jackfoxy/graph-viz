# orientation

node shape rotation angle, or graph orientation

type: [double](../attribute-types/double.md) | [string](../attribute-types/string.md), default: `0.0`, `""`, minimum: `-360.0`

When used on nodes: Angle, in degrees, to rotate polygon node shapes. For any number of polygon sides, 0 degrees rotation results in a flat base. When used on graphs: If `"[lL]*"`, sets graph orientation to landscape.

Used only if [rotate](rotate.md) is not defined.

Node Orientations

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  layout=neato       # Render in a circular layout
  node [shape=house] # Make all nodes have 'house' shape

    0 [orientation=0]
   45 [orientation=45]
   90 [orientation=90]
  135 [orientation=135]
  180 [orientation=180]
  225 [orientation=225]
  270 [orientation=270]
  315 [orientation=315]
  0 -&gt; 45 -&gt; 90 -&gt; 135 -&gt; 180 -&gt; 225 -&gt; 270 -&gt; 315 -&gt; 0
}</code></pre>
</div>

Landscape Graph Orientation

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  orientation=L
  a -&gt; b
}</code></pre>
</div>

See also:

  * [orientation](orientation.md)
  * [rotate](rotate.md)

_Valid on:_

  * Nodes
  * Graphs
