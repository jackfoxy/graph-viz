# fontname

Font used for text

type: [string](../attribute-types/string.md), default: `"Times-Roman"`

This very much depends on the output format and, for non-bitmap output such as PostScript or SVG, the availability of the font when the graph is displayed or printed. As such, it is best to rely on font faces that are generally available, such as Times-Roman, Helvetica or Courier.

How font names are resolved also depends on the underlying library that handles font name resolution. If Graphviz was built using the [fontconfig library](https://www.freedesktop.org/wiki/Software/fontconfig/), fontconfig will be used to search for the font. See the commands `fc-list`, `fc-match` and the other fontconfig commands for how names are resolved and which fonts are available. Other systems may provide their own font package, such as Quartz for OS X.

Note that various font attributes, such as weight and slant, can be built into the font name. Unfortunately, the syntax varies depending on which font system is dominant. Thus, using `fontname="times bold italic"` will produce a bold, slanted Times font using Pango, the usual main font library. Alternatively, `fontname="times:italic"` will produce a slanted Times font from fontconfig, while `fontname="times-bold"` will resolve to a bold Times using Quartz. You will need to ascertain which package is used by your Graphviz system and refer to the relevant documentation.

If Graphviz is not built with a high-level font library, fontname will be considered the name of a Type 1 or True Type font file. If you specify `fontname=schlbk`, the tool will look for a file named `schlbk.ttf` or `schlbk.pfa` or `schlbk.pfb` in one of the directories specified by the [fontpath](fontpath.md) attribute. The lookup does support various aliases for the common fonts.

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph {
    label="Comic Sans MS"
    fontname="Comic Sans MS"
    subgraph cluster_a {
      label="Courier New"
      fontname="Courier New"
      Arial [fontname="Arial"];
      Arial -&gt; Arial [label="Impact" fontname="Impact"]
    }
}</code></pre>
</div>

_Valid on:_

  * Edges
  * Nodes
  * Graphs
  * Clusters
