::  %graph-viz-web: Sail and HTTP boundary for the DOT renderer.
::
/-  gviz
/+  clay=gviz-clay, dbug, default-agent, lib=gviz, server, web=gviz-web
/*  ace-core     %js   /web/ace/ace/js
/*  ace-config   %js   /web/ace/graph-viz-config/js
/*  ace-dot      %js   /web/ace/mode-dot/js
/*  ace-light    %js   /web/ace/theme-github/js
/*  ace-dark     %js   /web/ace/theme-monokai/js
/*  ace-beaut    %js   /web/ace/ext-beautify/js
/*  ace-prompt   %js   /web/ace/ext-prompt/js
/*  ace-search   %js   /web/ace/ext-searchbox/js
/*  ace-sets     %js   /web/ace/ext-settings-menu/js
/*  ace-lic      %txt  /web/ace/license/txt
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
  =/  raw-url=tape  (trip url.request.req)
  =/  query=(unit @ud)  (find "?" raw-url)
  =/  url=tape  ?~(query raw-url (scag u.query raw-url))
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
  ?:  ?&  =(%'GET' method)  =("/apps/graph-viz/ace/ace.js" url)  ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-core)
  ?:  ?&  =(%'GET' method)
          =("/apps/graph-viz/ace/graph-viz-config.js" url)
      ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-config)
  ?:  ?&  =(%'GET' method)  =("/apps/graph-viz/ace/mode-dot.js" url)  ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-dot)
  ?:  ?&  =(%'GET' method)
          =("/apps/graph-viz/ace/theme-github.js" url)
      ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-light)
  ?:  ?&  =(%'GET' method)
          =("/apps/graph-viz/ace/theme-monokai.js" url)
      ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-dark)
  ?:  ?&  =(%'GET' method)
          =("/apps/graph-viz/ace/ext-beautify.js" url)
      ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-beaut)
  ?:  ?&  =(%'GET' method)
          =("/apps/graph-viz/ace/ext-prompt.js" url)
      ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-prompt)
  ?:  ?&  =(%'GET' method)
          =("/apps/graph-viz/ace/ext-searchbox.js" url)
      ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-search)
  ?:  ?&  =(%'GET' method)
          =("/apps/graph-viz/ace/ext-settings_menu.js" url)
      ==
    :_  this
    (respond eyre-id 200 'text/javascript; charset=utf-8' ace-sets)
  ?:  ?&  =(%'GET' method)
          =("/apps/graph-viz/ace/license.txt" url)
      ==
    :_  this
    %-  respond
    :*  eyre-id
        200
        'text/plain; charset=utf-8'
        (of-wain:format ace-lic)
    ==
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
          =("/apps/graph-viz/file/dot/delete" url)
      ==
    (delete-file eyre-id req %dot)
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
  ?:  ?&  =(%'POST' method)
          =("/apps/graph-viz/file/svg/delete" url)
      ==
    (delete-file eyre-id req %svg)
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
  =/  raw=(unit @t)
    (get-header:http 'x-graph-viz-path' header-list.request.req)
  =/  base=(unit path)
    ?~  raw
      `storage-root:clay
    (browse-path:clay u.raw)
  ?~  base
    :_  this
    (respond eyre-id 400 'text/plain; charset=utf-8' 'invalid Clay path')
  =/  beam=path
    :*  (scot %p our.bowl)
        q.byk.bowl
        (scot %da now.bowl)
        u.base
    ==
  =/  ext=?(%txt %svg)  ?:(=(%dot kind) %txt %svg)
  =/  result=(each arch tang)
    %-  mule  |.
    .^(arch %cy beam)
  ?-  -.result
    %.n
      %-  (slog leaf+"Clay browse failed" (flop p.result))
      :_  this
      (respond eyre-id 500 'text/plain; charset=utf-8' 'Clay browse failed')
    %.y
      =/  file=?
        ?&  (gth (lent u.base) 2)
            =(ext (rear u.base))
            ?=(^ fil.p.result)
        ==
      =/  children=(list @ta)
        (sort ~(tap in ~(key by dir.p.result)) aor)
      :_  this
      %:  respond
        eyre-id
        200
        'application/json; charset=utf-8'
        (browse-text:clay file children)
      ==
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
    (file-path:clay u.raw ?:(=(%dot kind) %txt %svg))
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
    (file-path:clay u.raw ?:(=(%dot kind) %txt %svg))
  ?~  pax
    :_  this
    (respond eyre-id 400 'text/plain; charset=utf-8' 'invalid Clay path')
  =/  beam=path
    :*  (scot %p our.bowl)
        q.byk.bowl
        (scot %da now.bowl)
        u.pax
    ==
  =/  overwrite=(unit @t)
    (get-header:http 'x-graph-viz-overwrite' header-list.request.req)
  =/  overwrite-ok=?
    ?~  overwrite  %.n
    =('true' u.overwrite)
  ?:  ?&  .^(? %cu beam)  !overwrite-ok  ==
    :_  this
    %:  respond
      eyre-id
      409
      'text/plain; charset=utf-8'
      'Clay file already exists'
    ==
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
::
++  delete-file
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
    (file-path:clay u.raw ?:(=(%dot kind) %txt %svg))
  ?~  pax
    :_  this
    (respond eyre-id 400 'text/plain; charset=utf-8' 'invalid Clay path')
  =/  remove=card
    :*  %pass  /clay/delete  %arvo  %c
        %info  q.byk.bowl  %&  ~[[u.pax %del ~]]
    ==
  :_  this
  [remove (respond eyre-id 200 'text/plain; charset=utf-8' 'deleted')]
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
