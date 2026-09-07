# Vendored Ace runtime

Graph Viz vendors `ace-builds` 1.44.0 from the package's
`src-noconflict` build. The npm tarball integrity is:

```text
sha512-PFNMSYqFdEUkul2Ntud0HvA09AgY+F1ag0UYdpMH60wNI/qOA8cB8tlTgoALMEwIdUPJK2CjrIQ7OnbiSS/ugQ==
```

Upstream: <https://github.com/ajaxorg/ace-builds/tree/v1.44.0>

JavaScript sources use `.js` inside the desk and Clay ingests them with the
desk's `%js` mark. The non-minified build keeps every logical line below 32 KiB
for compatibility with Clay's JavaScript ingestion path.

The vendored runtime is limited to:

- `ace.js`: core editor runtime;
- `mode-dot.js`: Graphviz DOT highlighting and folding;
- `theme-github.js`: light application theme;
- `theme-monokai.js`: dark application theme;
- `ext-searchbox.js`: find and replace UI used by Ace defaults;
- `ext-settings-menu.js`: settings UI used by `Ctrl-,`, served using Ace's
  upstream `ext-settings_menu.js` URL;
- `ext-prompt.js`: command palette used by `F1`;
- `ext-beautify.js`: command used by `Ctrl-Shift-B`;
- `graph-viz-config.js`: same-origin module paths and worker policy;
- `license.txt`: upstream BSD-3-Clause license.

No worker is shipped because the DOT mode has no language worker and the
integration sets `useWorker` to false. No source maps, snippets, alternate
keybindings, or unused modes/themes/extensions are shipped.

`graph-viz-config.js` fixes Ace's base, mode, theme, and worker paths to the
same-origin `/apps/graph-viz/ace` route. The Gall agent imports each file with
an explicit `%js` or `%txt` Ford import and serves an explicit route, avoiding
Clay path inference and runtime network fallback. `tests/browser/real/
ace-assets.spec.js` verifies every route, content type, Clay-safe line length,
module load, pinned version, and the absence of cross-origin requests.

Trailing whitespace is stripped from the upstream JavaScript so desk diff
checks remain clean. The checked-in SHA-256 hashes are:

```text
d084df9052068e8b2d67ec692628005720370b43c26be7a81d86d4e92ce17297  ace.js
a8b0af9a37e6f9a558daf7eb0ef74e73204b94260e7e750736683d7cf80fab2d  license.txt
ac315a0131364fd59487de4dc569fdffee364f5d73d69331c1c47576c5b5d203  mode-dot.js
1d90a51f71dadc7b1ae9d30aa8653f30e663b0e6c496e096313b2c980ed6bd13  theme-github.js
1344ec08c6f1c15f92e12e82182ce33a43f3f2c98d874b377a94617f5090100f  theme-monokai.js
5a6edf6f236f0b633b600ecafefc7ed9374945c6165beb6f8ff4703e2cf32371  ext-beautify.js
62da2b859e0820645aac0151684de396373646b3087454e2782523658f176dd2  ext-prompt.js
468f2641eaa626d2fd556d622f76a66db61e87f6594d67fc45c26abfde014413  ext-searchbox.js
802b083bf50010f2fb48dfe5ca618e00e9f1b6c6b7c5641707fce9e7330dd422  ext-settings-menu.js
```
