# tooltip

Tooltip (mouse hover text) attached to the node, edge, cluster, or graph

type: [escString](../attribute-types/escString.md), default: `""`

If `tooltip` is unset, Graphviz will use the object's [label](label.md) if defined.

Note that if the `label` is a record specification or an HTML-like label, the resulting tooltip may be unhelpful. In this case, if tooltips will be generated, the user should set a `tooltip` attribute explicitly.

Tooltips

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
  label="Graph Label"
  tooltip="Graph Tooltip"
  subgraph cluster_a {
    label="Cluster Label"
    tooltip="Cluster Tooltip"
    Node1 [tooltip="Node1 Tooltip"]
    Node1 -&gt; Node2 [label="Edge" tooltip="Edge Tooltip"]
  }
}</code></pre>
</div>

See also:

  * [edgetooltip](edgetooltip.md).
  * [headtooltip](headtooltip.md).
  * [labeltooltip](labeltooltip.md).
  * [tailtooltip](tailtooltip.md).

_Valid on:_

  * Nodes
  * Edges
  * Clusters
  * Graphs



**Note:** [cmap](/docs/outputs/cmap/), [svg](/docs/outputs/svg/) only.
