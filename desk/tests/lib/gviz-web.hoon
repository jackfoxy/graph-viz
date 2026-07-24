::  Tests for /lib/gviz-web.
::
/-  gviz
/+  *test, web=gviz-web
|%
::
++  test-web-page
  =/  html  page:web
  ;:  weld
    (expect !>(?=(^ (find "Graph Viz" (trip html)))))
    (expect !>(?=(^ (find "/apps/graph-viz/app.js" (trip html)))))
    (expect !>(?=(^ (find "id=\"workspace\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"splitter\"" (trip html)))))
    (expect !>(?=(~ (find "id=\"download\"" (trip html)))))
    (expect !>(?=(~ (find "id=\"download-dot\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"browse-dot\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"load-dot\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"save-dot\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"browse-svg\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"load-svg\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"save-svg\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"file-browser-modal\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"file-browser-tree\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"clay-error-modal\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"clay-error-message\"" (trip html)))))
    (expect !>(?=(~ (find "id=\"share\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"auto-render\"" (trip html)))))
    (expect !>(?=(^ (find "id=\"help\"" (trip html)))))
    (expect !>(?=(^ (find "data-state=\"empty\"" (trip html)))))
  ==
::
++  test-responsive-shell
  ;:  weld
    (expect !>(?=(^ (find "@media (max-width: 760px)" (trip css:web)))))
    (expect !>(?=(^ (find "pointerdown" (trip javascript:web)))))
    (expect !>(?=(^ (find "disconnected" (trip javascript:web)))))
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
    (expect !>(?=(^ (find "addEventListener('wheel'" js))))
    (expect !>(?=(^ (find "addEventListener('pointermove'" js))))
    (expect !>(?=(^ (find "replaceChildren(svg)" js))))
  ==
::
++  test-editor-usability
  =/  html  (trip page:web)
  =/  js  (trip javascript:web)
  ;:  weld
    (expect !>(?=(^ (find "id=\"line-numbers\"" html))))
    (expect !>(?=(^ (find "Select template…" html))))
    (expect !>(?=(^ (find "value=\"\" disabled=\"\" hidden=\"\"" html))))
    (expect !>(?=(~ (find ">Templates<" html))))
    (expect !>(?=(^ (find "value=\"flowchart\"" html))))
    (expect !>(?=(^ (find "value=\"strict-digraph\"" html))))
    (expect !>(?=(^ (find "value=\"state-machine\"" html))))
    (expect !>(?=(^ (find "value=\"dependencies\"" html))))
    (expect !>(?=(^ (find "value=\"clusters\"" html))))
    (expect !>(?=(^ (find "strict digraph unique_edges" js))))
    (expect !>(?=(^ (find "last wins" js))))
    (expect !>(?=(^ (find "createDocumentFragment" js))))
    (expect !>(?=(^ (find "has-error-line" js))))
    (expect !>(?=(^ (find "handleTab" js))))
    (expect !>(?=(^ (find "const pairs" js))))
    (expect !>(?=(^ (find "handleShortcut" js))))
    (expect !>(?=(^ (find "loadCurrentSvg" js))))
  ==
::
++  test-persistence-export
  =/  js  (trip javascript:web)
  ;:  weld
    (expect !>(?=(^ (find "graph-viz.session.v1" js))))
    (expect !>(?=(^ (find "localStorage.setItem" js))))
    (expect !>(?=(^ (find "localStorage.getItem" js))))
    (expect !>(?=(^ (find "preferences:" js))))
    (expect !>(?=(^ (find "autoRender: autoRender.checked" js))))
    (expect !>(?=(^ (find "paneWidth: currentPaneWidth()" js))))
    (expect !>(?=(^ (find "loadCurrentDot" js))))
    (expect !>(?=(^ (find "saveCurrentDot" js))))
    (expect !>(?=(^ (find "saveCurrentSvg" js))))
    (expect !>(?=(^ (find "autoRender.checked = false" js))))
    (expect !>(?=(^ (find "showClayError(cause)" js))))
    (expect !>(?=(^ (find "x-graph-viz-path" js))))
    (expect !>(?=(^ (find "x-graph-viz-overwrite" js))))
    (expect !>(?=(^ (find "response.status === 409" js))))
    (expect !>(?=(^ (find "already exists. Overwrite it?" js))))
    (expect !>(?=(~ (find "copyShareUrl" js))))
    (expect !>(?=(^ (find "encodeSource" js))))
    (expect !>(?=(^ (find "decodeSource" js))))
    (expect !>(?=(^ (find "maxSharedSourceBytes" js))))
    (expect !>(?=(^ (find "sourceFromUrl" js))))
  ==
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
    (expect !>(?=(^ (find "id=\"new-node-shape\"" html))))
    (expect !>(?=(^ (find "id=\"add-node\"" html))))
    (expect !>(?=(^ (find "id=\"draw-edge\"" html))))
    (expect !>(?=(^ (find "id=\"attribute-form\"" html))))
    (expect !>(?=(^ (find "id=\"delete-selection\"" html))))
    (expect !>(?=(^ (find "addVisualNode" js))))
    (expect !>(?=(^ (find "drawSelectedEdge" js))))
    (expect !>(?=(^ (find "deleteSelectedItem" js))))
    (expect !>(?=(^ (find "applySelectedAttributes" js))))
    (expect !>(?=(^ (find "readStatementAttributes" js))))
    (expect !>(?=(^ (find "insertRootStatement" js))))
    (expect !>(?=(^ (find "Edit edge chains or grouped edges" js))))
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
