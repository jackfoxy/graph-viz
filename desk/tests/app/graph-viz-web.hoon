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
  (expect-eq !>(200) !>((response-status -.out)))
::
++  test-web-render
  =/  body  `(as-octt:mimes:html (trip 'digraph { a -> b }'))
  =/  out  (poke-http (request %'POST' '/apps/graph-viz/render' body))
  (expect-eq !>(200) !>((response-status -.out)))
::
++  test-web-render-error
  =/  body  `(as-octt:mimes:html (trip 'digraph { a -- b }'))
  =/  out  (poke-http (request %'POST' '/apps/graph-viz/render' body))
  (expect-eq !>(422) !>((response-status -.out)))
--
