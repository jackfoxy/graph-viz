::  Browser assets and JSON conversion for %graph-viz-web.
::
/-  gviz
|%
::
++  page
  ^-  @t
  %-  crip
  %-  en-xml:html
  ;html
    ;head
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;title: Graph Viz
      ;script
        ;+  ;/  (trip theme-bootstrap)
      ==
      ;style
        ;+  ;/  (trip css)
      ==
    ==
    ;body
      ;header.app-header
        ;div.brand
          ;h1: Graph Viz
        ==
        ;nav.toolbar(aria-label "Graph controls")
          ;select#template
            =title       "Insert starter template"
            =aria-label  "Starter template"
            ;option(value "", disabled "", hidden ""): Select template…
            ;option(value "flowchart"): Flowchart
            ;option(value "strict-digraph"): Strict digraph
            ;option(value "state-machine"): State machine
            ;option(value "dependencies"): Dependencies
            ;option(value "clusters"): Clusters
          ==
          ;button#render.primary
            =type   "button"
            =title  "Render (Ctrl+Enter)"
            ;span: Render
          ==
          ;div.zoom-controls(aria-label "Zoom controls")
            ;button#zoom-in.icon-button
              =type        "button"
              =disabled    ""
              =title       "Zoom in"
              =aria-label  "Zoom in"
              ;span.zoom-icon.zoom-in-icon(aria-hidden "true");
            ==
            ;button#zoom-out.icon-button
              =type        "button"
              =disabled    ""
              =title       "Zoom out"
              =aria-label  "Zoom out"
              ;span.zoom-icon.zoom-out-icon(aria-hidden "true");
            ==
          ==
          ;button#fit
            =type      "button"
            =disabled  ""
            =title     "Fit graph (Ctrl+0)"
            ;span: Fit
          ==
          ;button#reset-view
            =type      "button"
            =disabled  ""
            =title     "Reset view (Ctrl+1)"
            ;span: Reset
          ==
          ;label.theme-control
            ;span: Theme
            ;select#theme(aria-label "Theme")
              ;option(value "system"): System
              ;option(value "light"): Light
              ;option(value "dark"): Dark
            ==
          ==
          ;button#help(type "button", aria-expanded "false"): Help
        ==
      ==
      ;main#workbench.workbench
        ;aside#explorer-pane.explorer-pane
          =aria-label  "Graph Viz explorer"
          ;div.explorer-header
            ;div#explorer-tabs.explorer-tabs
              =role        "tablist"
              =aria-label  "Graph Viz explorer"
              ;div.explorer-tab-control.active(role "presentation")
                ;button#dot-files-tab.explorer-tab.active
                  =type                "button"
                  =role                "tab"
                  =data-explorer-view  "dot-files"
                  =aria-selected       "true"
                  =aria-controls       "dot-files-panel"
                  DOT Files
                ==
              ==
              ;div.explorer-tab-control(role "presentation")
                ;button#svg-files-tab.explorer-tab
                  =type                "button"
                  =role                "tab"
                  =data-explorer-view  "svg-files"
                  =aria-selected       "false"
                  =aria-controls       "svg-files-panel"
                  =tabindex            "-1"
                  SVG Files
                ==
              ==
            ==
          ==
          ;div#dot-files-panel.explorer-panel
            =role              "tabpanel"
            =aria-labelledby   "dot-files-tab"
            ;div#dot-files-tree.explorer-file-tree
              =role       "tree"
              =aria-label  "DOT files"
              =aria-busy   "true"
              ;p: Loading…
            ==
          ==
          ;div#svg-files-panel.explorer-panel(hidden "")
            =role              "tabpanel"
            =aria-labelledby   "svg-files-tab"
            ;div#svg-files-tree.explorer-file-tree
              =role       "tree"
              =aria-label  "SVG files"
              =aria-busy   "true"
              ;p: Loading…
            ==
          ==
        ==
        ;button#explorer-resizer.explorer-resizer
          =type              "button"
          =role              "separator"
          =aria-orientation  "vertical"
          =aria-label        "Resize explorer"
          ;span.sr-only: Resize explorer
        ==
        ;section#workspace.workspace
        ;section#editor-pane.pane.editor-pane
          ;div.pane-header
            ;h2: DOT source
            ;div.file-actions(aria-label "DOT file controls")
              ;button#browse-dot(type "button"): Browse
              ;button#load-dot(type "button"): Load DOT
              ;button#save-dot(type "button"): Save DOT
            ==
            ;label.preference.source-auto-render
              ;input#auto-render(type "checkbox", checked "");
              ;span: Auto-render
            ==
            ;span#source-status.status: Ready
          ==
          ;div.visual-tools(aria-label "Visual editing tools")
            ;label.control
              ;span: Node name
              ;input#new-node-name(type "text", placeholder "new_node");
            ==
            ;label.control
              ;span: Category
              ;select#new-node-category
                ;option(value "basic-shapes"): Basic shapes
                ;option(value "basic-symbols"): Basic symbols
                ;option(value "special-shapes"): Special shapes
                ;option(value "gene-expression-symbols"): Gene expression symbols
                ;option(value "dna-construction-symbols"): DNA construction symbols
                ;option(value "other-shapes"): Other shapes
              ==
            ==
            ;label.control
              ;span: Shape
              ;select#new-node-shape;
            ==
            ;button#add-node(type "button"): Add node
            ;button#draw-edge
              =type      "button"
              =disabled  ""
              =title     "Shift-click two nodes, then draw an edge"
              ;span: Draw edge
            ==
          ==
          ;label.sr-only(for "dot"): DOT source
          ;div.editor-body
            ;pre#line-numbers.line-numbers(aria-hidden "true");
            ;textarea#dot
              =spellcheck  "false"
              =aria-label  "DOT source"
              ;+  ;/  (trip 'digraph { a -> b }')
            ==
          ==
        ==
        ;div#splitter.splitter
          =role              "separator"
          =tabindex          "0"
          =aria-orientation  "vertical"
          =aria-label        "Resize editor and preview"
          ;span.sr-only: Resize editor and preview
        ==
        ;section#preview-pane.pane.preview-pane
          ;div.pane-header
            ;h2: Preview
            ;div.file-actions(aria-label "SVG file controls")
              ;button#browse-svg(type "button"): Browse
              ;button#load-svg(type "button"): Load SVG
              ;button#save-svg(type "button", disabled ""): Save SVG
              ;button#toggle-svg-source
                =type          "button"
                =disabled      ""
                =aria-pressed  "false"
                ;span: View source
              ==
            ==
            ;span#render-status.status: Empty
          ==
          ;pre#error.error(hidden "", role "alert");
          ;div#inspector.inspector(hidden "", aria-live "polite")
            ;div.selection-summary
              ;span#selection-kind.selection-kind;
              ;code#selection-id;
              ;button#delete-selection.danger-button(type "button")
                Delete
              ==
              ;button#clear-selection
                =type        "button"
                =aria-label  "Clear graph selection"
                ;span: Clear
              ==
            ==
            ;form#attribute-form.attribute-form
              ;label.control
                ;span: Label
                ;input#attr-label(type "text", maxlength "200");
              ==
              ;label#shape-control.control
                ;span: Shape
                ;select#attr-shape
                  ;option(value ""): Default
                  ;option(value "box"): Box
                  ;option(value "ellipse"): Ellipse
                  ;option(value "circle"): Circle
                  ;option(value "diamond"): Diamond
                  ;option(value "point"): Point
                ==
              ==
              ;label.control
                ;span: Color
                ;input#attr-color(type "text", placeholder "#2563eb");
              ==
              ;label#fill-control.control
                ;span: Fill color
                ;input#attr-fillcolor(type "text", placeholder "#dbeafe");
              ==
              ;label.control
                ;span: Line style
                ;select#attr-style
                  ;option(value ""): Default
                  ;option(value "solid"): Solid
                  ;option(value "dashed"): Dashed
                  ;option(value "dotted"): Dotted
                  ;option(value "bold"): Bold
                  ;option(value "invis"): Invisible
                ==
              ==
              ;div#edge-controls.edge-controls(hidden "")
                ;label.control
                  ;span: Pen width
                  ;input#attr-penwidth(type "number", min "0", step "any");
                ==
                ;label.control
                  ;span: Arrowhead
                  ;select#attr-arrowhead
                    ;option(value ""): Default
                    ;option(value "normal"): Normal
                    ;option(value "empty"): Empty
                    ;option(value "vee"): Vee
                    ;option(value "dot"): Dot
                    ;option(value "diamond"): Diamond
                    ;option(value "none"): None
                  ==
                ==
                ;label.control
                  ;span: Arrowtail
                  ;select#attr-arrowtail
                    ;option(value ""): Default
                    ;option(value "normal"): Normal
                    ;option(value "empty"): Empty
                    ;option(value "vee"): Vee
                    ;option(value "dot"): Dot
                    ;option(value "diamond"): Diamond
                    ;option(value "none"): None
                  ==
                ==
                ;label.control
                  ;span: Arrow size
                  ;input#attr-arrowsize(type "number", min "0", step "any");
                ==
                ;label.control
                  ;span: Direction
                  ;select#attr-dir
                    ;option(value ""): Default
                    ;option(value "forward"): Forward
                    ;option(value "back"): Back
                    ;option(value "both"): Both
                    ;option(value "none"): None
                  ==
                ==
                ;label.control
                  ;span: Minimum length
                  ;input#attr-minlen(type "number", min "0", step "1");
                ==
                ;label.control
                  ;span: Weight
                  ;input#attr-weight(type "number", min "0", step "1");
                ==
                ;label.control
                  ;span: Font name
                  ;input#attr-fontname(type "text", maxlength "80");
                ==
                ;label.control
                  ;span: Font size
                  ;input#attr-fontsize(type "number", min "0", step "any");
                ==
                ;label.control
                  ;span: Font color
                  ;input#attr-fontcolor(type "text", placeholder "#18181b");
                ==
              ==
              ;div.attribute-actions
                ;label.preference
                  ;input#attr-change-all(type "checkbox");
                  ;span: Change all
                ==
                ;label.preference
                  ;input#attr-use-default(type "checkbox");
                  ;span: Use as default
                ==
                ;button#apply-attributes(type "submit"): Apply
              ==
            ==
          ==
          ;div#preview-shell.preview-shell(data-state "empty")
            ;div.preview-actions(aria-label "Preview controls")
              ;button#copy-svg.preview-action
                =type        "button"
                =disabled    ""
                =title       "Copy SVG source"
                =aria-label  "Copy SVG source to clipboard"
                ;span.copy-icon(aria-hidden "true");
              ==
              ;button#fullscreen-svg.preview-action
                =type          "button"
                =disabled      ""
                =hidden        ""
                =title         "Expand SVG to fullscreen"
                =aria-label    "Expand SVG to fullscreen"
                =aria-pressed  "false"
                ;span.fullscreen-icon(aria-hidden "true");
              ==
              ;button#fullscreen-zoom-out.preview-action.fullscreen-only
                =type        "button"
                =disabled    ""
                =title       "Zoom out"
                =aria-label  "Zoom out"
                ;span.zoom-icon.zoom-out-icon(aria-hidden "true");
              ==
              ;button#fullscreen-zoom-in.preview-action.fullscreen-only
                =type        "button"
                =disabled    ""
                =title       "Zoom in"
                =aria-label  "Zoom in"
                ;span.zoom-icon.zoom-in-icon(aria-hidden "true");
              ==
            ==
            ;div#empty-state.state-panel
              ;p.state-title: Nothing rendered yet
              ;p: Select Render to preview the current DOT source.
            ==
            ;div#loading-state.state-panel
              ;span.spinner(aria-hidden "true");
              ;p.state-title: Rendering graph
            ==
            ;div#disconnected-state.state-panel
              ;p.state-title: Renderer unavailable
              ;p: Check the ship connection, then try again.
            ==
            ;div#preview.preview(aria-live "polite", tabindex "0");
            ;pre#svg-source(hidden "", tabindex "0", aria-label "SVG source");
          ==
        ==
        ==
      ==
      ;aside#help-panel.explorer-panel.help-explorer-panel
        =hidden            ""
        =role              "tabpanel"
        =aria-labelledby   "help-tab"
        =aria-label        "Help"
        ;div#editor-help-card.help-card.editor-help-card
          ;div.pane-header
            ;h2: Editor help
            ;button#close-help(type "button", aria-label "Close help"): Close
          ==
          ;div#fallback-help-content
            ;p
              ;a
                =href    "https://www.graphviz.org/doc/info/lang.html"
                =target  "_blank"
                =rel     "noopener noreferrer"
                DOT Language Reference
              ==
            ==
            ;p: Write DOT on the left and inspect the SVG on the right.
            ;p: Drag the divider to resize the panes on larger screens.
            ;h3: Keyboard shortcuts
            ;ul.shortcut-list
              ;li: Ctrl/Cmd + Enter: render now
              ;li: Ctrl/Cmd + S: save DOT to Clay
              ;li: Ctrl/Cmd + Shift + S: save SVG to Clay
              ;li: Ctrl/Cmd + 0: fit graph
              ;li: Ctrl/Cmd + 1: reset graph view
              ;li: Tab / Shift + Tab: indent / unindent
              ;li: Shift-click: select two nodes for an edge
              ;li: Delete: remove the selected node or edge
            ==
            ;h3: LLM skill files
            ;ul
              ;li
                ;a
                  =href    "https://github.com/jackfoxy/foxy-skills/tree/master/gviz-dot-syntax"
                  =target  "_blank"
                  =rel     "noopener noreferrer"
                  DOT Syntax
                ==
              ==
              ;li
                ;a
                  =href    "https://github.com/jackfoxy/foxy-skills/tree/master/gviz-gall-api"
                  =target  "_blank"
                  =rel     "noopener noreferrer"
                  Gall API
                ==
              ==
              ;li
                ;a
                  =href    "https://github.com/jackfoxy/foxy-skills/tree/master/gviz-patterns"
                  =target  "_blank"
                  =rel     "noopener noreferrer"
                  Common Patterns
                ==
              ==
            ==
          ==
          ;div#docs-help-content.docs-help-content(hidden "")
            ;nav#docs-help-nav.docs-help-nav
              =aria-label  "Graph Viz documentation"
              ;a.docs-help-link
                =href           "/docs/d/graph-viz/usr/users-guide"
                =data-doc-path  "usr/users-guide"
                Users Guide
              ==
              ;a.docs-help-link
                =href           "/docs/d/graph-viz/reference"
                =data-doc-path  "reference"
                Reference
              ==
              ;a.docs-help-link
                =href           "/docs/d/graph-viz/graph-noun"
                =data-doc-path  "graph-noun"
                Positioned graph
              ==
              ;a.docs-help-link
                =href           "/docs/d/graph-viz/release-notes"
                =data-doc-path  "release-notes"
                Release notes
              ==
            ==
          ==
        ==
      ==
      ;div#file-context-menu.file-context-menu(hidden "", role "menu")
        ;button#file-context-open(type "button", role "menuitem"): Open
        ;button#file-context-delete.danger-button
          =type  "button"
          =role  "menuitem"
          Delete
        ==
      ==
      ;aside#clay-error-modal.help-panel
        =hidden      ""
        =role        "dialog"
        =aria-modal  "true"
        =aria-labelledby  "clay-error-title"
        ;div.help-card
          ;div.pane-header
            ;h2#clay-error-title: Clay error
            ;button#close-clay-error
              =type        "button"
              =aria-label  "Close Clay error"
              ;span: Close
            ==
          ==
          ;pre#clay-error-message.clay-error-message;
        ==
      ==
      ;script(src "/apps/graph-viz/app.js");
    ==
  ==
::
++  theme-bootstrap
  ^-  @t
  '''
  (() => {
    const key = 'graph-viz.session.v1';
    const themes = ['system', 'light', 'dark'];
    let selected = 'system';
    try {
      const saved = JSON.parse(localStorage.getItem(key));
      const candidate = saved?.preferences?.theme;
      if (saved?.version === 1 && themes.includes(candidate)) {
        selected = candidate;
      }
    } catch (_) {
      // Storage failures must not block first paint.
    }
    const systemDark = matchMedia(
      '(prefers-color-scheme: dark)'
    ).matches;
    const effective = selected === 'system'
      ? (systemDark ? 'dark' : 'light')
      : selected;
    const root = document.documentElement;
    root.dataset.theme = selected;
    root.dataset.effectiveTheme = effective;
    root.style.colorScheme = effective;
  })();
  '''
::
++  css
  ^-  @t
  '''
  :root {
    color-scheme: light;
    --background: #f4f4f5;
    --surface: #ffffff;
    --surface-alt: #fafafa;
    --border: #d4d4d8;
    --ink: #18181b;
    --muted: #71717a;
    --accent: #2563eb;
    --accent-text: #ffffff;
    --focus: #93c5fd;
    --danger: #b91c1c;
    --danger-background: #fef2f2;
    --danger-border: #fecaca;
    --editor-error: #fee2e2;
    --preview-background: #ffffff;
    --preview-grid: #d4d4d8;
    --floating-control: rgb(255 255 255 / 0.9);
    --selection-hover: #2563eb;
    --selection-active: #f59e0b;
    --spinner-track: #bfdbfe;
    --state-ink: #52525b;
    --state-title: #27272a;
    --inspector-background: #fffbeb;
    --inspector-border: #fde68a;
    --inspector-ink: #78350f;
    --editor-width: 44%;
  }

  :root[data-effective-theme='dark'] {
    color-scheme: dark;
    --background: #11110f;
    --surface: #191917;
    --surface-alt: #22221f;
    --border: #3b3b35;
    --ink: #f2f2ec;
    --muted: #a7a79e;
    --accent: #8b5cf6;
    --accent-text: #ffffff;
    --focus: #60a5fa;
    --danger: #f87171;
    --danger-background: #35191d;
    --danger-border: #7f1d1d;
    --editor-error: #3f1d24;
    --preview-background: #11110f;
    --preview-grid: #3b3b35;
    --floating-control: rgb(25 25 23 / 0.92);
    --selection-hover: #60a5fa;
    --selection-active: #fbbf24;
    --spinner-track: #4c1d95;
    --state-ink: #a7a79e;
    --state-title: #f2f2ec;
    --inspector-background: #33270e;
    --inspector-border: #854d0e;
    --inspector-ink: #fde68a;
  }

  * { box-sizing: border-box; }

  html, body { height: 100%; }

  body {
    background: var(--background);
    color: var(--ink);
    display: grid;
    font: 16px/1.4 system-ui, sans-serif;
    grid-template-rows: auto minmax(0, 1fr);
    margin: 0;
  }

  button, select, input, .preference {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 0.4rem;
    color: inherit;
    font: inherit;
    padding: 0.5rem 0.75rem;
  }

  button, select { cursor: pointer; }
  button:hover:not(:disabled) { border-color: var(--accent); }
  button:focus-visible, select:focus-visible, input:focus-visible,
  textarea:focus-visible { outline: 3px solid var(--focus); }
  button:disabled { cursor: not-allowed; opacity: 0.45; }

  .primary {
    background: var(--accent);
    border-color: var(--accent);
    color: var(--accent-text);
  }

  .app-header {
    align-items: center;
    background: var(--surface);
    border-bottom: 1px solid var(--border);
    display: flex;
    gap: 1rem;
    justify-content: space-between;
    padding: 0.75rem 1rem;
  }

  .brand h1 { font-size: 1.25rem; line-height: 1.1; margin: 0; }

  .eyebrow {
    color: var(--muted);
    display: block;
    font-size: 0.7rem;
    letter-spacing: 0.08em;
    text-transform: uppercase;
  }

  .toolbar { display: flex; flex-wrap: wrap; gap: 0.5rem; }

  .theme-control {
    align-items: center;
    color: var(--muted);
    display: inline-flex;
    font-size: 0.75rem;
    gap: 0.4rem;
  }

  .theme-control select { color: var(--ink); }

  .zoom-controls { display: inline-flex; gap: 0.25rem; }

  .icon-button {
    align-items: center;
    display: inline-flex;
    height: 2.65rem;
    justify-content: center;
    padding: 0;
    width: 2.65rem;
  }

  .zoom-icon {
    border: 2px solid currentcolor;
    border-radius: 50%;
    display: block;
    height: 0.9rem;
    position: relative;
    width: 0.9rem;
  }

  .zoom-icon::after {
    background: currentcolor;
    content: '';
    height: 2px;
    left: 0.65rem;
    position: absolute;
    top: 0.72rem;
    transform: rotate(45deg);
    transform-origin: left center;
    width: 0.55rem;
  }

  .zoom-icon::before {
    background:
      linear-gradient(currentcolor, currentcolor) center / 0.35rem 2px
        no-repeat;
    content: '';
    inset: 0.1rem;
    position: absolute;
  }

  .zoom-in-icon::before {
    background:
      linear-gradient(currentcolor, currentcolor) center / 0.35rem 2px
        no-repeat,
      linear-gradient(currentcolor, currentcolor) center / 2px 0.35rem
        no-repeat;
  }

  .visual-tools {
    align-items: end;
    border-bottom: 1px solid var(--border);
    display: grid;
    gap: 0.5rem;
    grid-template-columns:
      minmax(8rem, 1fr) minmax(8rem, auto) minmax(8rem, auto) auto auto;
    padding: 0.5rem 0.75rem;
  }

  .control {
    display: grid;
    font-size: 0.7rem;
    gap: 0.2rem;
  }

  .control input, .control select {
    font-size: 0.85rem;
    min-width: 0;
    padding: 0.35rem 0.5rem;
  }

  #shape-control[hidden], #fill-control[hidden],
  #edge-controls[hidden] {
    display: none;
  }

  .preference {
    align-items: center;
    display: inline-flex;
    gap: 0.4rem;
  }

  .preference input { accent-color: var(--accent); }
  .source-auto-render { margin-left: 0.5rem; white-space: nowrap; }

  .workbench {
    display: grid;
    grid-template-columns: var(--explorer-width, 18rem) 0.6rem
      minmax(0, 1fr);
    min-height: 0;
    overflow: hidden;
  }

  .explorer-pane {
    background: var(--surface);
    display: grid;
    grid-template-rows: auto minmax(0, 1fr);
    min-height: 0;
    min-width: 0;
    overflow: hidden;
  }

  .explorer-header { border-bottom: 1px solid var(--border); }

  .explorer-tabs {
    display: flex;
    min-width: 0;
    overflow-x: auto;
    scrollbar-width: thin;
  }

  .explorer-tab-control, .docs-tab-control {
    align-items: stretch;
    border-right: 1px solid var(--border);
    display: inline-flex;
    flex: 0 0 auto;
  }

  .explorer-tab, .docs-tab, .docs-tab-close {
    background: transparent;
    border: 0;
    border-radius: 0;
    color: var(--muted);
    font-size: 0.75rem;
    min-height: 2.5rem;
  }

  .explorer-tab, .docs-tab {
    max-width: 12rem;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .explorer-tab-control.active, .docs-tab-control.active {
    box-shadow: inset 0 -2px var(--accent);
  }

  .explorer-tab[aria-selected='true'],
  .docs-tab[aria-selected='true'] {
    color: var(--ink);
    font-weight: 650;
  }

  .docs-tab-close {
    font-size: 1rem;
    padding: 0.25rem 0.45rem;
  }

  .explorer-panel {
    grid-column: 1;
    grid-row: 2;
    min-height: 0;
    min-width: 0;
    overflow: hidden;
  }

  .explorer-panel[hidden] { display: none; }

  .explorer-file-tree {
    height: 100%;
    min-height: 0;
    overflow: auto;
    padding: 0.75rem;
  }

  .docs-explorer-frame {
    background: var(--surface);
    border: 0;
    height: 100%;
    width: 100%;
  }

  .help-explorer-panel {
    overflow: auto;
    padding: 0.75rem;
  }

  .help-explorer-panel .help-card {
    border: 0;
    border-radius: 0;
    box-shadow: none;
    max-width: none;
    min-height: 100%;
  }

  .explorer-resizer {
    background: var(--border);
    border: 0;
    border-radius: 0;
    cursor: col-resize;
    padding: 0;
    touch-action: none;
  }

  .explorer-resizer:hover, .explorer-resizer:focus {
    background: var(--accent);
  }

  .workspace {
    display: grid;
    grid-template-columns: minmax(18rem, var(--editor-width)) 0.6rem
      minmax(20rem, 1fr);
    min-height: 0;
    overflow: hidden;
  }

  .pane {
    background: var(--surface);
    display: flex;
    min-height: 0;
    min-width: 0;
  }

  .editor-pane, .preview-pane { flex-direction: column; }

  .pane-header {
    align-items: center;
    border-bottom: 1px solid var(--border);
    display: flex;
    justify-content: space-between;
    min-height: 2.75rem;
    padding: 0.5rem 0.75rem;
  }

  .pane-header h2 { font-size: 0.9rem; margin: 0; }
  .file-actions { display: flex; gap: 0.5rem; margin-left: auto; }
  .status {
    color: var(--muted);
    font-size: 0.75rem;
    margin-left: 0.5rem;
  }

  .editor-body {
    display: flex;
    flex: 1;
    min-height: 0;
    overflow: hidden;
  }

  .line-numbers {
    background: var(--surface-alt);
    border-right: 1px solid var(--border);
    color: var(--muted);
    flex: 0 0 auto;
    font: 0.9rem/1.55 ui-monospace, monospace;
    margin: 0;
    min-width: 3.5rem;
    overflow: hidden;
    padding: 1rem 0.65rem;
    text-align: right;
    user-select: none;
  }

  .line-numbers span { display: block; }

  .line-numbers .error-line {
    background: var(--editor-error);
    color: var(--danger);
    font-weight: 700;
  }

  #dot {
    background: var(--surface);
    border: 0;
    color: inherit;
    flex: 1;
    font: 0.9rem/1.55 ui-monospace, monospace;
    min-height: 12rem;
    outline: none;
    padding: 1rem;
    resize: none;
    tab-size: 2;
    width: 100%;
  }

  #dot:focus { box-shadow: inset 0 0 0 2px var(--accent); }

  #dot.has-error-line {
    background-image: linear-gradient(
      var(--danger-background), var(--danger-background)
    );
    background-position: 0 var(--error-line-top);
    background-repeat: no-repeat;
    background-size: 100% 1.4rem;
  }

  .splitter {
    background: var(--border);
    cursor: col-resize;
    touch-action: none;
  }

  .splitter:hover, .splitter:focus { background: var(--accent); }

  .preview-shell {
    background-color: var(--preview-background);
    background-image: radial-gradient(
      var(--preview-grid) 0.8px, transparent 0.8px
    );
    background-size: 18px 18px;
    flex: 1;
    min-height: 0;
    overflow: hidden;
    position: relative;
  }

  .preview-actions {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    position: absolute;
    right: 0.75rem;
    top: 0.75rem;
    z-index: 3;
  }

  .preview-action {
    align-items: center;
    background: var(--floating-control);
    display: inline-flex;
    height: 2rem;
    justify-content: center;
    padding: 0;
    width: 2rem;
  }

  .preview-action[hidden] { display: none; }
  .preview-action.fullscreen-only { display: none; }

  .preview-shell.is-fullscreen .preview-action.fullscreen-only {
    display: inline-flex;
  }

  .copy-icon {
    height: 0.9rem;
    position: relative;
    width: 0.9rem;
  }

  .copy-icon::before, .copy-icon::after {
    border: 1.5px solid currentcolor;
    border-radius: 2px;
    content: '';
    height: 0.58rem;
    position: absolute;
    width: 0.5rem;
  }

  .copy-icon::before { left: 0; top: 0; }

  .copy-icon::after {
    background: var(--floating-control);
    bottom: 0;
    right: 0;
  }

  .fullscreen-icon {
    height: 0.85rem;
    position: relative;
    width: 0.85rem;
  }

  .fullscreen-icon::before, .fullscreen-icon::after {
    content: '';
    height: 0.32rem;
    position: absolute;
    width: 0.32rem;
  }

  .fullscreen-icon::before {
    border-left: 1.5px solid currentcolor;
    border-top: 1.5px solid currentcolor;
    left: 0;
    top: 0;
  }

  .fullscreen-icon::after {
    border-bottom: 1.5px solid currentcolor;
    border-right: 1.5px solid currentcolor;
    bottom: 0;
    right: 0;
  }

  .preview-shell:fullscreen .fullscreen-icon::before {
    border: 0;
    border-bottom: 1.5px solid currentcolor;
    border-right: 1.5px solid currentcolor;
  }

  .preview-shell:fullscreen .fullscreen-icon::after {
    border: 0;
    border-left: 1.5px solid currentcolor;
    border-top: 1.5px solid currentcolor;
  }

  .preview-shell:fullscreen {
    height: 100vh;
    width: 100vw;
  }

  .preview {
    cursor: grab;
    inset: 0;
    overflow: hidden;
    position: absolute;
    touch-action: none;
  }

  .preview[hidden] { display: none; }
  .preview.is-panning { cursor: grabbing; }

  .preview svg {
    display: block;
    filter: none;
    max-width: none;
    position: absolute;
    transform-origin: 0 0;
    user-select: none;
  }

  :root[data-effective-theme='dark'] .preview svg {
    filter: invert(1) hue-rotate(180deg);
  }

  .preview .node, .preview .edge {
    cursor: pointer;
    transition: filter 120ms ease;
  }

  .preview .node:hover, .preview .edge:hover,
  .preview .node:focus-visible, .preview .edge:focus-visible {
    filter: drop-shadow(0 0 3px var(--selection-hover));
  }

  .preview .node.is-selected, .preview .edge.is-selected {
    filter: drop-shadow(0 0 2px var(--selection-active))
      drop-shadow(0 0 5px var(--selection-active));
  }

  #svg-source {
    background: var(--surface-alt);
    color: var(--ink);
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 0.8rem;
    inset: 0;
    line-height: 1.45;
    margin: 0;
    overflow: auto;
    padding: 3.5rem 1rem 1rem;
    position: absolute;
    tab-size: 2;
    white-space: pre;
  }

  #svg-source[hidden] { display: none; }

  .state-panel {
    align-content: center;
    color: var(--state-ink);
    display: none;
    inset: 0;
    justify-items: center;
    padding: 2rem;
    position: absolute;
    text-align: center;
    z-index: 1;
  }

  .state-panel p { margin: 0.25rem; }
  .state-title { color: var(--state-title); font-weight: 650; }

  [data-state='empty'] #empty-state,
  [data-state='loading'] #loading-state,
  [data-state='disconnected'] #disconnected-state { display: grid; }

  [data-state='empty'] .preview,
  [data-state='loading'] .preview,
  [data-state='disconnected'] .preview,
  [data-state='empty'] #svg-source,
  [data-state='loading'] #svg-source,
  [data-state='disconnected'] #svg-source { visibility: hidden; }

  .spinner {
    animation: spin 0.8s linear infinite;
    border: 3px solid var(--spinner-track);
    border-radius: 50%;
    border-top-color: var(--accent);
    height: 2rem;
    width: 2rem;
  }

  @keyframes spin { to { transform: rotate(360deg); } }

  .error {
    background: var(--danger-background);
    border-bottom: 1px solid var(--danger-border);
    color: var(--danger);
    margin: 0;
    padding: 0.75rem;
    white-space: pre-wrap;
  }

  .inspector {
    background: var(--inspector-background);
    border-bottom: 1px solid var(--inspector-border);
    color: var(--inspector-ink);
    display: grid;
    gap: 0.6rem;
    min-height: 2.5rem;
    padding: 0.35rem 0.75rem;
  }

  .inspector[hidden] { display: none; }
  .inspector code { overflow-wrap: anywhere; }
  .selection-kind { font-size: 0.75rem; font-weight: 700; }

  .selection-summary {
    align-items: center;
    display: flex;
    gap: 0.5rem;
  }

  .selection-summary code { flex: 1; }

  .attribute-form {
    align-items: end;
    display: grid;
    gap: 0.5rem;
    grid-template-columns: repeat(5, minmax(5rem, 1fr)) auto;
  }

  .edge-controls {
    display: grid;
    gap: 0.5rem;
    grid-column: 1 / -1;
    grid-template-columns: repeat(auto-fit, minmax(6rem, 1fr));
  }

  .attribute-actions {
    align-items: center;
    display: flex;
    gap: 0.75rem;
  }

  .danger-button { color: var(--danger); }

  .help-panel {
    background: rgb(0 0 0 / 0.4);
    display: grid;
    inset: 0;
    padding: 1rem;
    place-items: center;
    position: fixed;
    z-index: 10;
  }

  .help-panel[hidden] { display: none; }

  .file-context-menu {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 0.4rem;
    box-shadow: 0 0.7rem 2rem rgb(0 0 0 / 0.2);
    display: grid;
    min-width: 9rem;
    padding: 0.3rem;
    position: fixed;
    z-index: 60;
  }

  .file-context-menu[hidden] { display: none; }

  .file-context-menu button {
    background: transparent;
    border: 0;
    text-align: left;
  }

  .help-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 0.75rem;
    box-shadow: 0 1rem 3rem rgb(0 0 0 / 0.2);
    max-width: 32rem;
    padding: 0 1rem 1rem;
    width: 100%;
  }

  #fallback-help-content[hidden], .docs-help-content[hidden] {
    display: none;
  }

  .docs-help-content {
    padding-top: 0.75rem;
  }

  .docs-help-nav {
    align-content: start;
    display: grid;
    gap: 0.25rem;
  }

  .docs-help-link {
    border-radius: 0.35rem;
    color: var(--accent);
    padding: 0.5rem;
    text-decoration: none;
  }

  .docs-help-link:hover, .docs-help-link[aria-current="page"] {
    background: var(--background);
  }

  .docs-help-link[aria-current="page"] { font-weight: 600; }

  .shortcut-list { line-height: 1.8; padding-left: 1.5rem; }

  .file-tree-list {
    list-style: none;
    margin: 0;
    padding-left: 1.25rem;
  }

  .explorer-file-tree > .file-tree-list { padding-left: 0; }

  .file-tree-directory {
    color: var(--muted);
    padding: 0.2rem 0;
  }

  .explorer-file-row {
    align-items: stretch;
    display: flex;
    min-width: 0;
  }

  .file-tree-file {
    background: transparent;
    border: 0;
    color: var(--accent);
    flex: 1;
    min-width: 0;
    overflow: hidden;
    padding: 0.3rem 0.5rem;
    text-align: left;
    text-overflow: ellipsis;
    white-space: nowrap;
    width: auto;
  }

  .file-tree-file:hover:not(:disabled) { background: var(--background); }

  .file-tree-actions {
    background: transparent;
    border: 0;
    color: var(--muted);
    flex: 0 0 auto;
    padding: 0.2rem 0.45rem;
  }

  .clay-error-message {
    color: var(--danger);
    overflow-wrap: anywhere;
    white-space: pre-wrap;
  }

  .sr-only {
    height: 1px;
    margin: -1px;
    overflow: hidden;
    position: absolute;
    width: 1px;
  }

  @media (max-width: 760px) {
    body { height: auto; min-height: 100%; }

    .app-header { align-items: stretch; flex-direction: column; }
    .toolbar { display: grid; grid-template-columns: repeat(3, 1fr); }

    .visual-tools, .attribute-form {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .workbench {
      grid-template-columns: minmax(0, 1fr);
      grid-template-rows: minmax(12rem, 35vh) minmax(0, 1fr);
      overflow: visible;
    }

    .explorer-resizer { display: none; }

    .workspace {
      grid-template-columns: minmax(0, 1fr);
      grid-template-rows: minmax(18rem, 45vh) minmax(20rem, 55vh);
      overflow: visible;
    }

    .splitter { display: none; }
    .preview-pane { border-top: 1px solid var(--border); }

    .docs-help-nav {
      display: flex;
      overflow-x: auto;
    }

    .docs-help-link { flex: 0 0 auto; }
  }
  '''
::
++  javascript
  ^-  @t
  '''
  const templates = {
    flowchart: [
      'digraph flow {',
      '  rankdir=LR',
      '  node [shape=box]',
      '  Start -> Plan -> Build -> Done',
      '}'
    ].join('\n'),
    'strict-digraph': [
      'strict digraph unique_edges {',
      '  rankdir=LR',
      '  node [shape=box]',
      '  Start -> Validate [label=first]',
      '  Start -> Validate [label="last wins", color=blue]',
      '  Validate -> Done',
      '}'
    ].join('\n'),
    'state-machine': [
      'digraph states {',
      '  rankdir=LR',
      '  node [shape=circle]',
      '  start [shape=doublecircle]',
      '  start -> idle',
      '  idle -> running [label=start]',
      '  running -> idle [label=stop]',
      '  running -> done [label=finish]',
      '  done [shape=doublecircle]',
      '}'
    ].join('\n'),
    dependencies: [
      'digraph dependencies {',
      '  rankdir=LR',
      '  node [shape=box]',
      '  app -> {ui core}',
      '  ui -> core',
      '  core -> {util log}',
      '  log -> util',
      '}'
    ].join('\n'),
    clusters: [
      'digraph architecture {',
      '  node [shape=box]',
      '  subgraph cluster_web {',
      '    label="Web"',
      '    browser -> gateway',
      '  }',
      '  subgraph cluster_data {',
      '    label="Data"',
      '    api -> database',
      '  }',
      '  gateway -> api',
      '}'
    ].join('\n')
  };
  const starter = templates.flowchart;
  const dot = document.querySelector('#dot');
  const lineNumbers = document.querySelector('#line-numbers');
  const template = document.querySelector('#template');
  const button = document.querySelector('#render');
  const error = document.querySelector('#error');
  const inspector = document.querySelector('#inspector');
  const selectionKind = document.querySelector('#selection-kind');
  const selectionId = document.querySelector('#selection-id');
  const clearSelection = document.querySelector('#clear-selection');
  const deleteSelection = document.querySelector('#delete-selection');
  const attributeForm = document.querySelector('#attribute-form');
  const shapeControl = document.querySelector('#shape-control');
  const fillControl = document.querySelector('#fill-control');
  const edgeControls = document.querySelector('#edge-controls');
  const attrLabel = document.querySelector('#attr-label');
  const attrShape = document.querySelector('#attr-shape');
  const attrColor = document.querySelector('#attr-color');
  const attrFillcolor = document.querySelector('#attr-fillcolor');
  const attrStyle = document.querySelector('#attr-style');
  const attrPenwidth = document.querySelector('#attr-penwidth');
  const attrArrowhead = document.querySelector('#attr-arrowhead');
  const attrArrowtail = document.querySelector('#attr-arrowtail');
  const attrArrowsize = document.querySelector('#attr-arrowsize');
  const attrDir = document.querySelector('#attr-dir');
  const attrMinlen = document.querySelector('#attr-minlen');
  const attrWeight = document.querySelector('#attr-weight');
  const attrFontname = document.querySelector('#attr-fontname');
  const attrFontsize = document.querySelector('#attr-fontsize');
  const attrFontcolor = document.querySelector('#attr-fontcolor');
  const attrChangeAll = document.querySelector('#attr-change-all');
  const attrUseDefault = document.querySelector('#attr-use-default');
  const newNodeName = document.querySelector('#new-node-name');
  const newNodeCategory = document.querySelector('#new-node-category');
  const newNodeShape = document.querySelector('#new-node-shape');
  const addNode = document.querySelector('#add-node');
  const drawEdge = document.querySelector('#draw-edge');
  const preview = document.querySelector('#preview');
  const svgSource = document.querySelector('#svg-source');
  const copySvg = document.querySelector('#copy-svg');
  const fullscreenSvg = document.querySelector('#fullscreen-svg');
  const previewShell = document.querySelector('#preview-shell');
  const renderStatus = document.querySelector('#render-status');
  const sourceStatus = document.querySelector('#source-status');
  const zoomOut = document.querySelector('#zoom-out');
  const zoomIn = document.querySelector('#zoom-in');
  const fullscreenZoomOut = document.querySelector('#fullscreen-zoom-out');
  const fullscreenZoomIn = document.querySelector('#fullscreen-zoom-in');
  const resetView = document.querySelector('#reset-view');
  const browseDot = document.querySelector('#browse-dot');
  const loadDot = document.querySelector('#load-dot');
  const saveDot = document.querySelector('#save-dot');
  const browseSvg = document.querySelector('#browse-svg');
  const loadSvg = document.querySelector('#load-svg');
  const saveSvg = document.querySelector('#save-svg');
  const toggleSvgSource = document.querySelector('#toggle-svg-source');
  const fit = document.querySelector('#fit');
  const autoRender = document.querySelector('#auto-render');
  const theme = document.querySelector('#theme');
  const help = document.querySelector('#help');
  const helpPanel = document.querySelector('#help-panel');
  const closeHelp = document.querySelector('#close-help');
  const fallbackHelpContent = document.querySelector(
    '#fallback-help-content'
  );
  const docsHelpContent = document.querySelector('#docs-help-content');
  const docsHelpLinks = Array.from(
    document.querySelectorAll('.docs-help-link')
  );
  const workbench = document.querySelector('#workbench');
  const explorerPane = document.querySelector('#explorer-pane');
  const explorerTabs = document.querySelector('#explorer-tabs');
  const explorerResizer = document.querySelector('#explorer-resizer');
  const dotFilesTab = document.querySelector('#dot-files-tab');
  const svgFilesTab = document.querySelector('#svg-files-tab');
  const dotFilesPanel = document.querySelector('#dot-files-panel');
  const svgFilesPanel = document.querySelector('#svg-files-panel');
  const dotFilesTree = document.querySelector('#dot-files-tree');
  const svgFilesTree = document.querySelector('#svg-files-tree');
  const fileContextMenu = document.querySelector('#file-context-menu');
  const fileContextOpen = document.querySelector('#file-context-open');
  const fileContextDelete = document.querySelector('#file-context-delete');
  const clayErrorModal = document.querySelector('#clay-error-modal');
  const clayErrorMessage = document.querySelector('#clay-error-message');
  const closeClayError = document.querySelector('#close-clay-error');
  const workspace = document.querySelector('#workspace');
  const splitter = document.querySelector('#splitter');
  const renderDelay = 350;
  const saveDelay = 150;
  const minExplorerWidth = 180;
  const explorerDividerWidth = 10;
  const minScale = 0.05;
  const maxScale = 32;
  const maxSourceBytes = 256 * 1024;
  const maxSharedSourceBytes = 12 * 1024;
  const maxShareParamChars = 16 * 1024;
  const storageKey = 'graph-viz.session.v1';
  const themes = ['system', 'light', 'dark'];
  const themeMedia = matchMedia('(prefers-color-scheme: dark)');
  const docsRoot = '/docs/d/graph-viz/';
  const helpExplorerView = 'help';
  const permanentExplorerViews = ['dot-files', 'svg-files'];
  let docsAvailable = null;
  let docsCheckPending = false;
  let docsTabs = [];
  let nextDocs = 1;
  let explorerView = 'dot-files';
  let contextFileKind;
  let contextFilePath;
  let contextFileSource;
  const nodeShapeCategories = {
    'basic-shapes': [
      'ellipse', 'circle', 'egg', 'triangle', 'box', 'square',
      'plaintext', 'plain', 'diamond', 'trapezium', 'parallelogram',
      'house', 'pentagon', 'hexagon', 'septagon', 'octagon'
    ],
    'basic-symbols': [
      'note', 'tab', 'folder', 'box3d', 'component', 'underline',
      'cylinder'
    ],
    'special-shapes': [
      'doublecircle', 'invtriangle', 'invtrapezium', 'invhouse',
      'doubleoctagon', 'tripleoctagon', 'Mdiamond', 'Msquare',
      'Mcircle', 'star'
    ],
    'gene-expression-symbols': [
      'promoter', 'cds', 'terminator', 'utr', 'insulator', 'ribosite',
      'rnastab', 'proteasesite', 'proteinstab'
    ],
    'dna-construction-symbols': [
      'primersite', 'restrictionsite', 'fivepoverhang',
      'threepoverhang', 'noverhang', 'assembly', 'signature',
      'rpromoter', 'larrow', 'rarrow', 'lpromoter'
    ],
    'other-shapes': [
      'polygon', 'oval', 'point', 'none', 'rect', 'rectangle'
    ]
  };
  const nodeShapes = [
    '',
    ...new Set(Object.values(nodeShapeCategories).flat())
  ];
  const arrowShapes = [
    '', 'normal', 'empty', 'vee', 'dot', 'diamond', 'none'
  ];
  const edgeDirections = ['', 'forward', 'back', 'both', 'none'];
  let requestUid = 0;
  let latestRequestUid = 0;
  let renderTimer;
  let saveTimer;
  let currentSvg;
  let graphSize = {width: 1, height: 1};
  let view = {scale: 1, x: 0, y: 0};
  let panPoint;
  let lastSvgSource = '';
  let showingSvgSource = false;
  let pendingView;
  let selectedItems = [];
  let inheritNewNodeShape = false;

  function createTextareaEditorAdapter(textarea, gutter) {
    const changeListeners = new Set();
    let errorLine = 0;

    function getSource() {
      return textarea.value;
    }

    function clampOffset(offset) {
      const numeric = Number.isFinite(offset) ? Math.trunc(offset) : 0;
      return Math.max(0, Math.min(getSource().length, numeric));
    }

    function getSelection() {
      return {
        start: clampOffset(textarea.selectionStart),
        end: clampOffset(textarea.selectionEnd)
      };
    }

    function setSelection(start, end = start) {
      const nextStart = clampOffset(start);
      const nextEnd = Math.max(nextStart, clampOffset(end));
      textarea.setSelectionRange(nextStart, nextEnd);
    }

    function offsetToPosition(offset) {
      const source = getSource();
      const nextOffset = clampOffset(offset);
      const lineStart = source.lastIndexOf('\n', nextOffset - 1) + 1;
      return {
        row: source.slice(0, nextOffset).split('\n').length - 1,
        column: nextOffset - lineStart
      };
    }

    function positionToOffset(position) {
      const lines = getSource().split('\n');
      const requestedRow = Number.isFinite(position?.row)
        ? Math.trunc(position.row)
        : 0;
      const row = Math.max(0, Math.min(lines.length - 1, requestedRow));
      const requestedColumn = Number.isFinite(position?.column)
        ? Math.trunc(position.column)
        : 0;
      const column = Math.max(0, Math.min(lines[row].length, requestedColumn));
      let offset = column;
      for (let index = 0; index < row; index += 1) {
        offset += lines[index].length + 1;
      }
      return offset;
    }

    function syncScroll() {
      gutter.scrollTop = textarea.scrollTop;
      if (!errorLine) return;
      const style = getComputedStyle(textarea);
      const lineHeight = parseFloat(style.lineHeight);
      const paddingTop = parseFloat(style.paddingTop);
      const top = paddingTop + (errorLine - 1) * lineHeight
        - textarea.scrollTop;
      textarea.style.setProperty('--error-line-top', `${top}px`);
    }

    function refresh() {
      const count = getSource().split('\n').length;
      const numbers = document.createDocumentFragment();
      for (let number = 1; number <= count; number += 1) {
        const item = document.createElement('span');
        item.textContent = String(number);
        if (number === errorLine) item.className = 'error-line';
        numbers.append(item);
      }
      gutter.replaceChildren(numbers);
      syncScroll();
    }

    function notifyChange() {
      refresh();
      for (const listener of changeListeners) listener();
    }

    function setSource(source, options = {}) {
      textarea.value = source;
      const selection = options.selection || {
        start: source.length,
        end: source.length
      };
      setSelection(selection.start, selection.end);
      if (options.notify === false) {
        refresh();
      } else {
        notifyChange();
      }
    }

    function replaceRange(start, end, replacement, options = {}) {
      const rangeStart = clampOffset(start);
      const rangeEnd = Math.max(rangeStart, clampOffset(end));
      textarea.setRangeText(
        replacement,
        rangeStart,
        rangeEnd,
        'preserve'
      );
      const replacementEnd = rangeStart + replacement.length;
      if (options.selection && typeof options.selection === 'object') {
        setSelection(options.selection.start, options.selection.end);
      } else if (options.selection === 'select') {
        setSelection(rangeStart, replacementEnd);
      } else if (options.selection === 'start') {
        setSelection(rangeStart);
      } else {
        setSelection(replacementEnd);
      }
      if (options.notify === false) {
        refresh();
      } else {
        notifyChange();
      }
    }

    function selectRange(start, end, options = {}) {
      setSelection(start, end);
      if (options.focus) textarea.focus();
      if (options.reveal) {
        const position = offsetToPosition(start);
        const lineHeight = parseFloat(getComputedStyle(textarea).lineHeight);
        textarea.scrollTop = Math.max(0, (position.row - 1) * lineHeight);
        syncScroll();
      }
    }

    function setErrorLine(line) {
      errorLine = Number.isFinite(line) && line > 0 ? line : 0;
      textarea.classList.toggle('has-error-line', errorLine > 0);
      refresh();
    }

    textarea.addEventListener('input', notifyChange);
    textarea.addEventListener('scroll', syncScroll);
    refresh();

    return {
      getSource,
      setSource,
      replaceRange,
      getSelection,
      setSelection,
      selectRange,
      offsetToPosition,
      positionToOffset,
      focus: () => textarea.focus(),
      onChange(listener) {
        changeListeners.add(listener);
        return () => changeListeners.delete(listener);
      },
      onKeydown(listener) {
        textarea.addEventListener('keydown', listener);
      },
      containsTarget(target) {
        return target === textarea || textarea.contains(target);
      },
      setErrorLine,
      refresh
    };
  }

  const editor = createTextareaEditorAdapter(dot, lineNumbers);
  if (window.__GVIZ_BROWSER_TEST__) {
    window.__GVIZ_EDITOR_TEST__ = editor;
  }

  function validTheme(candidate) {
    return themes.includes(candidate) ? candidate : 'system';
  }

  function applyTheme(candidate, persist = true) {
    const selected = validTheme(candidate);
    const effective = selected === 'system'
      ? (themeMedia.matches ? 'dark' : 'light')
      : selected;
    theme.value = selected;
    document.documentElement.dataset.theme = selected;
    document.documentElement.dataset.effectiveTheme = effective;
    document.documentElement.style.colorScheme = effective;
    if (persist) queueSaveSession();
  }

  function systemThemeChanged() {
    if (theme.value === 'system') applyTheme('system', false);
  }

  function setState(state, label) {
    previewShell.dataset.state = state;
    renderStatus.textContent = label;
  }

  function populateNewNodeShapes() {
    const shapes = nodeShapeCategories[newNodeCategory.value]
      || nodeShapeCategories['basic-shapes'];
    const options = shapes.map((shape) => {
      const option = document.createElement('option');
      option.value = shape;
      option.textContent = shape || 'Default';
      return option;
    });
    newNodeShape.replaceChildren(...options);
    newNodeShape.value = shapes[0];
    inheritNewNodeShape = false;
  }

  function showNewNodeDefaultShape(shape) {
    const category = Object.entries(nodeShapeCategories).find((entry) => {
      return entry[1].includes(shape);
    });
    if (category) {
      newNodeCategory.value = category[0];
      populateNewNodeShapes();
      newNodeShape.value = shape;
    }
    inheritNewNodeShape = true;
  }

  function populateAttributeShapes() {
    const options = nodeShapes.map((shape) => {
      const option = document.createElement('option');
      option.value = shape;
      option.textContent = shape || 'Default';
      return option;
    });
    attrShape.replaceChildren(...options);
  }

  function setPreviewControls(enabled) {
    if (!enabled) setSvgSourceVisible(false);
    zoomOut.disabled = !enabled || showingSvgSource;
    zoomIn.disabled = !enabled || showingSvgSource;
    fullscreenZoomOut.disabled = !enabled || showingSvgSource;
    fullscreenZoomIn.disabled = !enabled || showingSvgSource;
    resetView.disabled = !enabled || showingSvgSource;
    saveSvg.disabled = !enabled;
    fit.disabled = !enabled || showingSvgSource;
    toggleSvgSource.disabled = !enabled;
    copySvg.disabled = !enabled;
    fullscreenSvg.disabled = !enabled;
    fullscreenSvg.hidden = !enabled || showingSvgSource;
  }

  function setSvgSourceVisible(visible) {
    showingSvgSource = Boolean(visible && currentSvg && lastSvgSource);
    preview.hidden = showingSvgSource;
    svgSource.hidden = !showingSvgSource;
    toggleSvgSource.setAttribute(
      'aria-pressed',
      String(showingSvgSource)
    );
    toggleSvgSource.textContent = showingSvgSource
      ? 'View rendered'
      : 'View source';
    zoomOut.disabled = !currentSvg || showingSvgSource;
    zoomIn.disabled = !currentSvg || showingSvgSource;
    fullscreenZoomOut.disabled = !currentSvg || showingSvgSource;
    fullscreenZoomIn.disabled = !currentSvg || showingSvgSource;
    resetView.disabled = !currentSvg || showingSvgSource;
    fit.disabled = !currentSvg || showingSvgSource;
    fullscreenSvg.hidden = !currentSvg || showingSvgSource;
    if (showingSvgSource) {
      clearVisualSelection();
      svgSource.focus();
    } else if (currentSvg) {
      preview.focus();
    }
  }

  function toggleSvgView() {
    setSvgSourceVisible(!showingSvgSource);
  }

  async function writeClipboard(source) {
    try {
      if (navigator.clipboard?.writeText) {
        await navigator.clipboard.writeText(source);
        return;
      }
    } catch (_) {
      // Fall through for browsers that restrict the Clipboard API.
    }
    const helper = document.createElement('textarea');
    helper.value = source;
    helper.setAttribute('readonly', '');
    helper.style.position = 'fixed';
    helper.style.opacity = '0';
    document.body.append(helper);
    helper.select();
    const copied = document.execCommand('copy');
    helper.remove();
    if (!copied) throw new Error('Clipboard unavailable');
  }

  async function copySvgSource() {
    if (!lastSvgSource) return;
    try {
      await writeClipboard(lastSvgSource);
      sourceStatus.textContent = 'SVG copied';
    } catch (cause) {
      showClientProblem('Unable to copy SVG source');
    }
  }

  function previewIsFullscreen() {
    return document.fullscreenElement === previewShell;
  }

  function updateFullscreenControl() {
    const expanded = previewIsFullscreen();
    const label = expanded
      ? 'Return SVG to preview panel'
      : 'Expand SVG to fullscreen';
    fullscreenSvg.setAttribute('aria-pressed', String(expanded));
    fullscreenSvg.setAttribute('aria-label', label);
    fullscreenSvg.title = label;
    previewShell.classList.toggle('is-fullscreen', expanded);
    if (currentSvg && !showingSvgSource) {
      requestAnimationFrame(fitToWindow);
    }
  }

  async function toggleSvgFullscreen() {
    if (!currentSvg || showingSvgSource) return;
    try {
      if (previewIsFullscreen()) {
        await document.exitFullscreen();
      } else {
        await previewShell.requestFullscreen();
      }
    } catch (cause) {
      showClientProblem('Unable to change fullscreen mode');
    }
  }

  function docsTabById(id) {
    return docsTabs.find((tab) => tab.id === id);
  }

  function explorerTabButtons() {
    return Array.from(explorerTabs.querySelectorAll('[role="tab"]'));
  }

  function validExplorerView(viewName) {
    return permanentExplorerViews.includes(viewName) ||
      (viewName === helpExplorerView &&
        Boolean(document.querySelector('#help-tab'))) ||
      Boolean(docsTabById(viewName));
  }

  function setExplorerView(viewName, focus = false) {
    explorerView = validExplorerView(viewName) ? viewName : 'dot-files';
    for (const tab of explorerTabButtons()) {
      const active = tab.dataset.explorerView === explorerView;
      tab.setAttribute('aria-selected', String(active));
      tab.tabIndex = active ? 0 : -1;
      tab.classList.toggle('active', active);
      tab.parentElement?.classList.toggle('active', active);
      const panelId = tab.getAttribute('aria-controls');
      const panel = panelId ? document.getElementById(panelId) : undefined;
      if (panel) panel.hidden = !active;
    }
    const selectedDocs = docsTabById(explorerView);
    help.setAttribute(
      'aria-expanded',
      String(explorerView === helpExplorerView)
    );
    if (selectedDocs && docsAvailable === true) {
      const frame = document.querySelector(
        `#${selectedDocs.id}-panel iframe`
      );
      if (frame && !frame.getAttribute('src')) {
        frame.src = `${docsRoot}${selectedDocs.path}`;
      }
    }
    if (focus) {
      explorerTabs.querySelector(
        `[data-explorer-view="${explorerView}"]`
      )?.focus();
    }
    queueSaveSession();
  }

  function explorerTabKeydown(event) {
    if (!['ArrowLeft', 'ArrowRight', 'Home', 'End']
      .includes(event.key)) return;
    event.preventDefault();
    const tabs = explorerTabButtons();
    const current = tabs.indexOf(event.currentTarget);
    let next = current;
    if (event.key === 'Home') next = 0;
    else if (event.key === 'End') next = tabs.length - 1;
    else if (event.key === 'ArrowLeft') {
      next = (current - 1 + tabs.length) % tabs.length;
    } else {
      next = (current + 1) % tabs.length;
    }
    setExplorerView(tabs[next].dataset.explorerView, true);
  }

  function createHelpTab() {
    const existing = document.querySelector('#help-tab');
    if (existing) return existing;
    const wrapper = document.createElement('div');
    wrapper.id = 'help-tab-control';
    wrapper.className = 'explorer-tab-control help-tab-control';
    wrapper.setAttribute('role', 'presentation');
    const control = document.createElement('button');
    control.type = 'button';
    control.id = 'help-tab';
    control.className = 'explorer-tab';
    control.dataset.explorerView = helpExplorerView;
    control.setAttribute('role', 'tab');
    control.setAttribute('aria-selected', 'false');
    control.setAttribute('aria-controls', 'help-panel');
    control.tabIndex = -1;
    control.textContent = 'Help';
    control.addEventListener(
      'click',
      () => setExplorerView(helpExplorerView)
    );
    control.addEventListener('keydown', explorerTabKeydown);
    const close = document.createElement('button');
    close.type = 'button';
    close.className = 'docs-tab-close';
    close.setAttribute('aria-label', 'Close Help');
    close.textContent = '×';
    close.addEventListener('click', closeHelpTab);
    wrapper.append(control, close);
    const svgControl = svgFilesTab.parentElement;
    if (svgControl) svgControl.after(wrapper);
    else explorerTabs.append(wrapper);
    explorerPane.append(helpPanel);
    return control;
  }

  function openHelp() {
    createHelpTab();
    setHelpVariant(docsAvailable === true);
    refreshHelpVariant();
    setExplorerView(helpExplorerView, true);
  }

  function closeHelpTab() {
    const control = document.querySelector('#help-tab');
    if (!control) return;
    const wasActive = explorerView === helpExplorerView;
    control.parentElement?.remove();
    helpPanel.hidden = true;
    if (wasActive) setExplorerView('svg-files', true);
    else queueSaveSession();
  }

  function docsTabLabel(documentTitle) {
    const ignored = new Set(['docs', 'graph viz']);
    const names = String(documentTitle || '').split(/\s*(?:>|\/)\s*/)
      .map((name) => name.trim())
      .filter((name) => name && !ignored.has(name.toLowerCase()));
    return names.length ? names[names.length - 1] : 'Docs';
  }

  function usefulDocsTitle(title) {
    return docsTabLabel(title) !== 'Docs';
  }

  function syncDocsTab(tab, control, close, frame) {
    try {
      const title = frame.contentDocument?.title?.trim();
      const pathname = frame.contentWindow?.location?.pathname || '';
      if (usefulDocsTitle(title)) {
        tab.title = title;
        control.textContent = docsTabLabel(title);
        control.title = title;
        close.setAttribute(
          'aria-label',
          `Close ${docsTabLabel(title)}`
        );
      }
      if (pathname.startsWith(docsRoot)) {
        tab.path = pathname.slice(docsRoot.length);
        control.dataset.docPath = tab.path;
      }
      queueSaveSession();
      const titleNode = frame.contentDocument?.querySelector('title');
      if (titleNode && typeof MutationObserver !== 'undefined') {
        const observer = new MutationObserver(() => {
          const nextTitle = frame.contentDocument?.title?.trim();
          if (!usefulDocsTitle(nextTitle)) return;
          tab.title = nextTitle;
          control.textContent = docsTabLabel(nextTitle);
          control.title = nextTitle;
          close.setAttribute(
            'aria-label',
            `Close ${docsTabLabel(nextTitle)}`
          );
          queueSaveSession();
        });
        observer.observe(titleNode, {childList: true, characterData: true,
          subtree: true});
      }
    } catch (_) {
      // The docs frame remains usable if its title cannot be inspected.
    }
  }

  function createDocsTab(tab) {
    const wrapper = document.createElement('div');
    wrapper.className = 'docs-tab-control';
    wrapper.setAttribute('role', 'presentation');
    wrapper.dataset.docsTab = tab.id;
    const control = document.createElement('button');
    control.type = 'button';
    control.className = 'docs-tab';
    control.id = `${tab.id}-tab`;
    control.dataset.explorerView = tab.id;
    control.dataset.docPath = tab.path;
    control.setAttribute('role', 'tab');
    control.setAttribute('aria-selected', 'false');
    control.setAttribute('aria-controls', `${tab.id}-panel`);
    control.tabIndex = -1;
    control.textContent = docsTabLabel(tab.title);
    control.title = tab.title;
    control.addEventListener('click', () => setExplorerView(tab.id));
    control.addEventListener('keydown', explorerTabKeydown);
    const close = document.createElement('button');
    close.type = 'button';
    close.className = 'docs-tab-close';
    close.setAttribute('aria-label', `Close ${tab.title}`);
    close.textContent = '×';
    close.addEventListener('click', () => closeDocsTab(tab.id));
    wrapper.append(control, close);
    explorerTabs.append(wrapper);
    const panel = document.createElement('div');
    panel.className = 'explorer-panel docs-explorer-panel';
    panel.id = `${tab.id}-panel`;
    panel.hidden = true;
    panel.setAttribute('role', 'tabpanel');
    panel.setAttribute('aria-labelledby', control.id);
    const frame = document.createElement('iframe');
    frame.className = 'docs-explorer-frame';
    frame.title = `${tab.title} documentation`;
    frame.addEventListener(
      'load',
      () => syncDocsTab(tab, control, close, frame)
    );
    frame.addEventListener('error', disableDocsExplorer);
    panel.append(frame);
    explorerPane.append(panel);
  }

  function renderDocsTabs() {
    for (const node of explorerTabs.querySelectorAll('[data-docs-tab]')) {
      node.remove();
    }
    for (const node of explorerPane.querySelectorAll(
      '.docs-explorer-panel'
    )) {
      node.remove();
    }
    for (const tab of docsTabs) createDocsTab(tab);
  }

  function openDocsTab(title, path) {
    if (docsAvailable !== true) return;
    const existing = docsTabs.find((tab) => tab.path === path);
    if (existing) {
      setExplorerView(existing.id, true);
      return;
    }
    const tab = {id: `docs-${nextDocs++}`, title, path};
    docsTabs.push(tab);
    createDocsTab(tab);
    setExplorerView(tab.id, true);
  }

  function closeDocsTab(id) {
    const index = docsTabs.findIndex((tab) => tab.id === id);
    if (index < 0) return;
    const wasActive = explorerView === id;
    document.querySelector(`[data-docs-tab="${id}"]`)?.remove();
    document.querySelector(`#${id}-panel`)?.remove();
    docsTabs.splice(index, 1);
    if (wasActive) {
      const neighbor = docsTabs[Math.min(index, docsTabs.length - 1)];
      setExplorerView(neighbor?.id || 'dot-files', true);
    } else {
      queueSaveSession();
    }
  }

  function disableDocsExplorer() {
    docsAvailable = false;
    const wasDocs = Boolean(docsTabById(explorerView));
    docsTabs = [];
    renderDocsTabs();
    if (wasDocs) setExplorerView('dot-files');
    setHelpVariant(false);
  }

  function setHelpVariant(useDocs) {
    fallbackHelpContent.hidden = useDocs;
    docsHelpContent.hidden = !useDocs;
    if (useDocs && docsTabById(explorerView)) {
      setExplorerView(explorerView);
    }
  }

  async function refreshHelpVariant() {
    if (docsCheckPending || docsAvailable === true) return;
    docsCheckPending = true;
    try {
      const response = await fetch('/docs', {
        method: 'GET',
        credentials: 'same-origin',
        cache: 'no-store'
      });
      const responseUrl = new URL(response.url, window.location.origin);
      const contentType = response.headers.get('content-type') || '';
      const docsPath = responseUrl.pathname === '/docs' ||
        responseUrl.pathname.startsWith('/docs/');
      docsAvailable = response.ok &&
        responseUrl.origin === window.location.origin && docsPath &&
        contentType.includes('text/html');
    } catch (_) {
      docsAvailable = false;
    } finally {
      docsCheckPending = false;
    }
    if (docsAvailable) setHelpVariant(true);
    else disableDocsExplorer();
  }

  function showClayError(cause) {
    clayErrorMessage.textContent = String(cause);
    clayErrorModal.hidden = false;
    closeClayError.focus();
  }

  function hideClayError() {
    clayErrorModal.hidden = true;
  }

  function closeFileContext(restoreFocus = false) {
    fileContextMenu.hidden = true;
    if (contextFileSource) {
      contextFileSource.setAttribute('aria-expanded', 'false');
      if (restoreFocus) contextFileSource.focus();
    }
    contextFileKind = undefined;
    contextFilePath = undefined;
    contextFileSource = undefined;
  }

  function openFileContext(kind, path, source, event) {
    event.preventDefault();
    event.stopPropagation();
    closeFileContext();
    contextFileKind = kind;
    contextFilePath = path;
    contextFileSource = source;
    source.setAttribute('aria-expanded', 'true');
    fileContextMenu.style.left = '0px';
    fileContextMenu.style.top = '0px';
    fileContextMenu.hidden = false;
    const menuRect = fileContextMenu.getBoundingClientRect();
    const sourceRect = source.getBoundingClientRect();
    const margin = 8;
    const maximumLeft = window.innerWidth - menuRect.width - margin;
    const maximumTop = window.innerHeight - menuRect.height - margin;
    const pointer = event.type === 'contextmenu';
    const left = clamp(
      pointer ? event.clientX : sourceRect.right,
      margin,
      Math.max(margin, maximumLeft)
    );
    const top = clamp(
      pointer ? event.clientY : sourceRect.top,
      margin,
      Math.max(margin, maximumTop)
    );
    fileContextMenu.style.left = `${left}px`;
    fileContextMenu.style.top = `${top}px`;
    fileContextOpen.focus();
  }

  async function openContextFile() {
    const kind = contextFileKind;
    const path = contextFilePath;
    closeFileContext();
    if (!kind || !path) return;
    if (kind === 'dot') await loadCurrentDot(path);
    else await loadCurrentSvg(path);
  }

  async function deleteContextFile() {
    const kind = contextFileKind;
    const path = contextFilePath;
    const source = contextFileSource;
    if (!kind || !path) return;
    if (!window.confirm(`Delete ${path}? This cannot be undone.`)) {
      closeFileContext();
      source?.focus();
      return;
    }
    closeFileContext();
    try {
      await clayFileRequest(kind, 'delete', '', path);
      await refreshFileTree(kind);
      const label = `${path} deleted`;
      if (kind === 'dot') sourceStatus.textContent = label;
      else renderStatus.textContent = label;
    } catch (cause) {
      showClayError(cause);
    }
  }

  function fileContextKeydown(event) {
    const items = [fileContextOpen, fileContextDelete]
      .filter((item) => !item.disabled);
    const current = items.indexOf(document.activeElement);
    let next = current;
    if (event.key === 'Escape') {
      event.preventDefault();
      closeFileContext(true);
      return;
    }
    if (event.key === 'Home') next = 0;
    else if (event.key === 'End') next = items.length - 1;
    else if (event.key === 'ArrowDown') {
      next = (current + 1) % items.length;
    } else if (event.key === 'ArrowUp') {
      next = (current - 1 + items.length) % items.length;
    } else {
      return;
    }
    event.preventDefault();
    items[next].focus();
  }

  function normalizeClayPath(value) {
    const path = value.trim().replace(/^\/+/, '');
    if (!path || path.split('/').some((part) => {
      return !part || part === '.' || part === '..';
    })) {
      throw new Error('Enter a relative Clay path');
    }
    if (!/^[A-Za-z0-9._~/-]+$/.test(path)) {
      throw new Error('Clay path contains unsupported characters');
    }
    return path;
  }

  function renderFileTree(paths, kind) {
    const tree = kind === 'dot' ? dotFilesTree : svgFilesTree;
    const root = new Map();
    for (const rawPath of paths) {
      if (typeof rawPath !== 'string') {
        throw new Error('Invalid Clay file list');
      }
      const path = normalizeClayPath(rawPath);
      const parts = path.split('/');
      let branch = root;
      for (const [index, name] of parts.entries()) {
        if (!branch.has(name)) {
          branch.set(name, {children: new Map(), path: undefined});
        }
        const node = branch.get(name);
        if (index === parts.length - 1) node.path = path;
        branch = node.children;
      }
    }
    tree.replaceChildren();
    tree.setAttribute('aria-busy', 'false');
    if (!root.size) {
      tree.textContent =
        `No /${kind === 'dot' ? 'txt' : 'svg'} files found.`;
      return;
    }
    function appendFile(item, label, path) {
      const row = document.createElement('div');
      row.className = 'explorer-file-row';
      row.setAttribute('role', 'treeitem');
      const file = document.createElement('button');
      file.type = 'button';
      file.className = 'file-tree-file';
      file.dataset.path = path;
      file.textContent = label;
      file.title = path;
      file.addEventListener('click', async () => {
        closeFileContext();
        if (kind === 'dot') {
          await loadCurrentDot(path);
        } else {
          await loadCurrentSvg(path);
        }
      });
      row.addEventListener('contextmenu', (event) => {
        openFileContext(kind, path, file, event);
      });
      const actions = document.createElement('button');
      actions.type = 'button';
      actions.className = 'file-tree-actions';
      actions.setAttribute('aria-label', `Actions for ${label}`);
      actions.setAttribute('aria-haspopup', 'menu');
      actions.setAttribute('aria-expanded', 'false');
      actions.textContent = '…';
      actions.addEventListener('click', (event) => {
        openFileContext(kind, path, actions, event);
      });
      row.append(file, actions);
      item.append(row);
    }
    function renderBranch(branch) {
      const list = document.createElement('ul');
      list.className = 'file-tree-list';
      const entries = [...branch.entries()]
        .sort(([left], [right]) => left.localeCompare(right));
      for (const [name, node] of entries) {
        const item = document.createElement('li');
        const children = [...node.children.entries()];
        const suffix = children.length === 1 ? children[0] : undefined;
        if (!node.path && suffix && suffix[1].path
          && !suffix[1].children.size) {
          appendFile(item, `${name}/${suffix[0]}`, suffix[1].path);
          list.append(item);
          continue;
        }
        if (node.children.size) {
          const directory = document.createElement('div');
          directory.className = 'file-tree-directory';
          directory.textContent = `${name}/`;
          item.append(directory);
        }
        if (node.path) appendFile(item, name, node.path);
        if (node.children.size) item.append(renderBranch(node.children));
        list.append(item);
      }
      return list;
    }
    tree.append(renderBranch(root));
  }

  async function browseClayNode(kind, path = '') {
    const headers = path ? {'x-graph-viz-path': path} : {};
    const response = await fetch(
      `/apps/graph-viz/file/${kind}/browse`,
      {method: 'POST', headers}
    );
    const body = await response.text();
    if (!response.ok) {
      throw new Error(body || `Clay request failed (${response.status})`);
    }
    const node = JSON.parse(body);
    if (!node || typeof node.file !== 'boolean'
      || !Array.isArray(node.children)) {
      throw new Error('Invalid Clay directory');
    }
    const paths = node.file ? [path] : [];
    for (const name of node.children) {
      if (typeof name !== 'string' || !name || name.includes('/')) {
        throw new Error('Invalid Clay directory');
      }
      const childPath = normalizeClayPath(
        path ? `${path}/${name}` : name
      );
      paths.push(...await browseClayNode(kind, childPath));
    }
    return paths;
  }

  async function refreshFileTree(kind) {
    const tree = kind === 'dot' ? dotFilesTree : svgFilesTree;
    tree.replaceChildren();
    tree.textContent = 'Loading…';
    tree.setAttribute('aria-busy', 'true');
    try {
      renderFileTree(await browseClayNode(kind), kind);
    } catch (cause) {
      tree.setAttribute('aria-busy', 'false');
      tree.replaceChildren();
      tree.textContent = `Unable to load files: ${String(cause)}`;
      showClayError(cause);
    }
  }

  function showFileExplorer(kind) {
    setExplorerView(kind === 'dot' ? 'dot-files' : 'svg-files', true);
    refreshFileTree(kind);
  }

  function sourceByteLength(source) {
    return new TextEncoder().encode(source).byteLength;
  }

  function validateSource(source, limit = maxSourceBytes) {
    if (typeof source !== 'string') throw new Error('DOT must be text');
    if (source.includes('\0')) throw new Error('DOT contains a null byte');
    if (sourceByteLength(source) > limit) {
      throw new Error(`DOT exceeds the ${limit}-byte limit`);
    }
    return source;
  }

  function validView(candidate) {
    if (!candidate || typeof candidate !== 'object') return undefined;
    const values = [candidate.scale, candidate.x, candidate.y];
    if (!values.every(Number.isFinite)) return undefined;
    if (Math.abs(candidate.x) > 1e7 || Math.abs(candidate.y) > 1e7) {
      return undefined;
    }
    return {
      scale: clamp(candidate.scale, minScale, maxScale),
      x: candidate.x,
      y: candidate.y
    };
  }

  function validDocsTab(candidate) {
    if (!candidate || typeof candidate !== 'object') return undefined;
    if (!/^docs-[1-9][0-9]*$/.test(candidate.id)) return undefined;
    if (typeof candidate.title !== 'string' || !candidate.title.trim()
      || candidate.title.length > 200) return undefined;
    if (typeof candidate.path !== 'string' || !candidate.path
      || candidate.path.length > 1_024
      || candidate.path.startsWith('/')
      || candidate.path.split('/').some((part) => {
        return !part || part === '.' || part === '..';
      })) return undefined;
    return {
      id: candidate.id,
      title: candidate.title.trim(),
      path: candidate.path
    };
  }

  function loadSession() {
    try {
      const saved = JSON.parse(localStorage.getItem(storageKey));
      if (!saved || saved.version !== 1) return undefined;
      const source = validateSource(saved.source);
      const paneWidth = Number(saved.paneWidth);
      const explorerWidth = Number(saved.explorerWidth);
      const preferences = saved.preferences || {};
      const seenPaths = new Set();
      const seenIds = new Set();
      const savedDocsTabs = Array.isArray(saved.docsTabs)
        ? saved.docsTabs.map(validDocsTab).filter((tab) => {
          if (!tab || seenPaths.has(tab.path) || seenIds.has(tab.id)) {
            return false;
          }
          seenPaths.add(tab.path);
          seenIds.add(tab.id);
          return true;
        })
        : [];
      const highestDocsId = savedDocsTabs.reduce((highest, tab) => {
        return Math.max(highest, Number(tab.id.slice(5)) + 1);
      }, 1);
      const savedNextDocs = Number(saved.nextDocs);
      const savedExplorerView = typeof saved.explorerView === 'string'
        && (permanentExplorerViews.includes(saved.explorerView)
          || savedDocsTabs.some((tab) => tab.id === saved.explorerView))
        ? saved.explorerView
        : 'dot-files';
      return {
        source,
        paneWidth: Number.isFinite(paneWidth)
          ? clamp(paneWidth, 25, 70)
          : 44,
        explorerWidth: Number.isFinite(explorerWidth)
          ? Math.max(explorerWidth, minExplorerWidth)
          : 288,
        explorerView: savedExplorerView,
        docsTabs: savedDocsTabs,
        nextDocs: Number.isSafeInteger(savedNextDocs)
          ? Math.max(savedNextDocs, highestDocsId)
          : highestDocsId,
        view: validView(saved.view),
        autoRender: preferences.autoRender !== false,
        theme: validTheme(preferences.theme)
      };
    } catch (_) {
      return undefined;
    }
  }

  function currentPaneWidth() {
    const value = getComputedStyle(workspace)
      .getPropertyValue('--editor-width');
    return clamp(parseFloat(value) || 44, 25, 70);
  }

  function currentExplorerWidth() {
    const value = getComputedStyle(workbench)
      .getPropertyValue('--explorer-width');
    return clamp(
      parseFloat(value) || 288,
      minExplorerWidth,
      maxExplorerWidth()
    );
  }

  function maxExplorerWidth() {
    const bounds = workbench.getBoundingClientRect();
    return Math.max(
      minExplorerWidth,
      bounds.width - explorerDividerWidth
    );
  }

  function setExplorerWidth(width) {
    const nextWidth = clamp(
      width,
      minExplorerWidth,
      maxExplorerWidth()
    );
    workbench.style.setProperty('--explorer-width', `${nextWidth}px`);
  }

  function saveSession() {
    clearTimeout(saveTimer);
    try {
      const source = editor.getSource();
      validateSource(source);
      localStorage.setItem(storageKey, JSON.stringify({
        version: 1,
        source,
        paneWidth: currentPaneWidth(),
        explorerWidth: currentExplorerWidth(),
        explorerView,
        docsTabs,
        nextDocs,
        view,
        preferences: {
          autoRender: autoRender.checked,
          theme: theme.value
        }
      }));
    } catch (_) {
      // Storage can be disabled or full without blocking the editor.
    }
  }

  function queueSaveSession() {
    clearTimeout(saveTimer);
    saveTimer = setTimeout(saveSession, saveDelay);
  }

  function encodeSource(source) {
    const bytes = new TextEncoder().encode(source);
    let binary = '';
    for (const byte of bytes) binary += String.fromCharCode(byte);
    return btoa(binary)
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=+$/g, '');
  }

  function decodeSource(encoded) {
    if (!encoded || encoded.length > maxShareParamChars) {
      throw new Error('Shared DOT parameter is missing or too large');
    }
    if (!/^[A-Za-z0-9_-]+$/.test(encoded)) {
      throw new Error('Shared DOT parameter is invalid');
    }
    const base64 = encoded.replace(/-/g, '+').replace(/_/g, '/');
    const padded = base64 + '='.repeat((4 - base64.length % 4) % 4);
    const binary = atob(padded);
    const bytes = Uint8Array.from(binary, (char) => char.charCodeAt(0));
    const source = new TextDecoder('utf-8', {fatal: true}).decode(bytes);
    validateSource(source, maxSharedSourceBytes);
    if (encodeSource(source) !== encoded) {
      throw new Error('Shared DOT parameter is not canonical');
    }
    return source;
  }

  function sourceFromUrl() {
    const encoded = new URL(window.location.href).searchParams.get('dot');
    return encoded === null ? undefined : decodeSource(encoded);
  }

  function showClientProblem(message) {
    error.textContent = message;
    error.hidden = false;
    setState(currentSvg ? 'ready' : 'empty', 'Input error');
  }

  function invalidateRender() {
    latestRequestUid = ++requestUid;
  }

  function formatProblem(problem) {
    if (problem.kind === 'parse') {
      return `Line ${problem.line}, column ${problem.column}: `
        + (problem.message || 'syntax error');
    }
    if (problem.kind === 'unsupported-feature') {
      return `Unsupported feature: ${problem.message}`;
    }
    if (problem.kind === 'layout') {
      return `Layout error: ${problem.message}`;
    }
    return problem.message || problem.kind || 'render failed';
  }

  function showProblem(problem) {
    setErrorLine(problem.kind === 'parse' ? Number(problem.line) : 0);
    error.textContent = formatProblem(problem);
    error.hidden = false;
    const hasPreview = Boolean(preview.querySelector('svg'));
    setState(hasPreview ? 'ready' : 'empty', 'Render failed');
  }

  function setErrorLine(line) {
    editor.setErrorLine(line);
  }

  function dotTokens(source) {
    const tokens = [];
    const symbols = '{}[];,:=+';
    let index = 0;
    let lineStart = true;
    while (index < source.length) {
      const char = source[index];
      if (/\s/.test(char)) {
        if (char === '\n') lineStart = true;
        index += 1;
        continue;
      }
      if (source.startsWith('//', index)
        || (char === '#' && lineStart)) {
        const newline = source.indexOf('\n', index);
        index = newline < 0 ? source.length : newline;
        continue;
      }
      if (source.startsWith('/*', index)) {
        const close = source.indexOf('*/', index + 2);
        index = close < 0 ? source.length : close + 2;
        continue;
      }
      lineStart = false;
      const start = index;
      if (char === '"') {
        let value = '';
        index += 1;
        while (index < source.length) {
          const current = source[index];
          if (current === '"') {
            index += 1;
            break;
          }
          if (current === '\\' && index + 1 < source.length) {
            const next = source[index + 1];
            if (next === '"') {
              value += '"';
              index += 2;
              continue;
            }
            if (next === '\n') {
              index += 2;
              continue;
            }
            if (next === '\r' && source[index + 2] === '\n') {
              index += 3;
              continue;
            }
            value += '\\' + next;
            index += 2;
            continue;
          }
          value += current;
          index += 1;
        }
        tokens.push({type: 'id', value, start, end: index, quoted: true});
        continue;
      }
      if (source.startsWith('->', index)
        || source.startsWith('--', index)) {
        tokens.push({
          type: 'edge',
          value: source.slice(index, index + 2),
          start,
          end: index + 2
        });
        index += 2;
        continue;
      }
      if (symbols.includes(char)) {
        tokens.push({type: 'symbol', value: char, start, end: index + 1});
        index += 1;
        continue;
      }
      while (index < source.length) {
        const next = source[index];
        if (/\s/.test(next) || symbols.includes(next)) break;
        if (source.startsWith('->', index)
          || source.startsWith('--', index)
          || source.startsWith('//', index)
          || source.startsWith('/*', index)) break;
        index += 1;
      }
      if (index === start) index += 1;
      tokens.push({
        type: 'id',
        value: source.slice(start, index),
        start,
        end: index,
        quoted: false
      });
    }
    return tokens;
  }

  function matchingToken(tokens, index, open, close) {
    let depth = 0;
    for (let cursor = index; cursor < tokens.length; cursor += 1) {
      if (tokens[cursor].value === open) depth += 1;
      if (tokens[cursor].value === close) depth -= 1;
      if (depth === 0) return cursor;
    }
    return tokens.length - 1;
  }

  function parseDotId(tokens, index) {
    const token = tokens[index];
    if (!token || token.type !== 'id') return undefined;
    let value = token.value;
    let cursor = index + 1;
    while (tokens[cursor]?.value === '+'
      && tokens[cursor + 1]?.type === 'id') {
      value += tokens[cursor + 1].value;
      cursor += 2;
    }
    return {value, next: cursor, quoted: token.quoted};
  }

  function consumeAttributes(tokens, index) {
    let cursor = index;
    while (tokens[cursor]?.value === '[') {
      cursor = matchingToken(tokens, cursor, '[', ']') + 1;
    }
    return cursor;
  }

  function namesFromStatements(statements) {
    const names = new Set();
    for (const statement of statements) {
      for (const name of statement.nodeNames || []) names.add(name);
    }
    return [...names];
  }

  function parseDotEndpoint(tokens, index, limit) {
    let cursor = index;
    const token = tokens[cursor];
    const isSubgraph = token?.type === 'id'
      && !token.quoted
      && token.value.toLowerCase() === 'subgraph';
    if (isSubgraph) {
      cursor += 1;
      if (tokens[cursor]?.value !== '{') {
        const name = parseDotId(tokens, cursor);
        if (name) cursor = name.next;
      }
    }
    if (tokens[cursor]?.value === '{') {
      const close = Math.min(
        matchingToken(tokens, cursor, '{', '}'),
        limit
      );
      const nested = parseDotStatementList(tokens, cursor + 1, close);
      return {
        values: namesFromStatements(nested),
        next: close + 1,
        nested,
        simple: false
      };
    }
    const id = parseDotId(tokens, cursor);
    if (!id) return undefined;
    cursor = id.next;
    let simple = true;
    for (let port = 0; port < 2 && tokens[cursor]?.value === ':'; port += 1) {
      const part = parseDotId(tokens, cursor + 1);
      if (!part) break;
      simple = false;
      cursor = part.next;
    }
    return {values: [id.value], next: cursor, nested: [], simple};
  }

  function finishDotStatement(tokens, index) {
    if (tokens[index]?.value === ';') return index + 1;
    return index;
  }

  function dotStatementRange(tokens, start, next) {
    const last = tokens[Math.max(start, next - 1)];
    return {start: tokens[start].start, end: last.end};
  }

  function parseDotStatement(tokens, start, limit) {
    const firstId = parseDotId(tokens, start);
    const lower = firstId?.value.toLowerCase();
    if (firstId && !firstId.quoted
      && ['graph', 'node', 'edge'].includes(lower)
      && tokens[firstId.next]?.value === '[') {
      const next = finishDotStatement(
        tokens,
        consumeAttributes(tokens, firstId.next)
      );
      return {next, statements: []};
    }
    if (firstId && tokens[firstId.next]?.value === '=') {
      const value = parseDotId(tokens, firstId.next + 1);
      const next = finishDotStatement(
        tokens,
        value ? value.next : firstId.next + 1
      );
      return {next, statements: []};
    }
    const first = parseDotEndpoint(tokens, start, limit);
    if (!first) return {next: start + 1, statements: []};
    let cursor = first.next;
    const nested = [...first.nested];
    if (tokens[cursor]?.type !== 'edge') {
      if (first.nested.length) {
        return {
          next: finishDotStatement(tokens, cursor),
          statements: nested
        };
      }
      cursor = consumeAttributes(tokens, cursor);
      cursor = finishDotStatement(tokens, cursor);
      return {
        next: cursor,
        statements: [{
          kind: 'node',
          nodeNames: first.values,
          edges: [],
          ...dotStatementRange(tokens, start, cursor)
        }]
      };
    }
    const edges = [];
    const edgeParts = [];
    let simpleEdges = first.simple;
    const nodeNames = new Set(first.values);
    let left = first.values;
    while (tokens[cursor]?.type === 'edge') {
      const operator = tokens[cursor].value;
      const right = parseDotEndpoint(tokens, cursor + 1, limit);
      if (!right) break;
      simpleEdges = simpleEdges && right.simple;
      nested.push(...right.nested);
      for (const tail of left) {
        for (const head of right.values) {
          edges.push(tail + operator + head);
          edgeParts.push({tail, head, operator});
        }
      }
      for (const name of right.values) nodeNames.add(name);
      left = right.values;
      cursor = right.next;
    }
    cursor = consumeAttributes(tokens, cursor);
    cursor = finishDotStatement(tokens, cursor);
    return {
      next: cursor,
      statements: [...nested, {
        kind: 'edge',
        nodeNames: [...nodeNames],
        edges,
        edgeParts,
        simpleEdges,
        ...dotStatementRange(tokens, start, cursor)
      }]
    };
  }

  function parseDotStatementList(tokens, start, limit) {
    const statements = [];
    let cursor = start;
    while (cursor < limit) {
      if (tokens[cursor]?.value === ';'
        || tokens[cursor]?.value === ',') {
        cursor += 1;
        continue;
      }
      const parsed = parseDotStatement(tokens, cursor, limit);
      statements.push(...parsed.statements);
      cursor = parsed.next > cursor ? parsed.next : cursor + 1;
    }
    return statements;
  }

  function dotStatements(source) {
    const tokens = dotTokens(source);
    const open = tokens.findIndex((token) => token.value === '{');
    if (open < 0) return [];
    const close = matchingToken(tokens, open, '{', '}');
    return parseDotStatementList(tokens, open + 1, close);
  }

  function graphBody(source) {
    const tokens = dotTokens(source);
    const open = tokens.findIndex((token) => token.value === '{');
    if (open < 0) throw new Error('Graph body not found');
    const header = tokens.slice(0, open).find((token) => {
      const value = token.value.toLowerCase();
      return !token.quoted && (value === 'graph' || value === 'digraph');
    });
    if (!header) throw new Error('Graph type not found');
    const close = matchingToken(tokens, open, '{', '}');
    if (tokens[close]?.value !== '}') {
      throw new Error('Graph closing brace not found');
    }
    return {
      close: tokens[close].start,
      operator: header.value.toLowerCase() === 'digraph' ? '->' : '--'
    };
  }

  function dotIdSource(value) {
    const identity = value.trim();
    const keywords = [
      'strict', 'graph', 'digraph', 'node', 'edge', 'subgraph'
    ];
    const bareName = /^[A-Za-z_\u0080-\u00ff][A-Za-z0-9_\u0080-\u00ff]*$/;
    const numeral = /^-?(?:\.[0-9]+|[0-9]+(?:\.[0-9]*)?)$/;
    if (!identity || identity.length > 80) {
      throw new Error('Node names must contain 1 to 80 characters');
    }
    if (/[\0\r\n\\]/.test(identity)) {
      throw new Error('Node names cannot contain controls or backslashes');
    }
    if ((bareName.test(identity) || numeral.test(identity))
      && !keywords.includes(identity.toLowerCase())) return identity;
    return `"${identity.replace(/"/g, '\\"')}"`;
  }

  function dotValueSource(value, maximum = 200) {
    if (value.length > maximum || /[\0\r\n]/.test(value)) {
      throw new Error(`Attribute values must be at most ${maximum} characters`);
    }
    if (value.endsWith('\\')) {
      throw new Error('Attribute values cannot end with a backslash');
    }
    return `"${value.replace(/"/g, '\\"')}"`;
  }

  function validColor(value) {
    if (!value) return true;
    return /^#[0-9A-Fa-f]{6}$/.test(value)
      || /^[A-Za-z][A-Za-z0-9]*$/.test(value);
  }

  function insertRootStatement(source, statement) {
    const body = graphBody(source);
    const before = source.slice(0, body.close);
    const newline = before.endsWith('\n') ? '' : '\n';
    return before + newline + `  ${statement}\n` + source.slice(body.close);
  }

  function applyVisualMutation(source) {
    validateSource(source);
    editor.setSource(source);
    renderNow();
  }

  function mutationProblem(cause) {
    showClientProblem(cause instanceof Error ? cause.message : String(cause));
  }

  function addVisualNode() {
    try {
      const identity = newNodeName.value.trim();
      const id = dotIdSource(identity);
      const shape = inheritNewNodeShape ? '' : newNodeShape.value;
      if (!nodeShapes.includes(shape)) {
        throw new Error('Unsupported node shape');
      }
      const currentSource = editor.getSource();
      const exists = dotStatements(currentSource).some((statement) => {
        return statement.nodeNames.includes(identity);
      });
      if (exists) throw new Error('A node with that name already exists');
      const source = insertRootStatement(
        currentSource,
        shape ? `${id} [shape=${shape}]` : id
      );
      newNodeName.value = '';
      applyVisualMutation(source);
    } catch (cause) {
      mutationProblem(cause);
    }
  }

  function drawSelectedEdge() {
    try {
      if (selectedItems.length !== 2
        || selectedItems.some((item) => item.kind !== 'node')) {
        throw new Error('Shift-click two nodes before drawing an edge');
      }
      const source = editor.getSource();
      const body = graphBody(source);
      const [tail, head] = selectedItems.map((item) => item.identity);
      const identity = tail + body.operator + head;
      const exists = dotStatements(source).some((statement) => {
        return statement.edges.includes(identity);
      });
      if (exists) throw new Error('That edge already exists');
      const edge = `${dotIdSource(tail)} ${body.operator} ${dotIdSource(head)}`;
      applyVisualMutation(insertRootStatement(source, edge));
    } catch (cause) {
      mutationProblem(cause);
    }
  }

  function statementRemovalRange(source, statement) {
    const lineStart = source.lastIndexOf('\n', statement.start - 1) + 1;
    const nextLine = source.indexOf('\n', statement.end);
    const lineEnd = nextLine < 0 ? source.length : nextLine + 1;
    const before = source.slice(lineStart, statement.start).trim();
    const afterEnd = nextLine < 0 ? source.length : nextLine;
    const after = source.slice(statement.end, afterEnd).trim();
    if (!before && !after) return {start: lineStart, end: lineEnd};
    return {start: statement.start, end: statement.end};
  }

  function removeStatementRanges(source, statements) {
    const ordered = statements.map((statement) => {
      return statementRemovalRange(source, statement);
    })
      .sort((left, right) => left.start - right.start);
    const merged = [];
    for (const range of ordered) {
      const previous = merged.at(-1);
      if (previous && range.start <= previous.end) {
        previous.end = Math.max(previous.end, range.end);
      } else {
        merged.push({...range});
      }
    }
    const ranges = merged.reverse();
    let result = source;
    for (const range of ranges) {
      result = result.slice(0, range.start) + result.slice(range.end);
    }
    return result;
  }

  function deleteSelectedItem() {
    try {
      if (selectedItems.length !== 1) {
        throw new Error('Select one node or edge to delete');
      }
      const selected = selectedItems[0];
      const source = editor.getSource();
      const statements = dotStatements(source);
      let removals;
      if (selected.kind === 'edge') {
        const statement = statements.find((candidate) => {
          return candidate.edges.includes(selected.identity);
        });
        if (!statement || statement.edges.length !== 1) {
          throw new Error('Edit edge chains or grouped edges in DOT');
        }
        removals = [statement];
      } else {
        removals = statements.filter((statement) => {
          return statement.nodeNames.includes(selected.identity);
        });
        const unsafe = removals.some((statement) => {
          return statement.kind === 'edge' && statement.edges.length !== 1;
        });
        if (unsafe) {
          throw new Error('Edit nodes used in chains or groups in DOT');
        }
      }
      if (!removals.length) throw new Error('Source statement not found');
      applyVisualMutation(removeStatementRanges(source, removals));
    } catch (cause) {
      mutationProblem(cause);
    }
  }

  function editableStatement(kind, identity) {
    const statements = dotStatements(editor.getSource());
    if (kind === 'edge') {
      return statements.find((candidate) => {
        return candidate.edges.includes(identity);
      });
    }
    const matches = statements.filter((statement) => {
      return statement.kind === 'node'
        && statement.nodeNames.length === 1
        && statement.nodeNames[0] === identity;
    });
    return matches.at(-1);
  }

  function splitEdgeStatement(statement) {
    if (statement.edges.length < 2 || !statement.simpleEdges) {
      return statement;
    }
    const parsed = readStatementAttributes(statement);
    const source = editor.getSource();
    const lineStart = source.lastIndexOf('\n', statement.start - 1) + 1;
    const indent = source.slice(lineStart, statement.start)
      .match(/^\s*/)?.[0] || '';
    const statements = statement.edgeParts.map((edge) => {
      const base = dotIdSource(edge.tail) + ' ' + edge.operator + ' '
        + dotIdSource(edge.head);
      return writeStatementAttributes({...parsed, base});
    });
    const replacement = statements.join('\n' + indent);
    editor.replaceRange(
      statement.start,
      statement.end,
      replacement,
      {notify: false}
    );
    return undefined;
  }

  function readStatementAttributes(statement) {
    if (!statement) return {base: '', semicolon: false, attributes: new Map()};
    const segment = editor.getSource().slice(statement.start, statement.end);
    const tokens = dotTokens(segment);
    const firstOpen = tokens.findIndex((token) => token.value === '[');
    const semicolon = tokens.at(-1)?.value === ';';
    if (firstOpen < 0) {
      const end = semicolon ? tokens.at(-1).start : segment.length;
      return {
        base: segment.slice(0, end).trimEnd(),
        semicolon,
        attributes: new Map()
      };
    }
    if (/\/\*|\/\//.test(segment.slice(tokens[firstOpen].start))) {
      throw new Error('Edit attributes containing comments in DOT');
    }
    const attributes = new Map();
    let cursor = firstOpen;
    let lastClose = firstOpen;
    while (tokens[cursor]?.value === '[') {
      const close = matchingToken(tokens, cursor, '[', ']');
      let item = cursor + 1;
      while (item < close) {
        if (tokens[item].value === ',' || tokens[item].value === ';') {
          item += 1;
          continue;
        }
        const key = parseDotId(tokens, item);
        if (!key || tokens[key.next]?.value !== '=') {
          throw new Error('Edit complex attribute lists in DOT');
        }
        const valueStart = key.next + 1;
        const value = parseDotId(tokens, valueStart);
        if (!value || value.next > close) {
          throw new Error('Edit complex attribute lists in DOT');
        }
        const rawStart = tokens[valueStart].start;
        const rawEnd = tokens[value.next - 1].end;
        attributes.set(key.value.toLowerCase(), {
          name: key.value,
          nameRaw: segment.slice(
            tokens[item].start,
            tokens[key.next - 1].end
          ),
          value: value.value,
          raw: segment.slice(rawStart, rawEnd)
        });
        item = value.next;
      }
      lastClose = close;
      cursor = close + 1;
    }
    if (tokens[cursor] && tokens[cursor].value !== ';') {
      throw new Error('Edit complex attribute statements in DOT');
    }
    return {
      base: segment.slice(0, tokens[firstOpen].start).trimEnd(),
      semicolon: tokens[cursor]?.value === ';',
      attributes,
      lastClose
    };
  }

  function setParsedAttribute(parsed, name, value, decoded = value) {
    if (value === undefined) {
      parsed.attributes.delete(name);
      return;
    }
    parsed.attributes.set(name, {name, raw: value, value: decoded});
  }

  function numericAttribute(value, name, integer = false) {
    const source = value.trim();
    if (!source) return undefined;
    const number = Number(source);
    if (!Number.isFinite(number) || number < 0
      || (integer && !Number.isInteger(number))) {
      throw new Error(`${name} must be a non-negative number`);
    }
    return source;
  }

  function writeStatementAttributes(parsed) {
    const values = [...parsed.attributes.values()];
    const attributes = values.length
      ? ' [' + values.map((item) => {
          return `${item.nameRaw || item.name}=${item.raw}`;
        }).join(', ') + ']'
      : '';
    return parsed.base + attributes + (parsed.semicolon ? ';' : '');
  }

  function populateAttributeForm(selected) {
    attributeForm.hidden = false;
    attrChangeAll.checked = false;
    attrUseDefault.checked = false;
    const statement = editableStatement(selected.kind, selected.identity);
    try {
      const parsed = readStatementAttributes(statement);
      const get = (name) => parsed.attributes.get(name)?.value || '';
      const styles = get('style').split(',').map((value) => value.trim());
      attrLabel.value = get('label');
      attrColor.value = get('color');
      attrStyle.value = ['solid', 'dashed', 'dotted', 'bold', 'invis']
        .find((style) => styles.includes(style)) || '';
      const isNode = selected.kind === 'node';
      shapeControl.hidden = !isNode;
      fillControl.hidden = !isNode;
      edgeControls.hidden = isNode;
      const sourceShape = isNode ? get('shape') : '';
      attrShape.dataset.sourceShape = sourceShape;
      attrShape.value = nodeShapes.includes(sourceShape) ? sourceShape : '';
      attrFillcolor.value = isNode ? get('fillcolor') : '';
      attrPenwidth.value = isNode ? '' : get('penwidth');
      attrArrowhead.value = isNode ? '' : get('arrowhead');
      attrArrowtail.value = isNode ? '' : get('arrowtail');
      attrArrowsize.value = isNode ? '' : get('arrowsize');
      attrDir.value = isNode ? '' : get('dir');
      attrMinlen.value = isNode ? '' : get('minlen');
      attrWeight.value = isNode ? '' : get('weight');
      attrFontname.value = isNode ? '' : get('fontname');
      attrFontsize.value = isNode ? '' : get('fontsize');
      attrFontcolor.value = isNode ? '' : get('fontcolor');
    } catch (cause) {
      attributeForm.hidden = true;
      sourceStatus.textContent = cause.message;
    }
  }

  function applyFormAttributes(parsed, kind) {
    const label = attrLabel.value;
    const color = attrColor.value.trim();
    const fillcolor = attrFillcolor.value.trim();
    const sourceShape = kind === 'node'
      ? attrShape.dataset.sourceShape || ''
      : '';
    const preserveSourceShape = Boolean(sourceShape && !attrShape.value);
    const shape = preserveSourceShape ? sourceShape : attrShape.value;
    const lineStyle = attrStyle.value;
    const lineStyles = [
      '', 'solid', 'dashed', 'dotted', 'bold', 'invis'
    ];
    const fontcolor = attrFontcolor.value.trim();
    if (!validColor(color) || !validColor(fillcolor)
      || !validColor(fontcolor)) {
      throw new Error('Colors must be names or six-digit hex values');
    }
    if ((!nodeShapes.includes(shape) && !preserveSourceShape)
      || !lineStyles.includes(lineStyle)
      || !arrowShapes.includes(attrArrowhead.value)
      || !arrowShapes.includes(attrArrowtail.value)
      || !edgeDirections.includes(attrDir.value)) {
      throw new Error('Unsupported attribute value');
    }
    setParsedAttribute(
      parsed,
      'label',
      label ? dotValueSource(label) : undefined,
      label
    );
    setParsedAttribute(
      parsed,
      'color',
      color ? dotValueSource(color, 40) : undefined,
      color
    );
    const oldStyles = (parsed.attributes.get('style')?.value || '')
      .split(',')
      .map((value) => value.trim())
      .filter(Boolean);
    const controlled = new Set(['solid', 'dashed', 'dotted', 'bold']);
    controlled.add('invis');
    if (kind === 'node') controlled.add('filled');
    const styles = oldStyles.filter((style) => !controlled.has(style));
    if (lineStyle) styles.push(lineStyle);
    if (kind === 'node') {
      const hadFillcolor = parsed.attributes.has('fillcolor');
      const keepFilled = fillcolor
        || (oldStyles.includes('filled') && !hadFillcolor);
      if (keepFilled) styles.push('filled');
      if (!preserveSourceShape) {
        setParsedAttribute(
          parsed,
          'shape',
          shape || undefined,
          shape
        );
      }
      setParsedAttribute(
        parsed,
        'fillcolor',
        fillcolor ? dotValueSource(fillcolor, 40) : undefined,
        fillcolor
      );
    } else {
      const penwidth = numericAttribute(
        attrPenwidth.value,
        'Pen width'
      );
      const arrowsize = numericAttribute(
        attrArrowsize.value,
        'Arrow size'
      );
      const minlen = numericAttribute(
        attrMinlen.value,
        'Minimum length',
        true
      );
      const weight = numericAttribute(
        attrWeight.value,
        'Weight',
        true
      );
      const fontsize = numericAttribute(
        attrFontsize.value,
        'Font size'
      );
      const edgeValues = [
        ['penwidth', penwidth],
        ['arrowhead', attrArrowhead.value || undefined],
        ['arrowtail', attrArrowtail.value || undefined],
        ['arrowsize', arrowsize],
        ['dir', attrDir.value || undefined],
        ['minlen', minlen],
        ['weight', weight],
        [
          'fontname',
          attrFontname.value
            ? dotValueSource(attrFontname.value, 80)
            : undefined,
          attrFontname.value
        ],
        ['fontsize', fontsize],
        [
          'fontcolor',
          fontcolor ? dotValueSource(fontcolor, 40) : undefined,
          fontcolor
        ]
      ];
      for (const [name, value, decoded = value] of edgeValues) {
        setParsedAttribute(parsed, name, value, decoded);
      }
    }
    const uniqueStyles = [...new Set(styles)];
    setParsedAttribute(
      parsed,
      'style',
      uniqueStyles.length
        ? dotValueSource(uniqueStyles.join(','), 80)
        : undefined,
      uniqueStyles.join(',')
    );
    return parsed;
  }

  function replaceStatementAttributes(source, statements, kind) {
    const unique = [...new Map(statements.map((statement) => {
      return [`${statement.start}:${statement.end}`, statement];
    })).values()].sort((left, right) => right.start - left.start);
    let result = source;
    for (const statement of unique) {
      const parsed = applyFormAttributes(
        readStatementAttributes(statement),
        kind
      );
      result = result.slice(0, statement.start)
        + writeStatementAttributes(parsed)
        + result.slice(statement.end);
    }
    return result;
  }

  function changeAllAttributes(source, kind) {
    const statements = dotStatements(source);
    if (kind === 'edge') {
      const edges = statements.filter((statement) => {
        return statement.kind === 'edge';
      });
      return replaceStatementAttributes(source, edges, kind);
    }
    const names = [...new Set(statements.flatMap((statement) => {
      return statement.nodeNames;
    }))];
    const explicit = new Map();
    for (const statement of statements) {
      if (statement.kind === 'node' && statement.nodeNames.length === 1) {
        explicit.set(statement.nodeNames[0], statement);
      }
    }
    let result = replaceStatementAttributes(
      source,
      [...explicit.values()],
      kind
    );
    for (const name of names.filter((name) => !explicit.has(name))) {
      const parsed = applyFormAttributes({
        base: dotIdSource(name),
        semicolon: false,
        attributes: new Map()
      }, kind);
      result = insertRootStatement(result, writeStatementAttributes(parsed));
    }
    return result;
  }

  function addAttributeDefault(source, kind) {
    const parsed = applyFormAttributes({
      base: kind,
      semicolon: false,
      attributes: new Map()
    }, kind);
    if (!parsed.attributes.size) return source;
    if (kind === 'node') {
      showNewNodeDefaultShape(parsed.attributes.get('shape')?.value || '');
    }
    return insertRootStatement(source, writeStatementAttributes(parsed));
  }

  function applySelectedAttributes(event) {
    event.preventDefault();
    try {
      if (selectedItems.length !== 1) {
        throw new Error('Select one node or edge to edit');
      }
      const selected = selectedItems[0];
      let source = editor.getSource();
      if (attrChangeAll.checked) {
        source = changeAllAttributes(source, selected.kind);
      } else {
        let statement = editableStatement(selected.kind, selected.identity);
        if (selected.kind === 'edge' && statement?.edges.length > 1) {
          splitEdgeStatement(statement);
          source = editor.getSource();
          statement = editableStatement(selected.kind, selected.identity);
        }
        const parsed = applyFormAttributes(
          statement
            ? readStatementAttributes(statement)
            : {
                base: dotIdSource(selected.identity),
                semicolon: false,
                attributes: new Map()
              },
          selected.kind
        );
        const replacement = writeStatementAttributes(parsed);
        source = statement
          ? source.slice(0, statement.start)
            + replacement
            + source.slice(statement.end)
          : insertRootStatement(source, replacement);
      }
      if (attrUseDefault.checked) {
        source = addAttributeDefault(source, selected.kind);
      }
      applyVisualMutation(source);
    } catch (cause) {
      mutationProblem(cause);
    }
  }

  function sourceRangeFor(kind, identity) {
    const statements = dotStatements(editor.getSource());
    if (kind === 'node') {
      const explicit = statements.find((statement) => {
        return statement.kind === 'node'
          && statement.nodeNames.includes(identity);
      });
      if (explicit) return explicit;
      return statements.find((statement) => {
        return statement.nodeNames.includes(identity);
      });
    }
    return statements.find((statement) => {
      return statement.kind === 'edge'
        && statement.edges.includes(identity);
    });
  }

  function selectSourceStatement(kind, identity) {
    const range = sourceRangeFor(kind, identity);
    if (!range) {
      sourceStatus.textContent = 'Source statement not found';
      return;
    }
    editor.selectRange(range.start, range.end, {focus: true, reveal: true});
    sourceStatus.textContent = `Selected ${kind}`;
  }

  function visualGroup(target) {
    const group = target?.closest?.('.node, .edge');
    if (!group || !currentSvg?.contains(group)) return undefined;
    return group;
  }

  function clearVisualSelection() {
    for (const selected of selectedItems) {
      selected.element.classList.remove('is-selected');
      selected.element.removeAttribute('aria-current');
    }
    selectedItems = [];
    inspector.hidden = true;
    attributeForm.hidden = true;
    drawEdge.disabled = true;
    selectionKind.textContent = '';
    selectionId.textContent = '';
  }

  function refreshVisualSelection() {
    drawEdge.disabled = selectedItems.length !== 2
      || selectedItems.some((item) => item.kind !== 'node');
    deleteSelection.disabled = selectedItems.length !== 1;
    if (!selectedItems.length) {
      inspector.hidden = true;
      attributeForm.hidden = true;
      return;
    }
    inspector.hidden = false;
    if (selectedItems.length === 2) {
      selectionKind.textContent = 'Nodes';
      selectionId.textContent = selectedItems
        .map((item) => item.identity)
        .join(' -> ');
      attributeForm.hidden = true;
      return;
    }
    const selected = selectedItems[0];
    selectionKind.textContent = selected.kind === 'node' ? 'Node' : 'Edge';
    selectionId.textContent = selected.identity;
    populateAttributeForm(selected);
  }

  function selectVisualElement(group, additive = false) {
    const title = group.querySelector(':scope > title');
    if (!title) return;
    const kind = group.classList.contains('node') ? 'node' : 'edge';
    const identity = title.textContent;
    const existing = selectedItems.findIndex((item) => {
      return item.element === group;
    });
    if (additive && kind === 'node' && existing >= 0) {
      const removed = selectedItems.splice(existing, 1)[0];
      removed.element.classList.remove('is-selected');
      removed.element.removeAttribute('aria-current');
      refreshVisualSelection();
      return;
    }
    if (!additive || kind !== 'node'
      || selectedItems.some((item) => item.kind !== 'node')) {
      clearVisualSelection();
    } else if (selectedItems.length >= 2) {
      const removed = selectedItems.pop();
      removed.element.classList.remove('is-selected');
      removed.element.removeAttribute('aria-current');
    }
    if (!selectedItems.some((item) => item.element === group)) {
      const selected = {element: group, kind, identity};
      selectedItems.push(selected);
      group.classList.add('is-selected');
      group.setAttribute('aria-current', 'true');
    }
    refreshVisualSelection();
    selectSourceStatement(kind, identity);
  }

  function editorChanged() {
    clearVisualSelection();
    error.hidden = true;
    setErrorLine(0);
    queueSaveSession();
    if (autoRender.checked) {
      queueRender();
    } else {
      invalidateRender();
      clearTimeout(renderTimer);
      sourceStatus.textContent = 'Changed';
    }
  }

  function clamp(value, minimum, maximum) {
    return Math.max(minimum, Math.min(maximum, value));
  }

  function applyView() {
    if (!currentSvg) return;
    const transform = `translate(${view.x}px, ${view.y}px) `
      + `scale(${view.scale})`;
    currentSvg.style.transform = transform;
    queueSaveSession();
  }

  function zoomAtCenter(factor) {
    if (!currentSvg || showingSvgSource) return;
    const bounds = preview.getBoundingClientRect();
    const centerX = bounds.width / 2;
    const centerY = bounds.height / 2;
    const graphX = (centerX - view.x) / view.scale;
    const graphY = (centerY - view.y) / view.scale;
    const nextScale = clamp(view.scale * factor, minScale, maxScale);
    view.x = centerX - graphX * nextScale;
    view.y = centerY - graphY * nextScale;
    view.scale = nextScale;
    applyView();
  }

  function fitToWindow() {
    if (!currentSvg) return;
    const bounds = preview.getBoundingClientRect();
    const availableWidth = Math.max(1, bounds.width - 48);
    const availableHeight = Math.max(1, bounds.height - 48);
    view.scale = clamp(Math.min(
      availableWidth / graphSize.width,
      availableHeight / graphSize.height
    ), minScale, maxScale);
    view.x = (bounds.width - graphSize.width * view.scale) / 2;
    view.y = (bounds.height - graphSize.height * view.scale) / 2;
    applyView();
  }

  function resetGraphView() {
    if (!currentSvg) return;
    const bounds = preview.getBoundingClientRect();
    view.scale = 1;
    view.x = Math.max(16, (bounds.width - graphSize.width) / 2);
    view.y = Math.max(16, (bounds.height - graphSize.height) / 2);
    applyView();
  }

  function parseSvg(source) {
    const parsed = new DOMParser().parseFromString(source, 'image/svg+xml');
    if (parsed.querySelector('parsererror')) {
      throw new Error('invalid SVG response');
    }
    const svg = parsed.documentElement;
    if (svg.localName !== 'svg'
      || svg.namespaceURI !== 'http://www.w3.org/2000/svg') {
      throw new Error('response is not SVG');
    }
    const forbidden = 'script, foreignObject, iframe, object, embed, link';
    if (svg.querySelector(forbidden)) {
      throw new Error('unsafe SVG response');
    }
    const elements = [svg, ...svg.querySelectorAll('*')];
    for (const element of elements) {
      for (const attribute of element.attributes) {
        const name = attribute.name.toLowerCase();
        const value = attribute.value.trim().toLowerCase();
        if (name.startsWith('on') || value.includes('javascript:')) {
          throw new Error('unsafe SVG attribute');
        }
        if (attribute.localName === 'href' && !value.startsWith('#')) {
          throw new Error('external SVG reference');
        }
      }
    }
    return svg;
  }

  function installSvg(source) {
    const svg = document.importNode(parseSvg(source), true);
    const box = svg.viewBox.baseVal;
    if (!box || box.width <= 0 || box.height <= 0) {
      throw new Error('SVG has no usable view box');
    }
    graphSize = {width: box.width, height: box.height};
    svg.style.width = `${box.width}px`;
    svg.style.height = `${box.height}px`;
    svg.setAttribute('role', 'img');
    const title = svg.querySelector(':scope > title');
    if (title) {
      if (!title.id) title.id = 'graph-viz-title';
      svg.setAttribute('aria-labelledby', title.id);
    } else {
      svg.setAttribute('aria-label', 'Rendered graph');
    }
    for (const group of svg.querySelectorAll('.node, .edge')) {
      const itemTitle = group.querySelector(':scope > title');
      const kind = group.classList.contains('node') ? 'Node' : 'Edge';
      group.setAttribute('role', 'button');
      group.setAttribute('tabindex', '0');
      if (itemTitle) {
        group.setAttribute('aria-label', `${kind} ${itemTitle.textContent}`);
      }
    }
    clearVisualSelection();
    currentSvg = svg;
    lastSvgSource = source;
    svgSource.textContent = source;
    preview.replaceChildren(svg);
    const restoredView = pendingView;
    pendingView = undefined;
    requestAnimationFrame(() => {
      if (restoredView) {
        view = restoredView;
        applyView();
      } else {
        fitToWindow();
      }
    });
  }

  function queueRender() {
    invalidateRender();
    clearTimeout(renderTimer);
    sourceStatus.textContent = 'Waiting';
    renderTimer = setTimeout(render, renderDelay);
  }

  function renderNow() {
    invalidateRender();
    clearTimeout(renderTimer);
    render();
  }

  function requestClayPath(kind) {
    const value = window.prompt(`${kind} path`);
    if (value === null) return undefined;
    return normalizeClayPath(value);
  }

  async function clayFileRequest(
    kind,
    action,
    source = '',
    requestedPath,
    overwrite = false
  ) {
    const path = requestedPath === undefined
      ? requestClayPath(kind.toUpperCase())
      : normalizeClayPath(requestedPath);
    if (path === undefined) return undefined;
    const headers = {
      'content-type': 'text/plain; charset=utf-8',
      'x-graph-viz-path': path
    };
    if (overwrite) headers['x-graph-viz-overwrite'] = 'true';
    const response = await fetch(
      `/apps/graph-viz/file/${kind}/${action}`,
      {
        method: 'POST',
        headers,
        body: source
      }
    );
    const body = await response.text();
    if (action === 'save' && response.status === 409 && !overwrite) {
      const approved = window.confirm(
        `${kind.toUpperCase()} path "${path}" already exists. Overwrite it?`
      );
      if (!approved) return undefined;
      return clayFileRequest(kind, action, source, path, true);
    }
    if (!response.ok) {
      throw new Error(body || `Clay request failed (${response.status})`);
    }
    return body;
  }

  async function loadCurrentDot(path) {
    try {
      sourceStatus.textContent = 'Loading';
      const source = await clayFileRequest('dot', 'load', '', path);
      if (source === undefined) return;
      validateSource(source);
      editor.setSource(source);
    } catch (cause) {
      showClayError(cause);
      showClientProblem(String(cause));
    } finally {
      sourceStatus.textContent = 'Ready';
    }
  }

  async function saveCurrentDot() {
    try {
      const source = editor.getSource();
      validateSource(source);
      sourceStatus.textContent = 'Saving';
      const result = await clayFileRequest('dot', 'save', source);
      sourceStatus.textContent = result === undefined ? 'Ready' : 'Saved';
      if (result !== undefined) await refreshFileTree('dot');
    } catch (cause) {
      showClayError(cause);
      showClientProblem(String(cause));
      sourceStatus.textContent = 'Save failed';
    }
  }

  async function loadCurrentSvg(path) {
    try {
      setState('loading', 'Loading');
      const source = await clayFileRequest('svg', 'load', '', path);
      if (source === undefined) {
        const state = currentSvg ? 'ready' : 'empty';
        setState(state, currentSvg ? 'Rendered' : 'Empty');
        return;
      }
      installSvg(source);
      autoRender.checked = false;
      queueSaveSession();
      error.textContent = '';
      error.hidden = true;
      setPreviewControls(true);
      setState('ready', 'Rendered');
    } catch (cause) {
      showClayError(cause);
      error.textContent = String(cause);
      error.hidden = false;
      setState(currentSvg ? 'ready' : 'empty', 'Load failed');
    }
  }

  async function saveCurrentSvg() {
    if (!lastSvgSource) return;
    try {
      setState('loading', 'Saving');
      const result = await clayFileRequest('svg', 'save', lastSvgSource);
      setState('ready', result === undefined ? 'Rendered' : 'Saved');
      if (result !== undefined) await refreshFileTree('svg');
    } catch (cause) {
      showClayError(cause);
      error.textContent = String(cause);
      error.hidden = false;
      setState('ready', 'Save failed');
    }
  }

  function handleTab(event) {
    event.preventDefault();
    const indent = '  ';
    const source = editor.getSource();
    const {start, end} = editor.getSelection();
    if (start === end && !event.shiftKey) {
      editor.replaceRange(start, end, indent);
      return;
    }
    const lineStart = source.lastIndexOf('\n', start - 1) + 1;
    if (start === end) {
      const match = source.slice(lineStart, lineStart + 2).match(/^ {1,2}/);
      if (!match) return;
      const cursor = Math.max(lineStart, start - match[0].length);
      editor.replaceRange(
        lineStart,
        lineStart + match[0].length,
        '',
        {selection: {start: cursor, end: cursor}}
      );
      return;
    }
    const block = source.slice(lineStart, end);
    const replacement = block.split('\n').map((line) => {
      return event.shiftKey ? line.replace(/^ {1,2}/, '') : indent + line;
    }).join('\n');
    editor.replaceRange(
      lineStart,
      end,
      replacement,
      {selection: 'select'}
    );
  }

  function handleEditorKeydown(event) {
    if (event.key === 'Tab') {
      handleTab(event);
      return;
    }
    if (event.ctrlKey || event.metaKey || event.altKey) return;
    const pairs = {'{': '}', '[': ']', '(': ')', '"': '"'};
    const closers = Object.values(pairs);
    const source = editor.getSource();
    const {start, end} = editor.getSelection();
    if (start === end && closers.includes(event.key)
      && source[start] === event.key) {
      event.preventDefault();
      editor.setSelection(start + 1);
      return;
    }
    const closing = pairs[event.key];
    const escapedQuote = event.key === '"' && source[start - 1] === '\\';
    if (!closing || escapedQuote) return;
    event.preventDefault();
    const selected = source.slice(start, end);
    editor.replaceRange(
      start,
      end,
      event.key + selected + closing,
      {selection: {start: start + 1, end: end + 1}}
    );
  }

  function insertTemplate() {
    const source = templates[template.value];
    if (!source) return;
    editor.setSource(source, {selection: {start: 0, end: 0}});
    template.value = '';
    editor.focus();
  }

  function handleShortcut(event) {
    if (event.key === 'Escape' && !clayErrorModal.hidden) {
      event.preventDefault();
      hideClayError();
      return;
    }
    if (event.key === 'Escape' && !fileContextMenu.hidden) {
      event.preventDefault();
      closeFileContext(true);
      return;
    }
    if (event.key === 'Escape' && explorerView === helpExplorerView) {
      event.preventDefault();
      closeHelpTab();
      help.focus();
      return;
    }
    if (event.key === 'Escape' && selectedItems.length) {
      event.preventDefault();
      clearVisualSelection();
      preview.focus();
      return;
    }
    if (event.key === 'Delete' && selectedItems.length === 1
      && !editor.containsTarget(event.target)
      && !event.target?.matches?.('input, textarea, select')) {
      event.preventDefault();
      deleteSelectedItem();
      return;
    }
    if (!event.ctrlKey && !event.metaKey) return;
    if (event.key === 'Enter') {
      event.preventDefault();
      renderNow();
    } else if (event.key.toLowerCase() === 's') {
      event.preventDefault();
      if (event.shiftKey) {
        saveCurrentSvg();
      } else {
        saveCurrentDot();
      }
    } else if (event.key === '0') {
      event.preventDefault();
      fitToWindow();
    } else if (event.key === '1') {
      event.preventDefault();
      resetGraphView();
    }
  }

  async function render() {
    const uid = latestRequestUid = ++requestUid;
    const source = editor.getSource();
    try {
      validateSource(source);
    } catch (cause) {
      showClientProblem(String(cause));
      sourceStatus.textContent = 'Too large';
      button.disabled = false;
      return;
    }
    if (!source.trim()) {
      preview.replaceChildren();
      currentSvg = undefined;
      lastSvgSource = '';
      error.hidden = true;
      setErrorLine(0);
      setPreviewControls(false);
      setState('empty', 'Empty');
      sourceStatus.textContent = 'Ready';
      button.disabled = false;
      return;
    }
    button.disabled = true;
    sourceStatus.textContent = 'Rendering';
    error.textContent = '';
    error.hidden = true;
    setState('loading', 'Loading');
    try {
      const response = await fetch('/apps/graph-viz/render', {
        method: 'POST',
        headers: {
          'content-type': 'text/vnd.graphviz',
          'x-graph-viz-request': String(uid)
        },
        body: source
      });
      const body = await response.text();
      if (uid !== latestRequestUid) return;
      if (!response.ok) {
        let problem;
        try {
          problem = JSON.parse(body);
        } catch (_) {
          problem = {
            kind: 'request',
            message: body || `Request failed (${response.status})`
          };
        }
        showProblem(problem);
        return;
      }
      const contentType = response.headers.get('content-type') || '';
      if (!contentType.startsWith('image/svg+xml')) {
        showProblem({kind: 'request', message: 'Invalid SVG response'});
        return;
      }
      try {
        installSvg(body);
      } catch (_) {
        showProblem({kind: 'request', message: 'Invalid SVG response'});
        return;
      }
      setErrorLine(0);
      setPreviewControls(true);
      setState('ready', 'Rendered');
    } catch (cause) {
      if (uid !== latestRequestUid) return;
      error.textContent = String(cause);
      error.hidden = false;
      setState('disconnected', 'Disconnected');
    } finally {
      if (uid === latestRequestUid) {
        button.disabled = false;
        sourceStatus.textContent = 'Ready';
      }
    }
  }

  button.addEventListener('click', renderNow);
  addNode.addEventListener('click', addVisualNode);
  drawEdge.addEventListener('click', drawSelectedEdge);
  deleteSelection.addEventListener('click', deleteSelectedItem);
  attributeForm.addEventListener('submit', applySelectedAttributes);
  attrShape.addEventListener('change', () => {
    attrShape.dataset.sourceShape = '';
  });
  newNodeCategory.addEventListener('change', populateNewNodeShapes);
  newNodeShape.addEventListener('change', () => {
    inheritNewNodeShape = false;
  });
  newNodeName.addEventListener('keydown', (event) => {
    if (event.key !== 'Enter') return;
    event.preventDefault();
    addVisualNode();
  });
  browseDot.addEventListener('click', () => showFileExplorer('dot'));
  loadDot.addEventListener('click', () => loadCurrentDot());
  saveDot.addEventListener('click', saveCurrentDot);
  browseSvg.addEventListener('click', () => showFileExplorer('svg'));
  loadSvg.addEventListener('click', () => loadCurrentSvg());
  saveSvg.addEventListener('click', saveCurrentSvg);
  toggleSvgSource.addEventListener('click', toggleSvgView);
  copySvg.addEventListener('click', copySvgSource);
  fullscreenSvg.addEventListener('click', toggleSvgFullscreen);
  template.addEventListener('change', insertTemplate);
  autoRender.addEventListener('change', () => {
    queueSaveSession();
    if (autoRender.checked) queueRender();
  });
  theme.addEventListener('change', () => applyTheme(theme.value));
  if (themeMedia.addEventListener) {
    themeMedia.addEventListener('change', systemThemeChanged);
  } else {
    themeMedia.addListener(systemThemeChanged);
  }
  editor.onChange(editorChanged);
  editor.onKeydown(handleEditorKeydown);
  zoomOut.addEventListener('click', () => zoomAtCenter(1 / 1.25));
  zoomIn.addEventListener('click', () => zoomAtCenter(1.25));
  fullscreenZoomOut.addEventListener(
    'click',
    () => zoomAtCenter(1 / 1.25)
  );
  fullscreenZoomIn.addEventListener('click', () => zoomAtCenter(1.25));
  fit.addEventListener('click', fitToWindow);
  resetView.addEventListener('click', resetGraphView);
  help.addEventListener('click', openHelp);
  closeHelp.addEventListener('click', closeHelpTab);
  docsHelpLinks.forEach((link) => {
    link.addEventListener('click', (event) => {
      event.preventDefault();
      openDocsTab(link.textContent.trim(), link.dataset.docPath);
    });
  });
  for (const tab of [dotFilesTab, svgFilesTab]) {
    tab.addEventListener('click', () => {
      setExplorerView(tab.dataset.explorerView);
    });
    tab.addEventListener('keydown', explorerTabKeydown);
  }
  fileContextOpen.addEventListener('click', openContextFile);
  fileContextDelete.addEventListener('click', deleteContextFile);
  fileContextMenu.addEventListener('keydown', fileContextKeydown);
  closeClayError.addEventListener('click', hideClayError);
  clayErrorModal.addEventListener('click', (event) => {
    if (event.target === clayErrorModal) hideClayError();
  });
  clearSelection.addEventListener('click', () => {
    clearVisualSelection();
    preview.focus();
  });

  preview.addEventListener('click', (event) => {
    const group = visualGroup(event.target);
    if (group) {
      selectVisualElement(
        group,
        event.shiftKey || event.ctrlKey || event.metaKey
      );
    } else if (event.target === preview || event.target === currentSvg) {
      clearVisualSelection();
    }
  });

  preview.addEventListener('keydown', (event) => {
    const group = visualGroup(event.target);
    if (!group || (event.key !== 'Enter' && event.key !== ' ')) return;
    event.preventDefault();
    selectVisualElement(group, event.shiftKey);
  });

  preview.addEventListener('wheel', (event) => {
    if (!currentSvg) return;
    event.preventDefault();
    const bounds = preview.getBoundingClientRect();
    const pointerX = event.clientX - bounds.left;
    const pointerY = event.clientY - bounds.top;
    const graphX = (pointerX - view.x) / view.scale;
    const graphY = (pointerY - view.y) / view.scale;
    const nextScale = clamp(
      view.scale * Math.exp(-event.deltaY * 0.001),
      minScale,
      maxScale
    );
    view.x = pointerX - graphX * nextScale;
    view.y = pointerY - graphY * nextScale;
    view.scale = nextScale;
    applyView();
  }, {passive: false});

  preview.addEventListener('pointerdown', (event) => {
    if (!currentSvg || event.button !== 0) return;
    if (visualGroup(event.target)) return;
    event.preventDefault();
    panPoint = {x: event.clientX, y: event.clientY};
    preview.setPointerCapture(event.pointerId);
    preview.classList.add('is-panning');
  });

  preview.addEventListener('pointermove', (event) => {
    if (!panPoint || !preview.hasPointerCapture(event.pointerId)) return;
    view.x += event.clientX - panPoint.x;
    view.y += event.clientY - panPoint.y;
    panPoint = {x: event.clientX, y: event.clientY};
    applyView();
  });

  function endPan(event) {
    if (!preview.hasPointerCapture(event.pointerId)) return;
    preview.releasePointerCapture(event.pointerId);
    preview.classList.remove('is-panning');
    panPoint = undefined;
  }

  preview.addEventListener('pointerup', endPan);
  preview.addEventListener('pointercancel', endPan);

  explorerResizer.addEventListener('pointerdown', (event) => {
    if (matchMedia('(max-width: 760px)').matches) return;
    explorerResizer.setPointerCapture(event.pointerId);
  });

  explorerResizer.addEventListener('pointermove', (event) => {
    if (!explorerResizer.hasPointerCapture(event.pointerId)) return;
    const bounds = workbench.getBoundingClientRect();
    setExplorerWidth(event.clientX - bounds.left);
    queueSaveSession();
  });

  explorerResizer.addEventListener('keydown', (event) => {
    if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
    event.preventDefault();
    const change = event.key === 'ArrowLeft' ? -16 : 16;
    setExplorerWidth(currentExplorerWidth() + change);
    queueSaveSession();
  });

  splitter.addEventListener('pointerdown', (event) => {
    if (matchMedia('(max-width: 760px)').matches) return;
    splitter.setPointerCapture(event.pointerId);
  });

  splitter.addEventListener('pointermove', (event) => {
    if (!splitter.hasPointerCapture(event.pointerId)) return;
    const bounds = workspace.getBoundingClientRect();
    const percent = ((event.clientX - bounds.left) / bounds.width) * 100;
    const width = Math.max(25, Math.min(70, percent));
    workspace.style.setProperty('--editor-width', `${width}%`);
    queueSaveSession();
  });

  splitter.addEventListener('keydown', (event) => {
    if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
    event.preventDefault();
    const current = parseFloat(getComputedStyle(workspace)
      .getPropertyValue('--editor-width')) || 44;
    const change = event.key === 'ArrowLeft' ? -2 : 2;
    const width = Math.max(25, Math.min(70, current + change));
    workspace.style.setProperty('--editor-width', `${width}%`);
    queueSaveSession();
  });

  document.addEventListener('keydown', handleShortcut);
  document.addEventListener('click', (event) => {
    if (fileContextMenu.hidden || fileContextMenu.contains(event.target)) {
      return;
    }
    if (contextFileSource?.parentElement?.contains(event.target)) return;
    closeFileContext();
  });
  document.addEventListener('fullscreenchange', updateFullscreenControl);
  window.addEventListener('beforeunload', saveSession);
  window.addEventListener('resize', () => closeFileContext());
  const savedSession = loadSession();
  applyTheme(savedSession?.theme || 'system', false);
  let initialProblem = '';
  if (savedSession) {
    workspace.style.setProperty(
      '--editor-width',
      `${savedSession.paneWidth}%`
    );
    setExplorerWidth(savedSession.explorerWidth);
    docsTabs = savedSession.docsTabs;
    nextDocs = savedSession.nextDocs;
    explorerView = savedSession.explorerView;
    autoRender.checked = savedSession.autoRender;
    pendingView = savedSession.view;
  }
  renderDocsTabs();
  setExplorerView(explorerView);
  try {
    editor.setSource(
      sourceFromUrl() ?? savedSession?.source ?? starter,
      {notify: false}
    );
  } catch (cause) {
    editor.setSource(
      savedSession?.source ?? starter,
      {notify: false}
    );
    initialProblem = String(cause);
  }
  newNodeCategory.value = 'basic-shapes';
  populateNewNodeShapes();
  populateAttributeShapes();
  refreshFileTree('dot');
  refreshFileTree('svg');
  render();
  refreshHelpVariant();
  if (initialProblem) showClientProblem(initialProblem);
  '''
::
++  error-json
  |=  =err:gviz
  ^-  json
  ?-    -.err
      %parse
    %-  pairs:enjs:format
    :~  ['kind' s+'parse']
        ['line' n+(scot %ud line.err)]
        ['column' n+(scot %ud col.err)]
        ['message' s+msg.err]
    ==
  ::
      %unsupported-engine
    %-  pairs:enjs:format
    :~  ['kind' s+'unsupported-engine']
        ['engine' s+(scot %tas engine.err)]
        ['message' s+'unsupported engine']
    ==
  ::
      %unsupported-format
    %-  pairs:enjs:format
    :~  ['kind' s+'unsupported-format']
        ['format' s+(scot %tas format.err)]
        ['message' s+'unsupported format']
    ==
  ::
      %unsupported-feature
    %-  pairs:enjs:format
    ~[['kind' s+'unsupported-feature'] ['message' s+msg.err]]
  ::
      %layout
    %-  pairs:enjs:format
    ~[['kind' s+'layout'] ['message' s+msg.err]]
  ==
::
++  error-text
  |=  =err:gviz
  ^-  @t
  (en:json:html (error-json err))
--
