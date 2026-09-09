::  %graph-viz-web: Sail and HTTP boundary for the DOT renderer.
::
/-  gviz
/+  clay=gviz-clay, dbug, default-agent, lib=gviz, server, web=gviz-web
/+  uhttp=urui-http
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
/*  docs-toc     %toc  /doc/toc
|%
+$  versioned-state  $%(state-0)
+$  state-0  [%0 ~]
+$  card  card:agent:gall
+$  operation  ?(%render %browse %load %save %delete)
::
++  respond
  |=  [eyre-id=@ta status=@ud content-type=@t body=@t]
  ^-  (list card)
  %+  give-simple-payload:app:server  eyre-id
  (respond:uhttp status content-type (as-octs:mimes:html body))
::
++  assets
  ^-  (list [suffix=@t asset=asset:uhttp])
  =/  js=@t  'text/javascript; charset=utf-8'
  =/  text=@t  'text/plain; charset=utf-8'
  %+  turn
    :~  ['' 'text/html; charset=utf-8' page:web]
        ['/' 'text/html; charset=utf-8' page:web]
        ['/app.js' js javascript:web]
        ['/doc.toc' text docs-toc]
        ['/ace/ace.js' js ace-core]
        ['/ace/graph-viz-config.js' js ace-config]
        ['/ace/mode-dot.js' js ace-dot]
        ['/ace/theme-github.js' js ace-light]
        ['/ace/theme-monokai.js' js ace-dark]
        ['/ace/ext-beautify.js' js ace-beaut]
        ['/ace/ext-prompt.js' js ace-prompt]
        ['/ace/ext-searchbox.js' js ace-search]
        ['/ace/ext-settings_menu.js' js ace-sets]
        ['/ace/license.txt' text (of-wain:format ace-lic)]
    ==
  |=  [suffix=@t content-type=@t body=@t]
  [suffix content-type (as-octs:mimes:html body)]
::
++  routes
  ^-  (map @t [op=operation kind=?(%dot %svg)])
  %-  malt
  ^-  (list [@t op=operation kind=?(%dot %svg)])
  :~  ['/apps/graph-viz/render' [%render %dot]]
      ['/apps/graph-viz/file/dot/browse' [%browse %dot]]
      ['/apps/graph-viz/file/dot/load' [%load %dot]]
      ['/apps/graph-viz/file/dot/save' [%save %dot]]
      ['/apps/graph-viz/file/dot/delete' [%delete %dot]]
      ['/apps/graph-viz/file/svg/browse' [%browse %svg]]
      ['/apps/graph-viz/file/svg/load' [%load %svg]]
      ['/apps/graph-viz/file/svg/save' [%save %svg]]
      ['/apps/graph-viz/file/svg/delete' [%delete %svg]]
  ==
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
  ~[[%pass /eyre/connect %arvo %e %connect `/apps/graph-viz dap.bowl]]
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  on-init:this(state old)
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
  =/  reply
    |=  [status=@ud body=@t]
    ^-  (quip card _this)
    [(respond eyre-id status 'text/plain; charset=utf-8' body) this]
  =/  raw-url=tape  (trip url.request.req)
  =/  query=(unit @ud)  (find "?" raw-url)
  =/  url=@t  (crip ?~(query raw-url (scag u.query raw-url)))
  ?:  =(%'GET' method.request.req)
    =/  asset  (asset-route:uhttp '/apps/graph-viz' url assets)
    ?~  asset  (reply 404 'not found')
    :_  this
    %+  give-simple-payload:app:server  eyre-id
    (respond:uhttp 200 u.asset)
  ?.  =(%'POST' method.request.req)  (reply 404 'not found')
  =/  route  (~(get by routes) url)
  ?~  route  (reply 404 'not found')
  ?.  authenticated.req  (reply 401 'authentication required')
  =/  [op=operation kind=?(%dot %svg)]  u.route
  ?:  =(%render op)
    ?~  body.request.req  (reply 400 'missing DOT source')
    =/  src=@t  q.u.body.request.req
    =/  result
      (run:lib [%render 0v0 [%dot %svg ~ ~ %.n %.n %.n %.n] src])
    ?-  -.result
      %svg
        :_  this
        (respond eyre-id 200 'image/svg+xml; charset=utf-8' svg.result)
      %error
        :_  this
        %:  respond
          eyre-id  422  'application/json; charset=utf-8'
          (error-text:web err.result)
        ==
      ?(%graph %version %plugins)  (reply 500 'unexpected result')
    ==
  =/  raw=(unit @t)
    (get-header:http 'x-graph-viz-path' header-list.request.req)
  =/  ext=?(%txt %svg)  ?:(=(%dot kind) %txt %svg)
  ?.  ?|  =(%browse op)  ?=(^ raw)  ==
    (reply 400 'missing Clay path')
  =/  pax=(unit path)
    ?:  =(%browse op)
      ?~(raw `storage-root:clay (browse-path:clay u.raw))
    (file-path:clay (need raw) ext)
  ?~  pax  (reply 400 'invalid Clay path')
  =/  beam=path
    [(scot %p our.bowl) q.byk.bowl (scot %da now.bowl) u.pax]
  ?+  op  !!
    %browse
      =/  result=(each arch tang)  (mule |.(.^(arch %cy beam)))
      ?:  ?=(%.n -.result)
        %-  (slog leaf+"Clay browse failed" (flop p.result))
        (reply 500 'Clay browse failed')
      =/  file=?
        ?&  (gth (lent u.pax) 2)
            =(ext (rear u.pax))
            ?=(^ fil.p.result)
        ==
      =/  children=(list @ta)
        (sort ~(tap in ~(key by dir.p.result)) aor)
      :_  this
      %:  respond
        eyre-id  200  'application/json; charset=utf-8'
        (browse-text:clay file children)
      ==
    %load
      ?.  .^(? %cu beam)  (reply 404 'Clay file not found')
      =/  body=@t
        ?:  =(%dot kind)  (of-wain:format .^(wain %cx beam))
        .^(@t %cx beam)
      =/  content-type=@t
        ?:  =(%dot kind)  'text/plain; charset=utf-8'
        'image/svg+xml; charset=utf-8'
      [(respond eyre-id 200 content-type body) this]
    %save
      =/  overwrite=(unit @t)
        (get-header:http 'x-graph-viz-overwrite' header-list.request.req)
      =/  overwrite-ok=?  ?~(overwrite %.n =('true' u.overwrite))
      ?:  ?&  .^(? %cu beam)  !overwrite-ok  ==
        (reply 409 'Clay file already exists')
      ?>  ?=(?(%txt %svg) (rear u.pax))
      =/  src=@t  ?~(body.request.req '' q.u.body.request.req)
      =/  cage
        ?:(=(%dot kind) [%txt !>((to-wain:format src))] [%svg !>(src)])
      =/  save=card
        :*  %pass  /clay/save  %arvo  %c
            %info  q.byk.bowl  %&  ~[[u.pax %ins cage]]
        ==
      =/  out  (reply 200 'saved')
      [[save -.out] +.out]
    %delete
      =/  remove=card
        :*  %pass  /clay/delete  %arvo  %c
            %info  q.byk.bowl  %&  ~[[u.pax %del ~]]
        ==
      =/  out  (reply 200 'deleted')
      [[remove -.out] +.out]
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
