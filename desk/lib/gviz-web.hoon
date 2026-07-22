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
            ;option(value ""): Templates
            ;option(value "flowchart"): Flowchart
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
          ;button#download-dot
            =type   "button"
            =title  "Download DOT (Ctrl+S)"
            ;span: Download DOT
          ==
          ;button#download
            =type      "button"
            =disabled  ""
            =title     "Download SVG (Ctrl+Shift+S)"
            ;span: Download SVG
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
            ;span#source-status.status: Ready
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
            ;span#render-status.status: Empty
          ==
          ;pre#error.error(hidden "", role "alert");
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
            ;div#preview.preview(aria-live "polite");
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
            ;li: Ctrl/Cmd + S: download DOT
            ;li: Ctrl/Cmd + Shift + S: download SVG
            ;li: Ctrl/Cmd + 0: fit graph
            ;li: Ctrl/Cmd + 1: reset graph view
            ;li: Tab / Shift + Tab: indent / unindent
          ==
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

  button, select, .preference {
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
  .status { color: var(--muted); font-size: 0.75rem; }

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
  const preview = document.querySelector('#preview');
  const previewShell = document.querySelector('#preview-shell');
  const renderStatus = document.querySelector('#render-status');
  const sourceStatus = document.querySelector('#source-status');
  const resetView = document.querySelector('#reset-view');
  const downloadDot = document.querySelector('#download-dot');
  const download = document.querySelector('#download');
  const fit = document.querySelector('#fit');
  const share = document.querySelector('#share');
  const autoRender = document.querySelector('#auto-render');
  const help = document.querySelector('#help');
  const helpPanel = document.querySelector('#help-panel');
  const closeHelp = document.querySelector('#close-help');
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

  function setState(state, label) {
    previewShell.dataset.state = state;
    renderStatus.textContent = label;
  }

  function setPreviewControls(enabled) {
    resetView.disabled = !enabled;
    download.disabled = !enabled;
    fit.disabled = !enabled;
  }

  function showHelp(open) {
    helpPanel.hidden = !open;
    help.setAttribute('aria-expanded', String(open));
    if (open) closeHelp.focus();
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

  function editorChanged() {
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

  function downloadSource(source, filename, type) {
    const blob = new Blob([source], {type});
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = filename;
    anchor.click();
    setTimeout(() => URL.revokeObjectURL(url), 0);
  }

  function downloadCurrentDot() {
    downloadSource(dot.value, 'graph.dot', 'text/vnd.graphviz;charset=utf-8');
  }

  function downloadCurrentSvg() {
    if (!lastSvgSource) return;
    downloadSource(lastSvgSource, 'graph.svg', 'image/svg+xml');
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
    if (event.key === 'Escape' && !helpPanel.hidden) {
      event.preventDefault();
      showHelp(false);
      help.focus();
      return;
    }
    if (!event.ctrlKey && !event.metaKey) return;
    if (event.key === 'Enter') {
      event.preventDefault();
      renderNow();
    } else if (event.key.toLowerCase() === 's') {
      event.preventDefault();
      if (event.shiftKey) {
        downloadCurrentSvg();
      } else {
        downloadCurrentDot();
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
  downloadDot.addEventListener('click', downloadCurrentDot);
  download.addEventListener('click', downloadCurrentSvg);
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
  helpPanel.addEventListener('click', (event) => {
    if (event.target === helpPanel) showHelp(false);
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
