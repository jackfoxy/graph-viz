::  Tests for /lib/order (P8: crossing reduction)
::
::  Corpus thresholds are ceil(1.5x) of reference dot's own mincross
::  counts (graphviz 2.43, `dot -v`): unix 2, world 58, fsm 0,
::  shells 1, cluster 0.  Regenerate with:
::    dot -v file.dot -o /dev/null 2>&1 | grep 'crossings,'
::
/+  *test, parse, attr, rank, order
/*  unix-src     %dot  /tests/dot/unix/dot
/*  world-src    %dot  /tests/dot/world/dot
/*  fsm-src      %dot  /tests/dot/fsm/dot
/*  shells-src   %dot  /tests/dot/shells/dot
/*  cluster-src  %dot  /tests/dot/cluster/dot
|%
::  +|  Helpers
::
::
++  go
  |=  txt=@t
  ^-  [rs=resolved:attr g=ranked:rank o=ordered:order]
  =/  r  (parse:parse txt)
  ?>  ?=(%& -.r)
  =/  rs  (resolve:attr p.r ~)
  =/  g  (rank-graph:rank rs)
  [rs g (order-graph:order rs g)]
::
++  never-worse
  ::  mincross must not exceed the initial order's crossings
  |=  txt=@t
  ^-  tang
  =/  t  (go txt)
  %-  expect
  !>  (lte crossings.o.t (initial-crossings:order rs.t g.t))
::  +|  Basics
::
::
++  test-order-k22
  ::  K2,2 has exactly one unavoidable crossing
  =/  t  (go 'digraph {a->x; a->y; b->x; b->y}')
  (expect-eq !>(1) !>(crossings.o.t))
::
++  test-order-fixable
  ::  one crossing in the initial order, none needed
  =/  t  (go 'digraph {a->x; a->y; b->x}')
  (expect-eq !>(0) !>(crossings.o.t))
::
++  test-order-deterministic
  =/  a  (go 'digraph {a->x; a->y; b->x; b->y; x->m; y->m}')
  =/  b  (go 'digraph {a->x; a->y; b->x; b->y; x->m; y->m}')
  (expect-eq !>(o.a) !>(o.b))
::  +|  Constraints
::
::
++  test-order-flat-constraint
  ::  flat a->b forces a left of b despite creation order
  =/  t  (go 'digraph { {rank=same; b a} a->b }')
  ::  ids: b=0 a=1; flat [1 0] wants 1 first
  (expect-eq !>(~[~[1 0]]) !>(order.o.t))
::
++  test-order-cluster-contiguity
  ::  cluster members pulled together within the rank
  =/  t  (go 'digraph { subgraph cluster_0 {a b} x->a; x->q; x->b }')
  ::  ids: a=0 b=1 x=2 q=3; init rank 1 is [a q b]
  (expect-eq !>(~[0 1 3]) !>((snag 1 order.o.t)))
::  +|  Corpus
::
::
++  test-order-never-worse
  ;:  weld
    (category "unix" (never-worse unix-src))
    (category "world" (never-worse world-src))
    (category "fsm" (never-worse fsm-src))
    (category "shells" (never-worse shells-src))
    (category "cluster" (never-worse cluster-src))
  ==
::
++  test-order-corpus-thresholds
  ;:  weld
    %+  category  "unix"
    (expect !>((lte crossings.o:(go unix-src) 3)))
  ::
    %+  category  "world"
    (expect !>((lte crossings.o:(go world-src) 87)))
  ::
    %+  category  "fsm"
    (expect !>((lte crossings.o:(go fsm-src) 0)))
  ::
    %+  category  "shells"
    (expect !>((lte crossings.o:(go shells-src) 2)))
  ::
    %+  category  "cluster"
    (expect !>((lte crossings.o:(go cluster-src) 0)))
  ==
--
