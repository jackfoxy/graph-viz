::  Tests for /app/graph-viz (P12: poke/subscribe protocol)
::
::  Emulates the fakezod integration: a bowl with a live
::  subscription on /result/[uid], then pokes and card checks.
::
/-  gviz
/+  *test
/=  agent  /app/graph-viz
|%
::  +|  Fixtures
::
::
++  uid  `@uv`0v17
::
++  pax  `path`/result/(scot %uv uid)
::
++  bol
  ^-  bowl:gall
  %*  .  *bowl:gall
    our  ~zod
    src  ~zod
    dap  %graph-viz
    sup  (malt ~[[`duct`~[/test] [~zod pax]]])
  ==
::
++  opts0
  ^-  render-opts:gviz
  [%dot %svg ~ ~ %.n %.n %.n %.n]
::
++  poke
  |=  cmd=command:gviz
  (on-poke:~(. agent bol) %gviz-command !>(cmd))
::
++  fact-result
  ::  the result inside the first card, which must be a %fact
  ::  on pax with the %gviz-result mark
  |=  cards=(list card:agent:gall)
  ^-  [tang result:gviz]
  ?>  ?=(^ cards)
  =/  c0  i.cards
  ?>  ?=(%give -.c0)
  =/  gf  p.c0
  ?>  ?=(%fact -.gf)
  :_  !<(result:gviz q.cage.gf)
  ;:  weld
    (expect-eq !>(~[pax]) !>(paths.gf))
    (expect-eq !>(%gviz-result) !>(p.cage.gf))
  ==
::  +|  Protocol
::
::
++  test-app-render-fact-kick
  =/  out  (poke [%render uid opts0 'digraph {hello -> world}'])
  =/  cards  -.out
  =/  fr  (fact-result cards)
  ;:  weld
    (expect-eq !>(2) !>((lent cards)))
    -.fr
    (expect !>(?=(%svg -.+.fr)))
  ::  second card kicks the path
    =/  c1  (snag 1 cards)
    ?>  ?=(%give -.c1)
    =/  gf  p.c1
    ?>  ?=(%kick -.gf)
    ;:  weld
      (expect-eq !>(~[pax]) !>(paths.gf))
      (expect-eq !>(~) !>(ship.gf))
    ==
  ==
::
++  test-app-error-as-fact
  ::  bad DOT still produces a fact (an %error result), not a nack
  =/  out  (poke [%render uid opts0 'digraph { a -- b }'])
  =/  fr  (fact-result -.out)
  ;:  weld
    -.fr
    (expect-eq !>([%error %parse 1 14 'syntax error']) !>(+.fr))
  ==
::
++  test-app-version
  =/  out  (poke [%version uid])
  =/  fr  (fact-result -.out)
  ;:  weld
    -.fr
    (expect-eq !>([%version 0 1 0]) !>(+.fr))
  ==
::
++  test-app-no-subscriber-nack
  %-  expect-fail
  |.  %-  on-poke:~(. agent *bowl:gall)
      [%gviz-command !>([%version uid])]
::
++  test-app-watch-paths
  ;:  weld
  ::  /result/[uid] accepted, no cards
    =/  out  (on-watch:~(. agent bol) pax)
    (expect-eq !>(~) !>(-.out))
  ::  anything else crashes (nacks the subscription)
    %-  expect-fail
    |.  (on-watch:~(. agent bol) /bogus/path)
  ==
--
