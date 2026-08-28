# label

Text label attached to objects

type: [lblString](../attribute-types/lblString.md), default: `"\N"` (nodes) , `""` (otherwise)

If a node's [shape](shape.md) is record, then the label can have a [special format](../node-shapes.md#record) which describes the record layout.

Note that a node's default label is `"\N"`, so the node's name or ID becomes its label.

Technically, a node's name can be an HTML string but this will not mean that the node's label will be interpreted as an [HTML-like label](../node-shapes.md#html). This is because the node's actual label is an ordinary string, which will be replaced by the raw bytes stored in the node's name.

To get an HTML-like label, the label attribute value itself must be an HTML string.

Example: Van Gogh Paintings

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  label="Vincent van Gogh Paintings"

  subgraph cluster_self_portraits {
    label="Self-portraits"

    spwgfh [label="Self-Portrait with Grey Felt Hat"]
    spaap [label="Self-Portrait as a Painter"]
  }

  subgraph cluster_flowers {
    label="Flowers"

    sf [label="Sunflowers"]
    ab [label="Almond Blossom"]
  }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters
