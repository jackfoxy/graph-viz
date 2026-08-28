# nojustify

Whether to justify multiline text vs the previous text line (rather than the side of the container).

type: [bool](../attribute-types/bool.md), default: `false`

By default, the justification of multi-line labels is done within the largest context that makes sense. Thus, in the label of a polygonal node, a left-justified line will align with the left side of the node (shifted by the prescribed [margin](margin.md)). In record nodes, left-justified line will line up with the left side of the enclosing column of fields. If `nojustify=true`, multi-line labels will be justified in the context of itself.

For example, if `nojustify` is set, the first label line is long, and the second is shorter and left-justified, the second will align with the left-most character in the first line, regardless of how large the node might be.

See this example containing the `\l` (left-justify) escape-string:

Nojustify causes text to align with previous text line, not left side of box

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  node [width=3 shape=box]
  a [nojustify=false label="The first line is longer\nnojustify=false\l"]
  b [nojustify=true label="The first line is longer\nnojustify=true\l"]
  a -&gt; b
}</code></pre>
</div>

Nojustify causes text to align with previous text line, not record column

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G{
  c [nojustify=false shape=record label="{Records Example - Long Line\n | Title - Shorter Line\nnojustify=false\l}"]
  d [nojustify=true shape=record label="{Records Example - Long Line\n | Title - Shorter Line\nnojustify=true\l}"]
  c -&gt; d
}</code></pre>
</div>

_Valid on:_

  * Graphs
  * Clusters
  * Nodes
  * Edges
