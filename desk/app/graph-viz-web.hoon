::  %graph-viz-web: Sail and HTTP boundary for the DOT renderer.
::
/-  gviz
/+  dbug, default-agent, lib=gviz, server, web=gviz-web
|%
+$  versioned-state  $%(state-0)
+$  state-0  [%0 ~]
+$  card  card:agent:gall
::
++  respond
  |=  [eyre-id=@ta status=@ud content-type=@t body=@t]
  ^-  (list card)
  %+  give-simple-payload:app:server  eyre-id
  ^-  simple-payload:http
  [[status ~[['content-type' content-type]]] `(as-octt:mimes:html (trip body))]
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %n) bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this
  :~  :*  %pass  /eyre/connect  %arvo  %e
          %connect  `/apps/graph-viz  dap.bowl
      ==
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  ?-  -.old
    %0  :_  this(state old)
        :~  :*  %pass  /eyre/connect  %arvo  %e
                %connect  `/apps/graph-viz  dap.bowl
            ==
        ==
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?.  =(%handle-http-request mark)
    (on-poke:default mark vase)
  (handle-http !<([@ta inbound-request:eyre] vase))
::
++  handle-http
  |=  [eyre-id=@ta req=inbound-request:eyre]
  ^-  (quip card _this)
  =/  url=tape  (trip url.request.req)
  =/  method  method.request.req
  ?:  ?&  =(%'GET' method)  =("/apps/graph-viz" url)  ==
    :_  this
    (respond eyre-id 200 'text/html; charset=utf-8' page:web)
  ?:  ?&  =(%'GET' method)  =("/apps/graph-viz/" url)  ==
    :_  this
    (respond eyre-id 200 'text/html; charset=utf-8' page:web)
  ?:  ?&  =(%'GET' method)  =("/apps/graph-viz/app.js" url)  ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' javascript:web)
  ?.  ?&  =(%'POST' method)  =("/apps/graph-viz/render" url)  ==
    :_  this
    (respond eyre-id 404 'text/plain; charset=utf-8' 'not found')
  ?.  authenticated.req
    :_  this
    (respond eyre-id 401 'text/plain; charset=utf-8' 'authentication required')
  ?~  body.request.req
    :_  this
    (respond eyre-id 400 'text/plain; charset=utf-8' 'missing DOT source')
  =/  src=@t  q.u.body.request.req
  =/  result
    (run:lib [%render 0v0 [%dot %svg ~ ~ %.n %.n %.n %.n] src])
  ?-    -.result
      %svg
    :_  this
    (respond eyre-id 200 'image/svg+xml; charset=utf-8' svg.result)
  ::
      %error
    :_  this
    %:  respond
      eyre-id
      422
      'application/json; charset=utf-8'
      (error-text:web err.result)
    ==
  ::
      ?(%graph %version %plugins)
    :_  this
    (respond eyre-id 500 'text/plain; charset=utf-8' 'unexpected result')
  ==
--
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:default path)
    [%http-response @ ~]  `this
  ==
::
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?:  ?&  =(/eyre/connect wire)
          ?=([%eyre %bound *] sign-arvo)
      ==
    `this
  (on-arvo:default wire sign-arvo)
++  on-fail  on-fail:default
--
