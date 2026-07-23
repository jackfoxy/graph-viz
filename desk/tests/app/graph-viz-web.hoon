::  Tests for /app/graph-viz-web.
::
/+  *test
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
++  test-browse-paths
  =/  files=(list path)
    :~  /app/graph-viz/examples/source/txt
        /app/graph-viz/examples/output/svg
        /app/other/ignored/txt
        /app/graph-viz/examples/nested/txt/file
    ==
  ;:  weld
    %+  expect-eq
      !>(~[/examples/source/txt])
    !>((browse-paths:agent files %txt))
    %+  expect-eq
      !>(~[/examples/output/svg])
    !>((browse-paths:agent files %svg))
    %+  expect-eq
      !>('["/examples/source/txt"]')
    !>((browse-text:agent ~[/examples/source/txt]))
  ==
::
++  test-web-save-dot
  =/  src  'digraph { a -> b }'
  =/  body  `(as-octt:mimes:html (trip src))
  =/  req
    (file-request '/apps/graph-viz/file/dot/save' 'examples/source' body)
  =/  out  (poke-http req)
  =/  cards  -.out
  ?>  ?=(^ cards)
  =/  save  i.cards
  =/  pax  /app/graph-viz/examples/source/txt
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
  =/  pax  /app/graph-viz/examples/output/txt/svg
  =/  expected=card:agent:gall
    :*  %pass  /clay/save  %arvo  %c
        %info  %graph-viz  %&
        ~[[pax %ins [%svg !>(src)]]]
    ==
  ;:  weld
    (expect-eq !>(expected) !>(save))
    (expect-eq !>(200) !>((response-status t.cards)))
  ==
--
