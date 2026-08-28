# charset

Character encoding used when interpreting string input as a text label.

type: [string](../attribute-types/string.md), default: `"UTF-8"`

The default value is `"UTF-8"`. The other legal values are:

  * `"utf-8"` / `"utf8"` (default value)
  * `"iso-8859-1"` / `"ISO_8859-1"` / `"ISO8859-1"` / `"ISO-IR-100"` / `"Latin1"` / `"l1"` / `"latin-1"`
  * `"big-5"` / `"big5"`: the [Big-5 Chinese encoding](https://en.wikipedia.org/wiki/Big5)



The `charset` attribute is case-insensitive.

Note that if the character encoding used in the input does not match the `charset` value, the resulting output may be very strange.

It is not possible to use [HTML-like labels](../node-shapes.md#html) in combination with Big-5 encoding.

Example

<div style="position: relative;">
  <button type="button" aria-label="Copy DOT source" title="Copy DOT source" onclick="navigator.clipboard.writeText(this.parentElement.querySelector('code').textContent)" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 1; display: inline-flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; padding: 0; border: 1px solid currentColor; border-radius: 0.25rem; background: Canvas; color: CanvasText; cursor: pointer;">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect width="14" height="14" x="8" y="8" rx="2"></rect>
      <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
    </svg>
  </button>
  <pre><code class="language-dot">digraph G {
  charset="UTF-8"
  "🍔" -&gt; "💩"
}</code></pre>
</div>

_Valid on:_

  * Graphs
