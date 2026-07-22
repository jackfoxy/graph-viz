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
    (expect !>(?=(^ (find "id=\"download\"" (trip html)))))
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
++  test-web-error-json
  =/  txt  (error-text:web [%parse 2 7 'syntax error'])
  ;:  weld
    (expect !>(?=(^ (find "\"kind\":\"parse\"" (trip txt)))))
    (expect !>(?=(^ (find "\"line\":2" (trip txt)))))
    (expect !>(?=(^ (find "\"column\":7" (trip txt)))))
  ==
--
