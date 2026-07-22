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
--
