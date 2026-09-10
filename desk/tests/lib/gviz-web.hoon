::  Tests for /lib/gviz-web.
::
/-  gviz
/+  *test, web=gviz-web
|%
::
++  test-web-page
  =/  html  (trip page:web)
  =/  needles=(list tape)
    :~  "Graph Viz"
        "/apps/graph-viz/app.js"
        "/apps/graph-viz/ace/ace.js"
        "/apps/graph-viz/ace/graph-viz-config.js"
        "/apps/graph-viz/ace/mode-dot.js"
        "/apps/graph-viz/ace/theme-github.js"
        "/apps/graph-viz/ace/ext-beautify.js"
        "id=\"render\""
        "id=\"browse-dot\""
        "id=\"load-dot\""
        "id=\"save-dot\""
        "id=\"browse-svg\""
        "id=\"load-svg\""
        "id=\"save-svg\""
        "id=\"toggle-svg-source\""
        "Edit SVG"
        "id=\"copy-svg\""
        "id=\"fullscreen-svg\""
        "id=\"svg-source\""
        "id=\"auto-render\""
        "source-auto-render"
        "id=\"template\""
        "id=\"inspector\""
        "LLM skill files"
        "gviz-dot-syntax"
        "gviz-gall-api"
        "gviz-patterns"
        "DOT Syntax LLM Skill"
        "Gall API LLM Skill"
        "Common Patterns LLM Skill"
        "id=\"zoom-out\""
        "id=\"zoom-in\""
        "id=\"fullscreen-zoom-out\""
        "id=\"fullscreen-zoom-in\""
        "data-state=\"empty\""
    ==
  =/  missing=(list tape)
    :~  "<script src=\"http"
        "id=\"download\""
        "id=\"download-dot\""
        "id=\"file-browser-modal\""
        "id=\"share\""
    ==
  =/  present-tests=tang
    %-  zing
    %+  turn  needles
    |=  needle=tape
    (expect !>(?=(^ (find needle html))))
  =/  absent-tests=tang
    %-  zing
    %+  turn  missing
    |=  needle=tape
    (expect !>(?=(~ (find needle html))))
  (weld present-tests absent-tests)
::
++  test-theme-switcher
  =/  style  (trip css:web)
  ;:  weld
    (expect !>(?=(^ (find "var(--preview-background)" style))))
    (expect !>(?=(^ (find ".preview svg" style))))
    (expect !>(?=(^ (find "filter: invert(1) hue-rotate(180deg)" style))))
  ==
::
++  test-live-rendering
  =/  js  (trip javascript:web)
  ;:  weld
    (expect !>(?=(^ (find "setTimeout(render, renderDelay)" js))))
    (expect !>(?=(^ (find "uid !== latestRequestUid" js))))
    (expect !>(?=(^ (find "x-graph-viz-request" js))))
    (expect !>(?=(^ (find "problem.line" js))))
    (expect !>(?=(^ (find "problem.column" js))))
    (expect !>(?=(^ (find "Unsupported feature" js))))
    (expect !>(?=(^ (find "Layout error" js))))
    (expect !>(?=(^ (find "hasPreview ? 'ready' : 'empty'" js))))
  ==
::
++  test-safe-svg-controls
  =/  js  (trip javascript:web)
  ;:  weld
    (expect !>(?=(^ (find "new DOMParser()" js))))
    (expect !>(?=(^ (find "image/svg+xml" js))))
    (expect !>(?=(^ (find "document.importNode" js))))
    (expect !>(?=(^ (find "unsafe SVG response" js))))
    (expect !>(?=(^ (find ":scope > title" js))))
    (expect !>(?=(^ (find "fitToWindow" js))))
    (expect !>(?=(^ (find "zoomAtCenter" js))))
    (expect !>(?=(^ (find "addEventListener('wheel'" js))))
    (expect !>(?=(^ (find "addEventListener('pointermove'" js))))
    (expect !>(?=(^ (find "replaceChildren(svg)" js))))
  ==
::
++  test-editor-usability
  =/  html  (trip page:web)
  =/  js  (trip javascript:web)
  =/  html-needles=(list tape)
    :~  "id=\"dot\""
        "Select template…"
        "value=\"\" disabled=\"\" hidden=\"\""
        "value=\"flowchart\""
        "value=\"strict-digraph\""
        "value=\"state-machine\""
        "value=\"dependencies\""
        "value=\"clusters\""
    ==
  =/  js-needles=(list tape)
    :~  "strict digraph unique_edges"
        "last wins"
        "ace/mode/dot"
        "svgEditor.onChange(svgEditorChanged)"
        "problem.line"
        "problem.column"
        "loadCurrentSvg"
    ==
  =/  html-tests=tang
    %-  zing
    %+  turn  html-needles
    |=  needle=tape
    (expect !>(?=(^ (find needle html))))
  =/  js-tests=tang
    %-  zing
    %+  turn  js-needles
    |=  needle=tape
    (expect !>(?=(^ (find needle js))))
  ;:  weld
    html-tests
    (expect !>(?=(~ (find ">Templates<" html))))
    js-tests
  ==
::
++  test-persistence-export
  ::  Graph Viz's half of the session record is declared, not written:
  ::  the shared runtime reads these slots out of the emitted config.
  =/  js  (trip javascript:web)
  =/  needles=(list tape)
    :~  "\"storageKey\":\"graph-viz.session.v1\""
        "\"shareParam\":\{\"name\":\"dot\",\"max\":12288"
        "\"paramMax\":16384"
        "\"key\":\"dotTabs\""
        "\"key\":\"activeDotTabId\""
        "\"key\":\"svgTabs\""
        "\"key\":\"activeSvgTabId\""
        "\"key\":\"view\",\"kind\":null,\"owner\":\"app\""
        "\"key\":\"preferences.autoRender\",\"kind\":null"
    ==
  %-  zing
  %+  turn  needles
  |=  needle=tape
  (expect !>(?=(^ (find needle js))))
::
++  test-visual-selection
  =/  html  (trip page:web)
  =/  js  (trip javascript:web)
  ;:  weld
    (expect !>(?=(^ (find "id=\"inspector\"" html))))
    (expect !>(?=(^ (find "id=\"selection-kind\"" html))))
    (expect !>(?=(^ (find "id=\"selection-id\"" html))))
    (expect !>(?=(^ (find "id=\"clear-selection\"" html))))
    (expect !>(?=(^ (find ".is-selected" (trip css:web)))))
    (expect !>(?=(^ (find "dotStatements" js))))
    (expect !>(?=(^ (find "sourceRangeFor" js))))
    (expect !>(?=(^ (find "selectSourceStatement" js))))
    (expect !>(?=(^ (find "selectVisualElement" js))))
    (expect !>(?=(^ (find "aria-current" js))))
    (expect !>(?=(^ (find "tabindex" js))))
  ==
::
++  test-visual-editing
  =/  html  (trip page:web)
  =/  js  (trip javascript:web)
  ;:  weld
    (expect !>(?=(^ (find "id=\"new-node-name\"" html))))
    (expect !>(?=(^ (find "id=\"new-node-category\"" html))))
    (expect !>(?=(^ (find "id=\"new-node-shape\"" html))))
    (expect !>(?=(^ (find "id=\"add-node\"" html))))
    (expect !>(?=(^ (find "id=\"draw-edge\"" html))))
    (expect !>(?=(^ (find "id=\"attribute-form\"" html))))
    (expect !>(?=(^ (find "id=\"edge-controls\"" html))))
    (expect !>(?=(^ (find "id=\"attr-arrowhead\"" html))))
    (expect !>(?=(^ (find "id=\"attr-arrowtail\"" html))))
    (expect !>(?=(^ (find "id=\"attr-arrowsize\"" html))))
    (expect !>(?=(^ (find "id=\"attr-dir\"" html))))
    (expect !>(?=(^ (find "id=\"attr-minlen\"" html))))
    (expect !>(?=(^ (find "id=\"attr-weight\"" html))))
    (expect !>(?=(^ (find "id=\"attr-penwidth\"" html))))
    (expect !>(?=(^ (find "id=\"attr-fontname\"" html))))
    (expect !>(?=(^ (find "id=\"attr-fontsize\"" html))))
    (expect !>(?=(^ (find "id=\"attr-fontcolor\"" html))))
    (expect !>(?=(^ (find "id=\"attr-change-all\"" html))))
    (expect !>(?=(^ (find "id=\"attr-use-default\"" html))))
    (expect !>(?=(^ (find "#shape-control[hidden]" (trip css:web)))))
    (expect !>(?=(^ (find "id=\"delete-selection\"" html))))
    (expect !>(?=(^ (find "addVisualNode" js))))
    (expect !>(?=(^ (find "nodeShapeCategories" js))))
    (expect !>(?=(^ (find "populateNewNodeShapes" js))))
    (expect !>(?=(^ (find "populateAttributeShapes" js))))
    (expect !>(?=(^ (find "drawSelectedEdge" js))))
    (expect !>(?=(^ (find "deleteSelectedItem" js))))
    (expect !>(?=(^ (find "applySelectedAttributes" js))))
    (expect !>(?=(^ (find "changeAllAttributes" js))))
    (expect !>(?=(^ (find "addAttributeDefault" js))))
    (expect !>(?=(^ (find "readStatementAttributes" js))))
    (expect !>(?=(^ (find "insertRootStatement" js))))
    (expect !>(?=(^ (find "splitEdgeStatement" js))))
  ==
::
++  test-web-error-json
  =/  txt  (error-text:web [%parse 2 7 'bad "quote"\\line\0anext'])
  ;:  weld
    (expect !>(?=(^ (find "\"kind\":\"parse\"" (trip txt)))))
    (expect !>(?=(^ (find "\"line\":2" (trip txt)))))
    (expect !>(?=(^ (find "\"column\":7" (trip txt)))))
    (expect !>(?=(^ (find "bad \\\"quote\\\"\\\\line\\nnext" (trip txt)))))
  ==
--
