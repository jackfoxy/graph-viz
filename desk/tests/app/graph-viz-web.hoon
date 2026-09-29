::  Tests for /app/graph-viz-web.
::
/+  *test, ufiles=urui-files, web-lib=gviz-web
/*  favicon  %ico  /favicon/ico
/=  agent  /app/graph-viz-web
|%
::
++  bol
  ^-  bowl:gall
  %*  .  *bowl:gall
    our  ~zod
    src  ~zod
    dap  %graph-viz-web
    byk  [~zod %graph-viz %da ~2000.1.1]
  ==
::
++  request
  |=  [method=method:http url=@t body=(unit octs)]
  ^-  inbound-request:eyre
  %*  .  *inbound-request:eyre
    authenticated  %.y
    request
      %*  .  *request:http
        method  method
        url     url
        body    body
      ==
  ==
::
++  poke-http
  |=  req=inbound-request:eyre
  %-  on-poke:~(. agent bol)
  [%handle-http-request !>(['request' req])]
::
++  file-request
  ::  A json request on urui's file wire.
  |=  body=@t
  ^-  inbound-request:eyre
  =/  req
    (request %'POST' '/apps/graph-viz/files' `(as-octs:mimes:html body))
  req(header-list.request ~[['content-type' 'application/json']])
::
++  response-status
  |=  cards=(list card:agent:gall)
  ^-  @ud
  ?>  ?=(^ cards)
  =/  card  i.cards
  ?>  ?=(%give -.card)
  =/  gift  p.card
  ?>  ?=(%fact -.gift)
  ?>  =(%http-response-header p.cage.gift)
  =/  hed  !<(response-header:http q.cage.gift)
  status-code.hed
::
++  response-headers
  |=  cards=(list card:agent:gall)
  ^-  (list [key=@t value=@t])
  ?>  ?=(^ cards)
  =/  card  i.cards
  ?>  ?=(%give -.card)
  =/  gift  p.card
  ?>  ?=(%fact -.gift)
  ?>  =(%http-response-header p.cage.gift)
  =/  hed  !<(response-header:http q.cage.gift)
  headers.hed
::
++  response-body
  |=  cards=(list card:agent:gall)
  ^-  @t
  ?>  ?=(^ cards)
  =/  cards  t.cards
  ?>  ?=(^ cards)
  =/  card  i.cards
  ?>  ?=(%give -.card)
  =/  gift  p.card
  ?>  ?=(%fact -.gift)
  ?>  =(%http-response-data p.cage.gift)
  =/  data  !<((unit octs) q.cage.gift)
  q:(need data)
::
++  check-asset
  |=  [url=@t content-type=@t needle=@t]
  ^-  tang
  =/  out  (poke-http (request %'GET' url ~))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    %+  expect-eq
      !>(~[['content-type' content-type]])
    !>((response-headers -.out))
    %-  expect
    !>(?=(^ (find (trip needle) (trip (response-body -.out)))))
  ==
::
++  test-web-binds-http
  =/  out  on-init:~(. agent bol)
  =/  expected=card:agent:gall
    :*  %pass  /eyre/connect  %arvo  %e
        %connect  `/apps/graph-viz  %graph-viz-web
    ==
  (expect-eq !>(~[expected]) !>(-.out))
::
++  test-web-page
  =/  out  (poke-http (request %'GET' '/apps/graph-viz' ~))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    %+  expect-eq
      !>(~[['content-type' 'text/html; charset=utf-8']])
    !>((response-headers -.out))
    (expect !>(?=(^ (find "Graph Viz" (trip (response-body -.out))))))
  ==
::
++  test-web-page-query
  =/  out
    (poke-http (request %'GET' '/apps/graph-viz/?dot=ZGlncmFwaCB7fQ' ~))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    %+  expect-eq
      !>(~[['content-type' 'text/html; charset=utf-8']])
    !>((response-headers -.out))
    (expect !>(?=(^ (find "Graph Viz" (trip (response-body -.out))))))
  ==
::
++  test-web-favicon
  =/  out  (poke-http (request %'GET' '/apps/graph-viz/favicon.ico' ~))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    %+  expect-eq
      !>(~[['content-type' 'image/x-icon']])
    !>((response-headers -.out))
    (expect-eq !>(q.favicon) !>((response-body -.out)))
  ==
::
++  test-web-javascript
  =/  out  (poke-http (request %'GET' '/apps/graph-viz/app.js' ~))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    %+  expect-eq
      !>(~[['content-type' 'text/javascript; charset=utf-8']])
    !>((response-headers -.out))
    %-  expect
    !>(?=(^ (find "async function render" (trip (response-body -.out)))))
  ==
::
++  test-web-doc-toc
  =/  out  (poke-http (request %'GET' '/apps/graph-viz/doc.toc' ~))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    %+  expect-eq
      !>(~[['content-type' 'text/plain; charset=utf-8']])
    !>((response-headers -.out))
    %-  expect
    !>(?=(^ (find "/dot-language" (trip (response-body -.out)))))
  ==
::
++  test-web-ace-assets
  ;:  weld
    %^  check-asset
      '/apps/graph-viz/ace/ace.js'
      'text/javascript; charset=utf-8'
    'ace.define("ace/ace"'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/graph-viz-config.js'
      'text/javascript; charset=utf-8'
    '1.44.0'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/mode-dot.js'
      'text/javascript; charset=utf-8'
    'ace/mode/dot'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/theme-github.js'
      'text/javascript; charset=utf-8'
    'ace/theme/github'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/theme-monokai.js'
      'text/javascript; charset=utf-8'
    'ace/theme/monokai'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/ext-beautify.js'
      'text/javascript; charset=utf-8'
    'ace/ext/beautify'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/ext-prompt.js'
      'text/javascript; charset=utf-8'
    'ace/ext/prompt'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/ext-searchbox.js'
      'text/javascript; charset=utf-8'
    'ace/ext/searchbox'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/ext-settings_menu.js'
      'text/javascript; charset=utf-8'
    'ace/ext/settings_menu'
  ::
    %^  check-asset
      '/apps/graph-viz/ace/license.txt'
      'text/plain; charset=utf-8'
    'Copyright (c) 2010, Ajax.org B.V.'
  ==
::
++  test-web-ace-assets-are-public
  =/  req  (request %'GET' '/apps/graph-viz/ace/ace.js' ~)
  =/  out  (poke-http req(authenticated %.n))
  (expect-eq !>(200) !>((response-status -.out)))
::
++  test-web-ace-not-found
  =/  out
    (poke-http (request %'GET' '/apps/graph-viz/ace/not-shipped.js' ~))
  ;:  weld
    (expect-eq !>(404) !>((response-status -.out)))
    (expect-eq !>('not found') !>((response-body -.out)))
  ==
::
++  test-web-not-found
  =/  out  (poke-http (request %'GET' '/apps/graph-viz/nope' ~))
  ;:  weld
    (expect-eq !>(404) !>((response-status -.out)))
    (expect-eq !>('not found') !>((response-body -.out)))
  ==
::
++  test-web-missing-body
  =/  out  (poke-http (request %'POST' '/apps/graph-viz/render' ~))
  ;:  weld
    (expect-eq !>(400) !>((response-status -.out)))
    (expect-eq !>('missing DOT source') !>((response-body -.out)))
  ==
::
++  test-web-render
  =/  body  `(as-octt:mimes:html (trip 'digraph { a -> b }'))
  =/  out  (poke-http (request %'POST' '/apps/graph-viz/render' body))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    %+  expect-eq
      !>(~[['content-type' 'image/svg+xml; charset=utf-8']])
    !>((response-headers -.out))
    (expect !>(?=(^ (find "<svg" (trip (response-body -.out))))))
  ==
::
++  test-web-render-escaping
  =/  src  'digraph { a [label="<a & \\"b\\">"] }'
  =/  body  `(as-octt:mimes:html (trip src))
  =/  out  (poke-http (request %'POST' '/apps/graph-viz/render' body))
  =/  txt  (trip (response-body -.out))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    (expect !>(?=(^ (find "&lt;a &amp; &quot;b&quot;&gt;" txt))))
    (expect !>(?=(~ (find "<a &" txt))))
  ==
::
++  test-web-render-error
  =/  body  `(as-octt:mimes:html (trip 'digraph { a -- b }'))
  =/  out  (poke-http (request %'POST' '/apps/graph-viz/render' body))
  =/  txt  (trip (response-body -.out))
  ;:  weld
    (expect-eq !>(422) !>((response-status -.out)))
    %+  expect-eq
      !>(~[['content-type' 'application/json; charset=utf-8']])
    !>((response-headers -.out))
    (expect !>(?=(^ (find "\"kind\":\"parse\"" txt))))
    (expect !>(?=(^ (find "\"line\":" txt))))
  ==
::
++  test-web-files-refuse-bad-requests
  ::  urui-files answers: its tests cover the wire; these pin the route.
  =/  empty  (poke-http (request %'POST' '/apps/graph-viz/files' ~))
  =/  outside
    %-  poke-http
    (file-request '{"op":"load","path":["..","escape","txt"]}')
  =/  mark
    %-  poke-http
    (file-request '{"op":"load","path":["examples","source","dot"]}')
  ;:  weld
    (expect-eq !>(415) !>((response-status -.empty)))
    (expect-eq !>(400) !>((response-status -.outside)))
    %-  expect
    !>(?=(^ (find "invalid-path" (trip (response-body -.outside)))))
    (expect-eq !>(400) !>((response-status -.mark)))
  ==
::
++  test-web-files-browse-an-empty-root
  ::  `%cy` answers an empty arch for a path with no clay node, so an
  ::  empty root is an empty listing rather than a failure.
  =/  out  (poke-http (file-request '{"op":"browse","scope":[]}'))
  ;:  weld
    (expect-eq !>(200) !>((response-status -.out)))
    (expect !>(?=(^ (find "\"entries\":[]" (trip (response-body -.out))))))
    (expect !>(?=(^ (find "\"ok\":true" (trip (response-body -.out))))))
  ==
::
++  test-web-file-policy
  ::  DOT is stored as txt and SVG as svg, in one root, with knot paths.
  =/  policy=policy:ufiles  file-policy:web-lib
  ;:  weld
    (expect-eq !>(`path`/data/graph-viz) !>(root.policy))
    (expect !>(!strict.policy))
    (expect !>(verify.policy))
    %-  expect
    !>(=(`%wain (file-codec:ufiles policy /examples/source/txt &)))
    %-  expect
    !>(=(`%cord (file-codec:ufiles policy /examples/output/svg &)))
    %-  expect
    !>(=(`%wain (file-codec:ufiles policy ~[~.v1.2 %source %txt] &)))
  ==
--
