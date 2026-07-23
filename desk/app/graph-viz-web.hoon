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
::
++  file-path
  |=  [raw=@t ext=?(%txt %svg)]
  ^-  (unit path)
  =/  parsed=(unit path)
    %-  mole  |.
    (stab (cat 3 '/' raw))
  ?~  parsed  ~
  =/  rel=path  u.parsed
  ?:  =(~ rel)  ~
  ?.  %+  levy  rel
      |=  part=@ta
      ?&  !=('.' part)
          !=('..' part)
      ==
    ~
  =?  rel  !=(ext (rear rel))
    (snoc rel ext)
  `(weld /app/graph-viz rel)
::
++  browse-paths
  |=  [files=(list path) ext=?(%txt %svg)]
  ^-  (list path)
  =/  root=path  /app/graph-viz
  =/  root-len=@ud  (lent root)
  %+  murn  files
  |=  file=path
  ?.  (gth (lent file) root-len)  ~
  ?.  =(root (scag root-len file))  ~
  =/  relative=path  (slag root-len file)
  ?.  =(ext (rear relative))  ~
  `relative
::
++  browse-text
  |=  files=(list path)
  ^-  @t
  %-  en:json:html
  a+(turn files |=(file=path s+(crip (spud file))))
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
  ?:  ?&  =(%'POST' method)
          =("/apps/graph-viz/file/dot/browse" url)
      ==
    (browse-files eyre-id req %dot)
  ?:  ?&  =(%'POST' method)
          =("/apps/graph-viz/file/dot/load" url)
      ==
    (load-file eyre-id req %dot)
  ?:  ?&  =(%'POST' method)
          =("/apps/graph-viz/file/dot/save" url)
      ==
    (save-file eyre-id req %dot)
  ?:  ?&  =(%'POST' method)
          =("/apps/graph-viz/file/svg/browse" url)
      ==
    (browse-files eyre-id req %svg)
  ?:  ?&  =(%'POST' method)
          =("/apps/graph-viz/file/svg/load" url)
      ==
    (load-file eyre-id req %svg)
  ?:  ?&  =(%'POST' method)
          =("/apps/graph-viz/file/svg/save" url)
      ==
    (save-file eyre-id req %svg)
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
::
++  browse-files
  |=  [eyre-id=@ta req=inbound-request:eyre kind=?(%dot %svg)]
  ^-  (quip card _this)
  ?.  authenticated.req
    :_  this
    (respond eyre-id 401 'text/plain; charset=utf-8' 'authentication required')
  =/  root=path  /app/graph-viz
  =/  beam=path
    :*  (scot %p our.bowl)
        q.byk.bowl
        (scot %da now.bowl)
        root
    ==
  =/  ext=?(%txt %svg)  ?:(=(%dot kind) %txt %svg)
  =/  files=(list path)
    (browse-paths .^((list path) %ct beam) ext)
  :_  this
  %:  respond
    eyre-id
    200
    'application/json; charset=utf-8'
    (browse-text files)
  ==
::
++  load-file
  |=  [eyre-id=@ta req=inbound-request:eyre kind=?(%dot %svg)]
  ^-  (quip card _this)
  ?.  authenticated.req
    :_  this
    (respond eyre-id 401 'text/plain; charset=utf-8' 'authentication required')
  =/  raw=(unit @t)
    (get-header:http 'x-graph-viz-path' header-list.request.req)
  ?~  raw
    :_  this
    (respond eyre-id 400 'text/plain; charset=utf-8' 'missing Clay path')
  =/  pax=(unit path)
    (file-path u.raw ?:(=(%dot kind) %txt %svg))
  ?~  pax
    :_  this
    (respond eyre-id 400 'text/plain; charset=utf-8' 'invalid Clay path')
  =/  beam=path
    :*  (scot %p our.bowl)
        q.byk.bowl
        (scot %da now.bowl)
        u.pax
    ==
  ?.  .^(? %cu beam)
    :_  this
    (respond eyre-id 404 'text/plain; charset=utf-8' 'Clay file not found')
  =/  body=@t
    ?:  =(%dot kind)
      (of-wain:format .^(wain %cx beam))
    .^(@t %cx beam)
  =/  content-type=@t
    ?:  =(%dot kind)
      'text/plain; charset=utf-8'
    'image/svg+xml; charset=utf-8'
  :_  this
  (respond eyre-id 200 content-type body)
::
++  save-file
  |=  [eyre-id=@ta req=inbound-request:eyre kind=?(%dot %svg)]
  ^-  (quip card _this)
  ?.  authenticated.req
    :_  this
    (respond eyre-id 401 'text/plain; charset=utf-8' 'authentication required')
  =/  raw=(unit @t)
    (get-header:http 'x-graph-viz-path' header-list.request.req)
  ?~  raw
    :_  this
    (respond eyre-id 400 'text/plain; charset=utf-8' 'missing Clay path')
  =/  pax=(unit path)
    (file-path u.raw ?:(=(%dot kind) %txt %svg))
  ?~  pax
    :_  this
    (respond eyre-id 400 'text/plain; charset=utf-8' 'invalid Clay path')
  ?>  ?=(?(%txt %svg) (rear u.pax))
  =/  src=@t
    ?~(body.request.req '' q.u.body.request.req)
  =/  cage
    ?:  =(%dot kind)
      [%txt !>((to-wain:format src))]
    [%svg !>(src)]
  =/  save=card
    :*  %pass  /clay/save  %arvo  %c
        %info  q.byk.bowl  %&  ~[[u.pax %ins cage]]
    ==
  :_  this
  [save (respond eyre-id 200 'text/plain; charset=utf-8' 'saved')]
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
