# URL

Hyperlinks incorporated into device-dependent output

type: [escString](../attribute-types/escString.md), default: `<none>`

At present, used in `ps2`, `cmap`, `i*map` and `svg` formats. For all these formats, URLs can be attached to nodes, edges and clusters. URL attributes can also be attached to the root graph in `ps2`, `cmap` and `i*map` formats. This serves as the base URL for relative URLs in the former, and as the default image map file in the latter.

For `svg`, `cmapx` and `imap` output, the active area for a node is its visible image. For example, an unfilled node with no drawn boundary will only be active on its label. For other output, the active area is its bounding box. The active area for a cluster is its bounding box. For edges, the active areas are small circles where the edge contacts its head and tail nodes. In addition, for `svg`, `cmapx` and `imap`, the active area includes a thin polygon approximating the edge. The circles may overlap the related node, and the edge URL dominates. If the edge has a label, this will also be active. Finally, if the edge has a head or tail label, this will also be active.

For edges, the attributes [headURL](head-url.md), [tailURL](tail-url.md), [labelURL](label-url.md) and [edgeURL](edge-url.md) allow control of various parts of an edge.

if active areas of two edges overlap, it is unspecified which area dominates.

See also:

  * [edgehref](edgehref.md), [edgeURL](edge-url.md)
  * [headhref](headhref.md), [headURL](head-url.md)
  * [labelhref](labelhref.md), [labelURL](label-url.md)
  * [tailhref](tailhref.md), [tailURL](tail-url.md)
  * [href](href.md), [URL](url.md)



Example: Van Gogh Paintings with Links

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">graph {
  label="Vincent van Gogh Paintings"
  URL="https://en.wikipedia.org/wiki/Vincent_van_Gogh"

  subgraph cluster_self_portraits {
    URL="https://en.wikipedia.org/wiki/Portraits_of_Vincent_van_Gogh"
    label="Self-portraits"

    "Self-Portrait with Grey Felt Hat" [URL="https://www.vangoghmuseum.nl/en/collection/s0016V1962"]
    "Self-Portrait as a Painter" [URL="https://www.vangoghmuseum.nl/en/collection/s0022V1962"]
  }

  subgraph cluster_flowers {
    URL="https://en.wikipedia.org/wiki/Sunflowers_(Van_Gogh_series)"
    label="Flowers"

    "Sunflowers" [URL="https://www.nationalgallery.org.uk/paintings/vincent-van-gogh-sunflowers"]
    "Almond Blossom" [URL="https://www.vangoghmuseum.nl/en/collection/s0176V1962"]
  }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters

**Note:**  map,[postscript](/docs/outputs/ps/), [svg](/docs/outputs/svg/) only.
