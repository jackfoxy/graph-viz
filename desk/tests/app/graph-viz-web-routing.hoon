/+  *test
/=  web  /tests/app/graph-viz-web
|%
  ::  Routing boundaries exercised independently of the original 18 arms.
  ::
++  test-protected-routes-authenticate-before-validating
  =/  urls=(list @t)
    :~  '/apps/graph-viz/render'
        '/apps/graph-viz/file/dot/browse'
        '/apps/graph-viz/file/dot/load'
        '/apps/graph-viz/file/dot/save'
        '/apps/graph-viz/file/dot/delete'
        '/apps/graph-viz/file/svg/browse'
        '/apps/graph-viz/file/svg/load'
        '/apps/graph-viz/file/svg/save'
        '/apps/graph-viz/file/svg/delete'
    ==
  %-  zing
  %+  turn  urls
  |=  url=@t
  =/  req  (request:web %'POST' url ~)
  =/  out  (poke-http:web req(authenticated %.n))
  ;:  weld
    (expect-eq !>(401) !>((response-status:web -.out)))
    %+  expect-eq
      !>('authentication required')
    !>((response-body:web -.out))
    %+  expect-eq
      !>(~[['content-type' 'text/plain; charset=utf-8']])
    !>((response-headers:web -.out))
  ==
::
++  test-unknown-and-wrong-method-remain-not-found
  =/  cases=(list [method=method:http url=@t])
    :~  [%'HEAD' '/apps/graph-viz/app.js']
        [%'POST' '/apps/graph-viz/app.js']
        [%'GET' '/apps/graph-viz/render']
        [%'POST' '/apps/graph-viz/render/']
        [%'POST' '/apps/graph-viz/file/dot/nope']
    ==
  %-  zing
  %+  turn  cases
  |=  [method=method:http url=@t]
  =/  req  (request:web method url ~)
  =/  out  (poke-http:web req(authenticated %.n))
  ;:  weld
    (expect-eq !>(404) !>((response-status:web -.out)))
    (expect-eq !>('not found') !>((response-body:web -.out)))
  ==
::
++  test-post-query-keeps-the-route
  =/  req  (request:web %'POST' '/apps/graph-viz/render?x=1' ~)
  =/  out  (poke-http:web req)
  ;:  weld
    (expect-eq !>(400) !>((response-status:web -.out)))
    (expect-eq !>('missing DOT source') !>((response-body:web -.out)))
  ==
::
++  test-file-validation-precedes-clay-access
  =/  urls=(list @t)
    :~  '/apps/graph-viz/file/dot/browse'
        '/apps/graph-viz/file/dot/load'
        '/apps/graph-viz/file/svg/save'
        '/apps/graph-viz/file/svg/delete'
    ==
  %-  zing
  %+  turn  urls
  |=  url=@t
  =/  out  (poke-http:web (file-request:web url '../escape' ~))
  ;:  weld
    (expect-eq !>(400) !>((response-status:web -.out)))
    (expect-eq !>('invalid Clay path') !>((response-body:web -.out)))
  ==
::
++  test-load-rebinds-with-the-saved-state
  =/  initial  on-init:~(. agent:web bol:web)
  =/  loaded  (on-load:~(. agent:web bol:web) !>([%0 ~]))
  (expect-eq !>(-.initial) !>(-.loaded))
--
