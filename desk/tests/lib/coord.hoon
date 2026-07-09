::  Tests for /lib/coord (P9: coordinate assignment)
::
::  Straightness tolerance: reference dot's own max interior
::  x-spread on unix.dot long edges is 212.6pt (measured from
::  dot -Tplain, graphviz 2.43); ours must stay under 200.
::
/+  *test, parse, attr, rank, order, coord
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
  ^-  $:  g=ranked:rank
          o=ordered:order
          c=coords:coord
      ==
  =/  r  (parse:parse txt)
  ?>  ?=(%& -.r)
  =/  res  (resolve:attr p.r ~)
  =/  g  (rank-graph:rank res)
  =/  o  (order-graph:order res g)
  [g o (coord-graph:coord res g o)]
::
++  close
  |=  [a=@rs b=@rs tol=@rs]
  ^-  ?
  =/  d  (sub:rs a b)
  =/  ad  ?:((lth:rs d .0) (sub:rs .0 d) d)
  (lte:rs ad tol)
::
++  rank-props
  ::  within every rank: P8 order preserved along the within axis
  ::  and no node boxes overlap
  |=  [o=ordered:order c=coords:coord]
  ^-  tang
  =/  horiz  |(=(%lr rankdir.c) =(%rl rankdir.c))
  %+  roll  order.o
  |=  [row=(list @ud) acc=tang]
  %+  weld  acc
  =/  ms  row
  |-  ^-  tang
  ?~  ms  ~
  ?~  t.ms  ~
  =/  pu  (~(got by pos.c) i.ms)
  =/  pv  (~(got by pos.c) i.t.ms)
  =/  du  (~(got by dims.c) i.ms)
  =/  dv  (~(got by dims.c) i.t.ms)
  =/  cu  ?:(horiz y.pu x.pu)
  =/  cv  ?:(horiz y.pv x.pv)
  =/  eu  ?:(horiz h.du w.du)
  =/  ev  ?:(horiz h.dv w.dv)
  =/  ordered-ok  ?:(horiz (gth:rs cu cv) (lth:rs cu cv))
  =/  gapv  ?:(horiz (sub:rs cu cv) (sub:rs cv cu))
  =/  need  (div:rs (add:rs eu ev) .2)
  ?.  ordered-ok  ['within-rank order violated' ~]
  ?.  (gte:rs gapv (sub:rs need .0.01))  ['node boxes overlap' ~]
  $(ms t.ms)
::
++  max-spread
  ::  widest within-axis span of any virtual chain
  |=  [g=ranked:rank c=coords:coord]
  ^-  @rs
  =/  horiz  |(=(%lr rankdir.c) =(%rl rankdir.c))
  %+  roll  edges.g
  |=  [re=rank-edge:rank best=@rs]
  ?:  flat.re  best
  ?:  (lte (lent path.re) 2)  best
  =/  vals
    %+  turn  (snip (slag 1 path.re))
    |=  v=@ud
    ?:(horiz y:(~(got by pos.c) v) x:(~(got by pos.c) v))
  ?~  vals  best
  =/  mm
    =/  acc=[lo=@rs hi=@rs]  [i.vals i.vals]
    =/  ls  `(list @rs)`t.vals
    |-  ^-  [lo=@rs hi=@rs]
    ?~  ls  acc
    %=  $
      ls   t.ls
      acc  :-  ?:((lth:rs i.ls lo.acc) i.ls lo.acc)
           ?:((gth:rs i.ls hi.acc) i.ls hi.acc)
    ==
  =/  sp  (sub:rs hi.mm lo.mm)
  ?:((gth:rs sp best) sp best)
::
++  rank-axis
  ::  representative rank-axis coordinate of each rank
  |=  [o=ordered:order c=coords:coord]
  ^-  (list @rs)
  =/  horiz  |(=(%lr rankdir.c) =(%rl rankdir.c))
  %+  murn  order.o
  |=  row=(list @ud)
  ^-  (unit @rs)
  ?~  row  ~
  =/  p  (~(got by pos.c) i.row)
  `?:(horiz x.p y.p)
::
++  monotone
  |=  [vals=(list @rs) increasing=?]
  ^-  ?
  =/  ms  vals
  |-  ^-  ?
  ?~  ms  %.y
  ?~  t.ms  %.y
  =/  ok
    ?:  increasing  (lth:rs i.ms i.t.ms)
    (gth:rs i.ms i.t.ms)
  ?.(ok %.n $(ms t.ms))
::  +|  Basics
::
::
++  test-coord-chain
  ::  hand-computed: 54x36 boxes, ranksep 36, size 54x180
  =/  t  (go 'digraph {a->b->c}')
  ;:  weld
    (expect-eq !>([w=.54 h=.180]) !>(size.c.t))
    (expect-eq !>(.1) !>(scale.c.t))
    (expect-eq !>([x=.27 y=.162]) !>((~(got by pos.c.t) 0)))
    (expect-eq !>([x=.27 y=.90]) !>((~(got by pos.c.t) 1)))
    (expect-eq !>([x=.27 y=.18]) !>((~(got by pos.c.t) 2)))
    (expect-eq !>([w=.54 h=.36]) !>((~(got by dims.c.t) 0)))
  ==
::
++  test-coord-rankdir
  ;:  weld
  ::  BT: rank 0 at the bottom
    =/  t  (go 'digraph {rankdir=BT; a->b}')
    =/  ya  y:(~(got by pos.c.t) 0)
    =/  yb  y:(~(got by pos.c.t) 1)
    (expect !>((lth:rs ya yb)))
  ::  LR: ranks run left to right
    =/  t  (go 'digraph {rankdir=LR; a->b}')
    =/  xa  x:(~(got by pos.c.t) 0)
    =/  xb  x:(~(got by pos.c.t) 1)
    (expect !>((lth:rs xa xb)))
  ::  RL: ranks run right to left
    =/  t  (go 'digraph {rankdir=RL; a->b}')
    =/  xa  x:(~(got by pos.c.t) 0)
    =/  xb  x:(~(got by pos.c.t) 1)
    (expect !>((gth:rs xa xb)))
  ==
::
++  test-coord-scale
  ::  unix size="6,6" -> 432pt target over a ~1020pt drawing
  =/  t  (go unix-src)
  ;:  weld
    (expect !>((close scale.c.t .0.423 .0.01)))
    (expect !>((gth:rs w.size.c.t .1000)))
  ==
::  +|  Corpus properties
::
::
++  test-coord-no-overlap-order
  ;:  weld
    =/  t  (go unix-src)
    (category "unix" (rank-props o.t c.t))
  ::
    =/  t  (go world-src)
    (category "world" (rank-props o.t c.t))
  ::
    =/  t  (go fsm-src)
    (category "fsm" (rank-props o.t c.t))
  ::
    =/  t  (go shells-src)
    (category "shells" (rank-props o.t c.t))
  ::
    =/  t  (go cluster-src)
    (category "cluster" (rank-props o.t c.t))
  ==
::
++  test-coord-rank-monotone
  ;:  weld
  ::  TB corpus: rank axis y strictly decreasing (y-up)
    =/  t  (go unix-src)
    (category "unix" (expect !>((monotone (rank-axis o.t c.t) %.n))))
  ::
    =/  t  (go world-src)
    (category "world" (expect !>((monotone (rank-axis o.t c.t) %.n))))
  ::  fsm is rankdir=LR: rank axis x strictly increasing
    =/  t  (go fsm-src)
    (category "fsm" (expect !>((monotone (rank-axis o.t c.t) %.y))))
  ==
::
++  test-coord-straight-chains
  ::  our chains must not wander more than reference dot's do
  =/  t  (go unix-src)
  (expect !>((lth:rs (max-spread g.t c.t) .200)))
--
