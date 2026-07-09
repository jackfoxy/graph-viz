::  P13 end-to-end corpus tests
::
::  SVG goldens are regression anchors, not correctness proofs:
::  byte-exact output for representative corpus files.  Structural
::  diag goldens (node/edge/cluster/rank/virtual/crossing counts)
::  were cross-validated against reference graphviz 2.43 (ranks
::  exact via dot -Tplain, crossings within ceil(1.5x) of dot's
::  mincross).  Regenerate both with check.sh at the repo root.
::
/-  gviz
/+  *test, lib=gviz
/*  hello-src    %dot  /tests/dot/hello/dot
/*  unix-src     %dot  /tests/dot/unix/dot
/*  cluster-src  %dot  /tests/dot/cluster/dot
/*  fsm-src      %dot  /tests/dot/fsm/dot
/*  shells-src   %dot  /tests/dot/shells/dot
/*  world-src    %dot  /tests/dot/world/dot
/*  uni-src      %dot  /tests/dot/unicode/dot
/*  hello-gold    %svg  /tests/svg/hello/svg
/*  unix-gold     %svg  /tests/svg/unix/svg
/*  cluster-gold  %svg  /tests/svg/cluster/svg
/*  fsm-gold      %svg  /tests/svg/fsm/svg
/*  uni-gold      %svg  /tests/svg/unicode/svg
|%
::  +|  Helpers
::
::
++  render
  |=  src=@t
  ^-  result:gviz
  (run:lib [%render 0v0 [%dot %svg ~ ~ %.n %.n %.y %.n] src])
::
++  expect-golden
  |=  [src=@t gold=@t]
  ^-  tang
  =/  r  (render src)
  ?.  ?=(%svg -.r)  ['render failed' ~]
  (expect-eq !>(gold) !>(svg.r))
::
++  expect-diag
  |=  [src=@t d=diag:gviz]
  ^-  tang
  =/  r  (render src)
  ?.  ?=(%svg -.r)  ['render failed' ~]
  (expect-eq !>(`d) !>(diag.r))
::  +|  SVG goldens
::
::
++  test-e2e-goldens
  ;:  weld
    (category "hello" (expect-golden hello-src hello-gold))
    (category "unix" (expect-golden unix-src unix-gold))
    (category "cluster" (expect-golden cluster-src cluster-gold))
    (category "fsm" (expect-golden fsm-src fsm-gold))
    (category "unicode" (expect-golden uni-src uni-gold))
  ==
::  +|  Structural goldens (dot-validated)
::
::
++  test-e2e-structure
  ;:  weld
    (category "hello" (expect-diag hello-src [2 1 0 2 0 0]))
    (category "unix" (expect-diag unix-src [41 49 0 11 22 3]))
    (category "cluster" (expect-diag cluster-src [8 9 2 3 1 0]))
    (category "fsm" (expect-diag fsm-src [9 14 0 6 4 0]))
    (category "shells" (expect-diag shells-src [29 38 0 10 29 2]))
    (category "world" (expect-diag world-src [48 69 0 9 68 60]))
  ==
::  +|  Perf smoke
::
::
++  test-e2e-perf-world
  ::  a world.dot-class input must complete within the event and
  ::  produce a full drawing
  =/  r  (render world-src)
  ?.  ?=(%svg -.r)  ['render failed' ~]
  (expect !>((gth (met 3 svg.r) 20.000)))
--
