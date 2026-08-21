::  Tests for /app/graph-viz-web.
::
/+  *test, clay=gviz-clay
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
  |=  [url=@t path=@t body=(unit octs)]
  ^-  inbound-request:eyre
  =/  req  (request %'POST' url body)
  req(header-list.request ~[['x-graph-viz-path' path]])
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
++  test-web-file-missing-path
  =/  out
    (poke-http (request %'POST' '/apps/graph-viz/file/dot/save' ~))
  ;:  weld
    (expect-eq !>(400) !>((response-status -.out)))
    (expect-eq !>('missing Clay path') !>((response-body -.out)))
  ==
::
++  test-browse-path
  ;:  weld
    %+  expect-eq
      !>(`/data/graph-viz)
    !>((browse-path:clay ''))
    %+  expect-eq
      !>(`/data/graph-viz/examples/source)
    !>((browse-path:clay 'examples/source'))
    %+  expect-eq
      !>(`/data/graph-viz/examples/source)
    !>((browse-path:clay '/examples/source'))
    %+  expect-eq
      !>('{"children":["source","strict-2"],"file":false}')
    !>((browse-text:clay | ~[%source %strict-2]))
  ==
::
++  test-web-save-dot
  =/  src  'digraph { a -> b }'
  =/  body  `(as-octt:mimes:html (trip src))
  =/  req
    (file-request '/apps/graph-viz/file/dot/save' '/examples/source' body)
  =/  out  (poke-http req)
  =/  cards  -.out
  ?>  ?=(^ cards)
  =/  save  i.cards
  =/  pax  /data/graph-viz/examples/source/txt
  =/  expected=card:agent:gall
    :*  %pass  /clay/save  %arvo  %c
        %info  %graph-viz  %&
        ~[[pax %ins [%txt !>((to-wain:format src))]]]
    ==
  ;:  weld
    (expect-eq !>(expected) !>(save))
    (expect-eq !>(200) !>((response-status t.cards)))
    (expect-eq !>('saved') !>((response-body t.cards)))
  ==
::
++  test-web-save-svg
  =/  src  '<svg xmlns="http://www.w3.org/2000/svg"></svg>'
  =/  body  `(as-octt:mimes:html (trip src))
  =/  req
    (file-request '/apps/graph-viz/file/svg/save' 'examples/output/txt' body)
  =/  out  (poke-http req)
  =/  cards  -.out
  ?>  ?=(^ cards)
  =/  save  i.cards
  =/  pax  /data/graph-viz/examples/output/txt/svg
  =/  expected=card:agent:gall
    :*  %pass  /clay/save  %arvo  %c
        %info  %graph-viz  %&
        ~[[pax %ins [%svg !>(src)]]]
    ==
  ;:  weld
    (expect-eq !>(expected) !>(save))
    (expect-eq !>(200) !>((response-status t.cards)))
  ==
::
++  test-web-delete-dot
  =/  req
    (file-request '/apps/graph-viz/file/dot/delete' 'examples/source' ~)
  =/  out  (poke-http req)
  =/  cards  -.out
  ?>  ?=(^ cards)
  =/  remove  i.cards
  =/  pax  /data/graph-viz/examples/source/txt
  =/  expected=card:agent:gall
    :*  %pass  /clay/delete  %arvo  %c
        %info  %graph-viz  %&  ~[[pax %del ~]]
    ==
  ;:  weld
    (expect-eq !>(expected) !>(remove))
    (expect-eq !>(200) !>((response-status t.cards)))
    (expect-eq !>('deleted') !>((response-body t.cards)))
  ==
--
