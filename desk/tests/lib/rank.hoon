::  Tests for /lib/rank (P7: rank assignment)
::
/+  *test, parse, attr, rank
/*  unix-src     %dot  /tests/dot/unix/dot
/*  world-src    %dot  /tests/dot/world/dot
/*  fsm-src      %dot  /tests/dot/fsm/dot
/*  cluster-src  %dot  /tests/dot/cluster/dot
/*  shells-src   %dot  /tests/dot/shells/dot
|%
::  +|  Helpers
::
::
++  rk
  |=  txt=@t
  ^-  ranked:rank
  =/  r  (parse:parse txt)
  ?>  ?=(%& -.r)
  (rank-graph:rank (resolve:attr p.r ~))
::
++  rof
  |=  [g=ranked:rank v=@ud]
  ^-  @ud
  (~(got by ranks.g) v)
::
++  check-ranked
  ::  every node on every path is ranked; non-flat paths step
  ::  ranks by exactly one
  |=  g=ranked:rank
  ^-  tang
  %+  roll  edges.g
  |=  [re=rank-edge:rank acc=tang]
  %+  weld  acc
  ?:  flat.re  ~
  =/  p  path.re
  |-  ^-  tang
  ?~  p  ~
  ?~  t.p  ~
  =/  r0  (~(get by ranks.g) i.p)
  =/  r1  (~(get by ranks.g) i.t.p)
  ?~  r0  ['node missing rank' ~]
  ?~  r1  ['node missing rank' ~]
  ?.  =(+(u.r0) u.r1)  ['rank step not 1' ~]
  $(p t.p)
::
++  revs
  |=  g=ranked:rank
  ^-  @ud
  (lent (skim edges.g |=(re=rank-edge:rank rev.re)))
::  +|  Basics
::
::
++  test-rank-chain
  =/  g  (rk 'digraph {a->b->c}')
  ;:  weld
    (expect-eq !>(0) !>((rof g 0)))
    (expect-eq !>(1) !>((rof g 1)))
    (expect-eq !>(2) !>((rof g 2)))
    (expect-eq !>(3) !>(nrank.g))
    (expect-eq !>(3) !>(nall.g))
  ==
::
++  test-rank-diamond
  =/  g  (rk 'digraph {a->b; a->c; b->d; c->d}')
  %+  expect-eq  !>(~[0 1 1 2])
  !>((turn (gulf 0 3) |=(v=@ud (rof g v))))
::
++  test-rank-minlen
  =/  g  (rk 'digraph {a->b [minlen=3]}')
  ;:  weld
    (expect-eq !>(3) !>((rof g 1)))
    (expect-eq !>(4) !>(nall.g))
    (expect-eq !>(~[0 2 3 1]) !>(path:(snag 0 edges.g)))
    (expect-eq !>(1) !>((rof g 2)))
    (expect-eq !>(2) !>((rof g 3)))
  ==
::
++  test-rank-tighten
  ::  d has only slack out-edges, so it drops next to c
  =/  g  (rk 'digraph {a->b->c; d->c}')
  %+  expect-eq  !>(~[0 1 2 1])
  !>((turn (gulf 0 3) |=(v=@ud (rof g v))))
::  +|  Rank groups
::
::
++  test-rank-same
  ::  creation order: b c a d
  =/  g  (rk 'digraph { {rank=same; b c} a->b; a->c->d }')
  %+  expect-eq  !>(~[1 1 0 2])
  !>((turn (gulf 0 3) |=(v=@ud (rof g v))))
::
++  test-rank-same-cycle
  ::  the a/c union makes b->c a leader-space cycle; it re-reverses
  =/  g  (rk 'digraph {a->b; b->c; {rank=same; a c}}')
  =/  e1  (snag 1 edges.g)
  ;:  weld
    (expect-eq !>(~[0 1 0]) !>((turn (gulf 0 2) |=(v=@ud (rof g v)))))
    (expect !>(rev.e1))
    (expect-eq !>(~[2 1]) !>(path.e1))
  ==
::
++  test-rank-min-force
  ::  x forced to rank 0; the violated edge b->x goes flat
  =/  g  (rk 'digraph {a->b->x; {rank=min; x}}')
  ;:  weld
    (expect-eq !>(~[0 1 0]) !>((turn (gulf 0 2) |=(v=@ud (rof g v)))))
    (expect !>(flat:(snag 1 edges.g)))
  ==
::
++  test-rank-flat-same
  =/  g  (rk 'digraph { {rank=same; a b} a->b }')
  =/  e0  (snag 0 edges.g)
  ;:  weld
    (expect-eq !>(~[0 0]) !>((turn (gulf 0 1) |=(v=@ud (rof g v)))))
    (expect !>(flat.e0))
    (expect-eq !>(~[0 1]) !>(path.e0))
  ==
::  +|  Virtual chains
::
::
++  test-rank-virtuals
  =/  g  (rk 'digraph {a->b->c->d; a->d}')
  =/  e3  (snag 3 edges.g)
  ;:  weld
    (expect-eq !>(~[0 1 2 3]) !>((turn (gulf 0 3) |=(v=@ud (rof g v)))))
    (expect-eq !>(6) !>(nall.g))
    (expect-eq !>(4) !>(nrank.g))
    (expect-eq !>(~[0 4 5 3]) !>(path.e3))
    (expect-eq !>(1) !>((rof g 4)))
    (expect-eq !>(2) !>((rof g 5)))
  ==
::  +|  Corpus properties
::
::
++  corpus-rank
  |=  src=@t
  ^-  ranked:rank
  (rk src)
::
++  test-rank-corpus
  ;:  weld
    (category "unix" (check-ranked (corpus-rank unix-src)))
    (category "unix-norev" (expect-eq !>(0) !>((revs (corpus-rank unix-src)))))
    (category "world" (check-ranked (corpus-rank world-src)))
    (category "cluster" (check-ranked (corpus-rank cluster-src)))
    (category "shells" (check-ranked (corpus-rank shells-src)))
  ::  fsm has real cycles: some edges reverse, properties still hold
    (category "fsm" (check-ranked (corpus-rank fsm-src)))
    (category "fsm-rev" (expect !>((gth (revs (corpus-rank fsm-src)) 0))))
  ==
--
