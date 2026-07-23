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
      ;style
        ;+  ;/  (trip css)
      ==
    ==
    ;body
      ;header.app-header
        ;div.brand
          ;span.eyebrow: Pure Hoon renderer
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
          ;button#reset-view
            =type      "button"
            =disabled  ""
            =title     "Reset view (Ctrl+1)"
            ;span: Reset
          ==
          ;button#fit
            =type      "button"
            =disabled  ""
            =title     "Fit graph (Ctrl+0)"
            ;span: Fit
          ==
          ;button#share(type "button", title "Copy shareable URL"): Share
          ;label.preference
            ;input#auto-render(type "checkbox", checked "");
            ;span: Auto-render
          ==
          ;button#help(type "button", aria-expanded "false"): Help
        ==
      ==
      ;main#workspace.workspace
        ;section#editor-pane.pane.editor-pane
          ;div.pane-header
            ;h2: DOT source
            ;div.file-actions(aria-label "DOT file controls")
              ;button#browse-dot(type "button"): Browse
              ;button#load-dot(type "button"): Load DOT
              ;button#save-dot(type "button"): Save DOT
            ==
            ;span#source-status.status: Ready
          ==
          ;div.visual-tools(aria-label "Visual editing tools")
            ;label.control
              ;span: Node name
              ;input#new-node-name(type "text", placeholder "new_node");
            ==
            ;label.control
              ;span: Shape
              ;select#new-node-shape
                ;option(value "box"): Box
                ;option(value "ellipse"): Ellipse
                ;option(value "circle"): Circle
                ;option(value "diamond"): Diamond
                ;option(value "point"): Point
              ==
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
                ==
              ==
              ;button#apply-attributes(type "submit"): Apply
            ==
          ==
          ;div#preview-shell.preview-shell(data-state "empty")
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
          ==
        ==
      ==
      ;aside#help-panel.help-panel(hidden "", aria-label "Help")
        ;div.help-card
          ;div.pane-header
            ;h2: Editor help
            ;button#close-help(type "button", aria-label "Close help"): Close
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
        ==
      ==
      ;aside#file-browser-modal.help-panel
        =hidden      ""
        =role        "dialog"
        =aria-modal  "true"
        =aria-labelledby  "file-browser-title"
        ;div.help-card.file-browser-card
          ;div.pane-header
            ;h2#file-browser-title: Clay files
            ;button#close-file-browser
              =type        "button"
              =aria-label  "Close file browser"
              ;span: Close
            ==
          ==
          ;div#file-browser-tree.file-browser-tree
            =role        "tree"
            =aria-label  "Available Clay files"
            ;p: Loading…
          ==
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
++  css
  ^-  @t
  '''
  :root {
    color-scheme: light dark;
    --background: #f4f4f5;
    --surface: #ffffff;
    --border: #d4d4d8;
    --ink: #18181b;
    --muted: #71717a;
    --accent: #2563eb;
    --danger: #b91c1c;
    --editor-width: 44%;
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
  button:focus-visible { outline: 3px solid #93c5fd; }
  button:disabled { cursor: not-allowed; opacity: 0.45; }

  .primary {
    background: var(--accent);
    border-color: var(--accent);
    color: #ffffff;
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

  .visual-tools {
    align-items: end;
    border-bottom: 1px solid var(--border);
    display: grid;
    gap: 0.5rem;
    grid-template-columns: minmax(8rem, 1fr) auto auto auto;
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

  .preference {
    align-items: center;
    display: inline-flex;
    gap: 0.4rem;
  }

  .preference input { accent-color: var(--accent); }

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
    background: #f4f4f5;
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
    background: #fee2e2;
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
    background-image: linear-gradient(#fef2f2, #fef2f2);
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
    background-color: #ffffff;
    background-image: radial-gradient(#d4d4d8 0.8px, transparent 0.8px);
    background-size: 18px 18px;
    flex: 1;
    min-height: 0;
    overflow: hidden;
    position: relative;
  }

  .preview {
    cursor: grab;
    inset: 0;
    overflow: hidden;
    position: absolute;
    touch-action: none;
  }

  .preview.is-panning { cursor: grabbing; }

  .preview svg {
    display: block;
    max-width: none;
    position: absolute;
    transform-origin: 0 0;
    user-select: none;
  }

  .preview .node, .preview .edge {
    cursor: pointer;
    transition: filter 120ms ease;
  }

  .preview .node:hover, .preview .edge:hover,
  .preview .node:focus-visible, .preview .edge:focus-visible {
    filter: drop-shadow(0 0 3px #2563eb);
  }

  .preview .node.is-selected, .preview .edge.is-selected {
    filter: drop-shadow(0 0 2px #f59e0b)
      drop-shadow(0 0 5px #f59e0b);
  }

  .state-panel {
    align-content: center;
    color: #52525b;
    display: none;
    inset: 0;
    justify-items: center;
    padding: 2rem;
    position: absolute;
    text-align: center;
    z-index: 1;
  }

  .state-panel p { margin: 0.25rem; }
  .state-title { color: #27272a; font-weight: 650; }

  [data-state='empty'] #empty-state,
  [data-state='loading'] #loading-state,
  [data-state='disconnected'] #disconnected-state { display: grid; }

  [data-state='empty'] .preview,
  [data-state='loading'] .preview,
  [data-state='disconnected'] .preview { visibility: hidden; }

  .spinner {
    animation: spin 0.8s linear infinite;
    border: 3px solid #bfdbfe;
    border-radius: 50%;
    border-top-color: var(--accent);
    height: 2rem;
    width: 2rem;
  }

  @keyframes spin { to { transform: rotate(360deg); } }

  .error {
    background: #fef2f2;
    border-bottom: 1px solid #fecaca;
    color: var(--danger);
    margin: 0;
    padding: 0.75rem;
    white-space: pre-wrap;
  }

  .inspector {
    background: #fffbeb;
    border-bottom: 1px solid #fde68a;
    color: #78350f;
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

  .help-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 0.75rem;
    box-shadow: 0 1rem 3rem rgb(0 0 0 / 0.2);
    max-width: 32rem;
    padding: 0 1rem 1rem;
    width: 100%;
  }

  .shortcut-list { line-height: 1.8; padding-left: 1.5rem; }

  .file-browser-card { max-width: 40rem; }

  .file-browser-tree {
    max-height: 60vh;
    min-height: 8rem;
    overflow: auto;
    padding: 0.75rem 0;
  }

  .file-tree-list {
    list-style: none;
    margin: 0;
    padding-left: 1.25rem;
  }

  .file-browser-tree > .file-tree-list { padding-left: 0; }

  .file-tree-directory {
    color: var(--muted);
    padding: 0.2rem 0;
  }

  .file-tree-file {
    background: transparent;
    border: 0;
    color: var(--accent);
    padding: 0.3rem 0.5rem;
    text-align: left;
    width: 100%;
  }

  .file-tree-file:hover:not(:disabled) { background: var(--background); }

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

    .workspace {
      grid-template-columns: minmax(0, 1fr);
      grid-template-rows: minmax(18rem, 45vh) minmax(20rem, 55vh);
      overflow: visible;
    }

    .splitter { display: none; }
    .preview-pane { border-top: 1px solid var(--border); }
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
  const attrLabel = document.querySelector('#attr-label');
  const attrShape = document.querySelector('#attr-shape');
  const attrColor = document.querySelector('#attr-color');
  const attrFillcolor = document.querySelector('#attr-fillcolor');
  const attrStyle = document.querySelector('#attr-style');
  const newNodeName = document.querySelector('#new-node-name');
  const newNodeShape = document.querySelector('#new-node-shape');
  const addNode = document.querySelector('#add-node');
  const drawEdge = document.querySelector('#draw-edge');
  const preview = document.querySelector('#preview');
  const previewShell = document.querySelector('#preview-shell');
  const renderStatus = document.querySelector('#render-status');
  const sourceStatus = document.querySelector('#source-status');
  const resetView = document.querySelector('#reset-view');
  const browseDot = document.querySelector('#browse-dot');
  const loadDot = document.querySelector('#load-dot');
  const saveDot = document.querySelector('#save-dot');
  const browseSvg = document.querySelector('#browse-svg');
  const loadSvg = document.querySelector('#load-svg');
  const saveSvg = document.querySelector('#save-svg');
  const fit = document.querySelector('#fit');
  const share = document.querySelector('#share');
  const autoRender = document.querySelector('#auto-render');
  const help = document.querySelector('#help');
  const helpPanel = document.querySelector('#help-panel');
  const closeHelp = document.querySelector('#close-help');
  const fileBrowserModal = document.querySelector('#file-browser-modal');
  const fileBrowserTitle = document.querySelector('#file-browser-title');
  const fileBrowserTree = document.querySelector('#file-browser-tree');
  const closeFileBrowser = document.querySelector('#close-file-browser');
  const clayErrorModal = document.querySelector('#clay-error-modal');
  const clayErrorMessage = document.querySelector('#clay-error-message');
  const closeClayError = document.querySelector('#close-clay-error');
  const workspace = document.querySelector('#workspace');
  const splitter = document.querySelector('#splitter');
  const renderDelay = 350;
  const saveDelay = 150;
  const minScale = 0.05;
  const maxScale = 32;
  const maxSourceBytes = 256 * 1024;
  const maxSharedSourceBytes = 12 * 1024;
  const maxShareParamChars = 16 * 1024;
  const storageKey = 'graph-viz.session.v1';
  let requestUid = 0;
  let latestRequestUid = 0;
  let renderTimer;
  let saveTimer;
  let currentSvg;
  let graphSize = {width: 1, height: 1};
  let view = {scale: 1, x: 0, y: 0};
  let panPoint;
  let errorLine = 0;
  let lastSvgSource = '';
  let pendingView;
  let selectedItems = [];

  function setState(state, label) {
    previewShell.dataset.state = state;
    renderStatus.textContent = label;
  }

  function setPreviewControls(enabled) {
    resetView.disabled = !enabled;
    saveSvg.disabled = !enabled;
    fit.disabled = !enabled;
  }

  function showHelp(open) {
    helpPanel.hidden = !open;
    help.setAttribute('aria-expanded', String(open));
    if (open) closeHelp.focus();
  }

  function showClayError(cause) {
    clayErrorMessage.textContent = String(cause);
    clayErrorModal.hidden = false;
    closeClayError.focus();
  }

  function hideClayError() {
    clayErrorModal.hidden = true;
  }

  function hideFileBrowser() {
    fileBrowserModal.hidden = true;
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
    fileBrowserTree.textContent = '';
    if (!root.size) {
      fileBrowserTree.textContent =
        `No /${kind === 'dot' ? 'txt' : 'svg'} files found.`;
      return;
    }
    function appendFile(item, label, path) {
      const file = document.createElement('button');
      file.type = 'button';
      file.className = 'file-tree-file';
      file.dataset.path = path;
      file.textContent = label;
      file.addEventListener('click', async () => {
        hideFileBrowser();
        if (kind === 'dot') {
          await loadCurrentDot(path);
        } else {
          await loadCurrentSvg(path);
        }
      });
      item.append(file);
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
    fileBrowserTree.append(renderBranch(root));
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

  async function browseClayFiles(kind) {
    fileBrowserTitle.textContent =
      `${kind === 'dot' ? 'DOT' : 'SVG'} files`;
    fileBrowserTree.textContent = 'Loading…';
    fileBrowserModal.hidden = false;
    closeFileBrowser.focus();
    try {
      renderFileTree(await browseClayNode(kind), kind);
    } catch (cause) {
      hideFileBrowser();
      showClayError(cause);
    }
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

  function loadSession() {
    try {
      const saved = JSON.parse(localStorage.getItem(storageKey));
      if (!saved || saved.version !== 1) return undefined;
      const source = validateSource(saved.source);
      const paneWidth = Number(saved.paneWidth);
      const preferences = saved.preferences || {};
      return {
        source,
        paneWidth: Number.isFinite(paneWidth)
          ? clamp(paneWidth, 25, 70)
          : 44,
        view: validView(saved.view),
        autoRender: preferences.autoRender !== false
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

  function saveSession() {
    clearTimeout(saveTimer);
    try {
      validateSource(dot.value);
      localStorage.setItem(storageKey, JSON.stringify({
        version: 1,
        source: dot.value,
        paneWidth: currentPaneWidth(),
        view,
        preferences: {autoRender: autoRender.checked}
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

  function syncEditorScroll() {
    lineNumbers.scrollTop = dot.scrollTop;
    if (!errorLine) return;
    const style = getComputedStyle(dot);
    const lineHeight = parseFloat(style.lineHeight);
    const paddingTop = parseFloat(style.paddingTop);
    const top = paddingTop + (errorLine - 1) * lineHeight - dot.scrollTop;
    dot.style.setProperty('--error-line-top', `${top}px`);
  }

  function updateLineNumbers() {
    const count = dot.value.split('\n').length;
    const numbers = document.createDocumentFragment();
    for (let number = 1; number <= count; number += 1) {
      const item = document.createElement('span');
      item.textContent = String(number);
      if (number === errorLine) item.className = 'error-line';
      numbers.append(item);
    }
    lineNumbers.replaceChildren(numbers);
    syncEditorScroll();
  }

  function setErrorLine(line) {
    errorLine = Number.isFinite(line) && line > 0 ? line : 0;
    dot.classList.toggle('has-error-line', errorLine > 0);
    updateLineNumbers();
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
        nested
      };
    }
    const id = parseDotId(tokens, cursor);
    if (!id) return undefined;
    cursor = id.next;
    for (let port = 0; port < 2 && tokens[cursor]?.value === ':'; port += 1) {
      const part = parseDotId(tokens, cursor + 1);
      if (!part) break;
      cursor = part.next;
    }
    return {values: [id.value], next: cursor, nested: []};
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
    const nodeNames = new Set(first.values);
    let left = first.values;
    while (tokens[cursor]?.type === 'edge') {
      const operator = tokens[cursor].value;
      const right = parseDotEndpoint(tokens, cursor + 1, limit);
      if (!right) break;
      nested.push(...right.nested);
      for (const tail of left) {
        for (const head of right.values) {
          edges.push(tail + operator + head);
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
    dot.value = source;
    editorChanged();
    renderNow();
  }

  function mutationProblem(cause) {
    showClientProblem(cause instanceof Error ? cause.message : String(cause));
  }

  function addVisualNode() {
    try {
      const identity = newNodeName.value.trim();
      const id = dotIdSource(identity);
      const shape = newNodeShape.value;
      const shapes = ['box', 'ellipse', 'circle', 'diamond', 'point'];
      if (!shapes.includes(shape)) throw new Error('Unsupported node shape');
      const exists = dotStatements(dot.value).some((statement) => {
        return statement.nodeNames.includes(identity);
      });
      if (exists) throw new Error('A node with that name already exists');
      const source = insertRootStatement(
        dot.value,
        `${id} [shape=${shape}]`
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
      const body = graphBody(dot.value);
      const [tail, head] = selectedItems.map((item) => item.identity);
      const identity = tail + body.operator + head;
      const exists = dotStatements(dot.value).some((statement) => {
        return statement.edges.includes(identity);
      });
      if (exists) throw new Error('That edge already exists');
      const edge = `${dotIdSource(tail)} ${body.operator} ${dotIdSource(head)}`;
      applyVisualMutation(insertRootStatement(dot.value, edge));
    } catch (cause) {
      mutationProblem(cause);
    }
  }

  function statementRemovalRange(statement) {
    const lineStart = dot.value.lastIndexOf('\n', statement.start - 1) + 1;
    const nextLine = dot.value.indexOf('\n', statement.end);
    const lineEnd = nextLine < 0 ? dot.value.length : nextLine + 1;
    const before = dot.value.slice(lineStart, statement.start).trim();
    const afterEnd = nextLine < 0 ? dot.value.length : nextLine;
    const after = dot.value.slice(statement.end, afterEnd).trim();
    if (!before && !after) return {start: lineStart, end: lineEnd};
    return {start: statement.start, end: statement.end};
  }

  function removeStatementRanges(source, statements) {
    const ordered = statements.map(statementRemovalRange)
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
      const statements = dotStatements(dot.value);
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
      applyVisualMutation(removeStatementRanges(dot.value, removals));
    } catch (cause) {
      mutationProblem(cause);
    }
  }

  function editableStatement(kind, identity) {
    const statements = dotStatements(dot.value);
    if (kind === 'edge') {
      const statement = statements.find((candidate) => {
        return candidate.edges.includes(identity);
      });
      if (statement && statement.edges.length !== 1) return undefined;
      return statement;
    }
    const matches = statements.filter((statement) => {
      return statement.kind === 'node'
        && statement.nodeNames.length === 1
        && statement.nodeNames[0] === identity;
    });
    return matches.at(-1);
  }

  function readStatementAttributes(statement) {
    if (!statement) return {base: '', semicolon: false, attributes: new Map()};
    const segment = dot.value.slice(statement.start, statement.end);
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
    const statement = editableStatement(selected.kind, selected.identity);
    if (selected.kind === 'edge' && !statement) {
      attributeForm.hidden = true;
      sourceStatus.textContent = 'Edit chains and grouped edges in DOT';
      return;
    }
    try {
      const parsed = readStatementAttributes(statement);
      const get = (name) => parsed.attributes.get(name)?.value || '';
      const styles = get('style').split(',').map((value) => value.trim());
      attrLabel.value = get('label');
      attrColor.value = get('color');
      attrStyle.value = ['solid', 'dashed', 'dotted', 'bold']
        .find((style) => styles.includes(style)) || '';
      const isNode = selected.kind === 'node';
      shapeControl.hidden = !isNode;
      fillControl.hidden = !isNode;
      attrShape.value = isNode ? get('shape') : '';
      attrFillcolor.value = isNode ? get('fillcolor') : '';
    } catch (cause) {
      attributeForm.hidden = true;
      sourceStatus.textContent = cause.message;
    }
  }

  function applySelectedAttributes(event) {
    event.preventDefault();
    try {
      if (selectedItems.length !== 1) {
        throw new Error('Select one node or edge to edit');
      }
      const selected = selectedItems[0];
      const statement = editableStatement(selected.kind, selected.identity);
      if (selected.kind === 'edge' && !statement) {
        throw new Error('Edit edge chains or grouped edges in DOT');
      }
      const parsed = statement
        ? readStatementAttributes(statement)
        : {
            base: dotIdSource(selected.identity),
            semicolon: false,
            attributes: new Map()
          };
      const label = attrLabel.value;
      const color = attrColor.value.trim();
      const fillcolor = attrFillcolor.value.trim();
      const shape = attrShape.value;
      const lineStyle = attrStyle.value;
      const shapes = ['', 'box', 'ellipse', 'circle', 'diamond', 'point'];
      const lineStyles = ['', 'solid', 'dashed', 'dotted', 'bold'];
      if (!validColor(color) || !validColor(fillcolor)) {
        throw new Error('Colors must be names or six-digit hex values');
      }
      if (!shapes.includes(shape) || !lineStyles.includes(lineStyle)) {
        throw new Error('Unsupported shape or line style');
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
      if (selected.kind === 'node') controlled.add('filled');
      const styles = oldStyles.filter((style) => !controlled.has(style));
      if (lineStyle) styles.push(lineStyle);
      if (selected.kind === 'node') {
        const hadFillcolor = parsed.attributes.has('fillcolor');
        const keepFilled = fillcolor
          || (oldStyles.includes('filled') && !hadFillcolor);
        if (keepFilled) styles.push('filled');
        setParsedAttribute(
          parsed,
          'shape',
          shape || undefined,
          shape
        );
        setParsedAttribute(
          parsed,
          'fillcolor',
          fillcolor ? dotValueSource(fillcolor, 40) : undefined,
          fillcolor
        );
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
      const replacement = writeStatementAttributes(parsed);
      const source = statement
        ? dot.value.slice(0, statement.start)
          + replacement
          + dot.value.slice(statement.end)
        : insertRootStatement(dot.value, replacement);
      applyVisualMutation(source);
    } catch (cause) {
      mutationProblem(cause);
    }
  }

  function sourceRangeFor(kind, identity) {
    const statements = dotStatements(dot.value);
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
    dot.focus();
    dot.setSelectionRange(range.start, range.end);
    const line = dot.value.slice(0, range.start).split('\n').length;
    const lineHeight = parseFloat(getComputedStyle(dot).lineHeight);
    dot.scrollTop = Math.max(0, (line - 2) * lineHeight);
    syncEditorScroll();
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
      || selectedItems.some((item) => item.kind !== 'node')
      || selectedItems.length >= 2) {
      clearVisualSelection();
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
    requestedPath
  ) {
    const path = requestedPath === undefined
      ? requestClayPath(kind.toUpperCase())
      : normalizeClayPath(requestedPath);
    if (path === undefined) return undefined;
    const response = await fetch(
      `/apps/graph-viz/file/${kind}/${action}`,
      {
        method: 'POST',
        headers: {
          'content-type': 'text/plain; charset=utf-8',
          'x-graph-viz-path': path
        },
        body: source
      }
    );
    const body = await response.text();
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
      dot.value = source;
      editorChanged();
    } catch (cause) {
      showClayError(cause);
      showClientProblem(String(cause));
    } finally {
      sourceStatus.textContent = 'Ready';
    }
  }

  async function saveCurrentDot() {
    try {
      validateSource(dot.value);
      sourceStatus.textContent = 'Saving';
      const result = await clayFileRequest('dot', 'save', dot.value);
      sourceStatus.textContent = result === undefined ? 'Ready' : 'Saved';
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
      lastSvgSource = source;
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
    } catch (cause) {
      showClayError(cause);
      error.textContent = String(cause);
      error.hidden = false;
      setState('ready', 'Save failed');
    }
  }

  async function copyShareUrl() {
    try {
      validateSource(dot.value, maxSharedSourceBytes);
      const url = new URL(window.location.href);
      url.searchParams.set('dot', encodeSource(dot.value));
      if (url.href.length > maxShareParamChars) {
        throw new Error('Share URL exceeds the size limit');
      }
      if (navigator.clipboard && navigator.clipboard.writeText) {
        await navigator.clipboard.writeText(url.href);
        sourceStatus.textContent = 'Share URL copied';
      } else {
        window.prompt('Copy share URL', url.href);
      }
    } catch (cause) {
      showClientProblem(String(cause));
    }
  }

  function handleTab(event) {
    event.preventDefault();
    const indent = '  ';
    const start = dot.selectionStart;
    const end = dot.selectionEnd;
    if (start === end && !event.shiftKey) {
      dot.setRangeText(indent, start, end, 'end');
      editorChanged();
      return;
    }
    const lineStart = dot.value.lastIndexOf('\n', start - 1) + 1;
    if (start === end) {
      const match = dot.value.slice(lineStart, lineStart + 2).match(/^ {1,2}/);
      if (!match) return;
      dot.setRangeText('', lineStart, lineStart + match[0].length, 'end');
      const cursor = Math.max(lineStart, start - match[0].length);
      dot.setSelectionRange(cursor, cursor);
      editorChanged();
      return;
    }
    const block = dot.value.slice(lineStart, end);
    const replacement = block.split('\n').map((line) => {
      return event.shiftKey ? line.replace(/^ {1,2}/, '') : indent + line;
    }).join('\n');
    dot.setRangeText(replacement, lineStart, end, 'select');
    dot.setSelectionRange(lineStart, lineStart + replacement.length);
    editorChanged();
  }

  function handleEditorKeydown(event) {
    if (event.key === 'Tab') {
      handleTab(event);
      return;
    }
    if (event.ctrlKey || event.metaKey || event.altKey) return;
    const pairs = {'{': '}', '[': ']', '(': ')', '"': '"'};
    const closers = Object.values(pairs);
    const start = dot.selectionStart;
    const end = dot.selectionEnd;
    if (start === end && closers.includes(event.key)
      && dot.value[start] === event.key) {
      event.preventDefault();
      dot.setSelectionRange(start + 1, start + 1);
      return;
    }
    const closing = pairs[event.key];
    const escapedQuote = event.key === '"' && dot.value[start - 1] === '\\';
    if (!closing || escapedQuote) return;
    event.preventDefault();
    const selected = dot.value.slice(start, end);
    dot.setRangeText(event.key + selected + closing, start, end, 'select');
    dot.setSelectionRange(start + 1, end + 1);
    editorChanged();
  }

  function insertTemplate() {
    const source = templates[template.value];
    if (!source) return;
    dot.value = source;
    template.value = '';
    dot.focus();
    dot.setSelectionRange(0, 0);
    editorChanged();
  }

  function handleShortcut(event) {
    if (event.key === 'Escape' && !clayErrorModal.hidden) {
      event.preventDefault();
      hideClayError();
      return;
    }
    if (event.key === 'Escape' && !fileBrowserModal.hidden) {
      event.preventDefault();
      hideFileBrowser();
      return;
    }
    if (event.key === 'Escape' && !helpPanel.hidden) {
      event.preventDefault();
      showHelp(false);
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
    try {
      validateSource(dot.value);
    } catch (cause) {
      showClientProblem(String(cause));
      sourceStatus.textContent = 'Too large';
      button.disabled = false;
      return;
    }
    if (!dot.value.trim()) {
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
        body: dot.value
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
      lastSvgSource = body;
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
  newNodeName.addEventListener('keydown', (event) => {
    if (event.key !== 'Enter') return;
    event.preventDefault();
    addVisualNode();
  });
  browseDot.addEventListener('click', () => browseClayFiles('dot'));
  loadDot.addEventListener('click', () => loadCurrentDot());
  saveDot.addEventListener('click', saveCurrentDot);
  browseSvg.addEventListener('click', () => browseClayFiles('svg'));
  loadSvg.addEventListener('click', () => loadCurrentSvg());
  saveSvg.addEventListener('click', saveCurrentSvg);
  share.addEventListener('click', copyShareUrl);
  template.addEventListener('change', insertTemplate);
  autoRender.addEventListener('change', () => {
    queueSaveSession();
    if (autoRender.checked) queueRender();
  });
  dot.addEventListener('input', editorChanged);
  dot.addEventListener('keydown', handleEditorKeydown);
  dot.addEventListener('scroll', syncEditorScroll);
  fit.addEventListener('click', fitToWindow);
  resetView.addEventListener('click', resetGraphView);
  help.addEventListener('click', () => showHelp(helpPanel.hidden));
  closeHelp.addEventListener('click', () => showHelp(false));
  closeFileBrowser.addEventListener('click', hideFileBrowser);
  fileBrowserModal.addEventListener('click', (event) => {
    if (event.target === fileBrowserModal) hideFileBrowser();
  });
  closeClayError.addEventListener('click', hideClayError);
  clayErrorModal.addEventListener('click', (event) => {
    if (event.target === clayErrorModal) hideClayError();
  });
  helpPanel.addEventListener('click', (event) => {
    if (event.target === helpPanel) showHelp(false);
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
  window.addEventListener('beforeunload', saveSession);
  const savedSession = loadSession();
  let initialProblem = '';
  if (savedSession) {
    workspace.style.setProperty(
      '--editor-width',
      `${savedSession.paneWidth}%`
    );
    autoRender.checked = savedSession.autoRender;
    pendingView = savedSession.view;
  }
  try {
    dot.value = sourceFromUrl() ?? savedSession?.source ?? starter;
  } catch (cause) {
    dot.value = savedSession?.source ?? starter;
    initialProblem = String(cause);
  }
  updateLineNumbers();
  render();
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
