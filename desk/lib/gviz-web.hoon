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
          ;button#render.primary(type "button"): Render
          ;button#reset-view(type "button", disabled ""): Reset
          ;button#download(type "button", disabled ""): Download SVG
          ;button#fit(type "button", disabled ""): Fit
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
          ;textarea#dot
            =spellcheck  "false"
            =aria-label  "DOT source"
            ;+  ;/  (trip 'digraph { a -> b }')
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

  button {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 0.4rem;
    color: inherit;
    cursor: pointer;
    font: inherit;
    padding: 0.5rem 0.75rem;
  }

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
  }

  #dot:focus { box-shadow: inset 0 0 0 2px var(--accent); }

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
  const starter = ['digraph {', '  a -> b', '}'].join('\\n');
  const dot = document.querySelector('#dot');
  const button = document.querySelector('#render');
  const error = document.querySelector('#error');
  const preview = document.querySelector('#preview');
  const previewShell = document.querySelector('#preview-shell');
  const renderStatus = document.querySelector('#render-status');
  const sourceStatus = document.querySelector('#source-status');
  const resetView = document.querySelector('#reset-view');
  const download = document.querySelector('#download');
  const fit = document.querySelector('#fit');
  const help = document.querySelector('#help');
  const helpPanel = document.querySelector('#help-panel');
  const closeHelp = document.querySelector('#close-help');
  const workspace = document.querySelector('#workspace');
  const splitter = document.querySelector('#splitter');
  const renderDelay = 350;
  const minScale = 0.05;
  const maxScale = 32;
  let requestUid = 0;
  let latestRequestUid = 0;
  let renderTimer;
  let currentSvg;
  let graphSize = {width: 1, height: 1};
  let view = {scale: 1, x: 0, y: 0};
  let panPoint;

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
    error.textContent = formatProblem(problem);
    error.hidden = false;
    const hasPreview = Boolean(preview.querySelector('svg'));
    setState(hasPreview ? 'ready' : 'empty', 'Render failed');
  }

  function clamp(value, minimum, maximum) {
    return Math.max(minimum, Math.min(maximum, value));
  }

  function applyView() {
    if (!currentSvg) return;
    const transform = `translate(${view.x}px, ${view.y}px) `
      + `scale(${view.scale})`;
    currentSvg.style.transform = transform;
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
    requestAnimationFrame(fitToWindow);
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

  async function render() {
    const uid = latestRequestUid = ++requestUid;
    if (!dot.value.trim()) {
      preview.replaceChildren();
      currentSvg = undefined;
      error.hidden = true;
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
  dot.addEventListener('input', queueRender);
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
  });

  splitter.addEventListener('keydown', (event) => {
    if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
    event.preventDefault();
    const current = parseFloat(getComputedStyle(workspace)
      .getPropertyValue('--editor-width')) || 44;
    const change = event.key === 'ArrowLeft' ? -2 : 2;
    const width = Math.max(25, Math.min(70, current + change));
    workspace.style.setProperty('--editor-width', `${width}%`);
  });

  dot.value = starter;
  render();
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
