::  %graph-viz-web: Sail and HTTP boundary for the DOT renderer.
::
/-  gviz
/+  dbug, default-agent, lib=gviz, server, web=gviz-web
/+  uhttp=urui-http, ufiles=urui-files
/*  ace-core     %js   /web/ace/ace/js
/*  ace-dot      %js   /web/ace/mode-dot/js
/*  ace-light    %js   /web/ace/theme-github/js
/*  ace-dark     %js   /web/ace/theme-monokai/js
/*  ace-beaut    %js   /web/ace/ext-beautify/js
/*  ace-prompt   %js   /web/ace/ext-prompt/js
/*  ace-search   %js   /web/ace/ext-searchbox/js
/*  ace-sets     %js   /web/ace/ext-settings-menu/js
/*  ace-vim      %js   /web/ace/keybinding-vim/js
/*  ace-lic      %txt  /web/ace/license/txt
/*  docs-toc     %toc  /doc/toc
|%
+$  versioned-state  $%(state-0 state-1)
+$  state-0  [%0 ~]
::  `files` is the one file change awaiting clay.  It is never saved: an
::  in-flight request does not survive a reload.
+$  state-1  [%1 files=(unit pending:ufiles)]
+$  card  card:agent:gall
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
        ['/ace/graph-viz-config.js' js ace-config-js:web]
        ['/ace/mode-dot.js' js ace-dot]
        ['/ace/theme-github.js' js ace-light]
        ['/ace/theme-monokai.js' js ace-dark]
        ['/ace/ext-beautify.js' js ace-beaut]
        ['/ace/ext-prompt.js' js ace-prompt]
        ['/ace/ext-searchbox.js' js ace-search]
        ['/ace/ext-settings_menu.js' js ace-sets]
        ['/ace/keybinding-vim.js' js ace-vim]
        ['/ace/license.txt' text (of-wain:format ace-lic)]
    ==
  |=  [suffix=@t content-type=@t body=@t]
  [suffix content-type (as-octs:mimes:html body)]
::
--
%-  agent:dbug
=|  state-1
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
  !>(state(files ~))
::
++  on-load
  ::  Both versions load as an empty %1: a %0 held nothing, and a %1
  ::  saves no pending change.
  |=  old-vase=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  on-init:this(state [%1 ~])
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
  ?:  =('/apps/graph-viz/files' url)
    ?.  authenticated.req  (reply 401 'authentication required')
    =^  cards  files.state
      %:  handle:ufiles
        file-policy:web
        bowl
        eyre-id
        req
        files.state
      ==
    [cards this]
  ?.  =('/apps/graph-viz/render' url)  (reply 404 'not found')
  ?.  authenticated.req  (reply 401 'authentication required')
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
  =/  taken=(unit outcome:ufiles)
    (take:ufiles file-policy:web bowl wire sign-arvo files.state)
  ?^  taken
    =.  files.state  next.u.taken
    [cards.u.taken this]
  (on-arvo:default wire sign-arvo)
++  on-fail  on-fail:default
--
