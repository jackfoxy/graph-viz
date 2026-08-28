# bgcolor

Canvas background color

type: [color](../attribute-types/color.md) | [colorList](../attribute-types/colorList.md), default: `<none>`

When attached to the root graph, this color is used as the background for entire canvas.

When a cluster attribute, it is used as the initial background for the cluster. If a cluster has a filled [style](style.md), the cluster's [fillcolor](fillcolor.md) will overlay the background color.

If the value is a [colorList](../attribute-types/colorList.md), a gradient fill is used. By default, this is a linear fill; setting `[style](style.md)=radial` will cause a radial fill. Only two colors are used. If the second color (after a colon) is missing, the default color is used for it. See also the [gradientangle](gradientangle.md) attribute for setting the gradient angle.

For certain output formats, such as PostScript, no fill is done for the root graph unless `bgcolor` is explicitly set.

For bitmap formats, however, the bits need to be initialized to something, so the canvas is filled with white by default. This means that if the bitmap output is included in some other document, all of the bits within the bitmap's bounding box will be set, overwriting whatever color or graphics were already on the page. If this effect is not desired, and you only want to set bits explicitly assigned in drawing the graph, set `bgcolor="transparent"`.

Example

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  bgcolor="lightblue"
  label="Home"
  subgraph cluster_ground_floor {
    bgcolor="lightgreen"
    label="Ground Floor"
    Lounge
    Kitchen
  }
  subgraph cluster_top_floor {
    bgcolor="lightyellow"
    label="Top Floor"
    Bedroom
    Bathroom
  }
}</code></pre>
</div>

_Valid on:_

  * Graphs
  * Clusters
