::  Tests for /lib/route (P10: routing, splines, arrowheads)
::
/+  *test, parse, attr, rank, order, coord, metrics
/+  route
/*  unix-src    %dot  /tests/dot/unix/dot
/*  world-src   %dot  /tests/dot/world/dot
/*  fsm-src     %dot  /tests/dot/fsm/dot
/*  shells-src  %dot  /tests/dot/shells/dot
/*  ports-src   %dot  /tests/dot/ports/dot
|%
::  +|  Helpers
::
::
++  go
  |=  txt=@t
  ^-  $:  res=resolved:attr
          g=ranked:rank
          c=coords:coord
          ro=(list redge-out:route)
      ==
  =/  r  (parse:parse txt)
  ?>  ?=(%& -.r)
  =/  res  (resolve:attr p.r ~)
  =/  g  (rank-graph:rank res)
  =/  o  (order-graph:order res g)
  =/  c  (coord-graph:coord res g o)
  [res g c (route-graph:route res g c)]
::
++  on-boundary
  ::  point sits on the node's border, within tolerance
  |=  $:  res=resolved:attr
          c=coords:coord
          v=@ud
          p=[x=@rs y=@rs]
      ==
  ^-  ?
  =/  ctr  (~(got by pos.c) v)
  =/  d  (~(got by dims.c) v)
  =/  pad  (node-stroke-pad:route res v)
  =/  a  (add:rs (div:rs w.d .2) pad)
  =/  b  (add:rs (div:rs h.d .2) pad)
  =/  dx  (sub:rs x.p x.ctr)
  =/  dy  (sub:rs y.p y.ctr)
  =/  adx  ?:((lth:rs dx .0) (sub:rs .0 dx) dx)
  =/  ady  ?:((lth:rs dy .0) (sub:rs .0 dy) dy)
  ?:  (is-elly:route (node-shape:route res v))
    =/  qx  (div:rs adx a)
    =/  qy  (div:rs ady b)
    =/  q  (add:rs (mul:rs qx qx) (mul:rs qy qy))
    &((gth:rs q .0.9) (lth:rs q .1.1))
  ?&  (lte:rs adx (add:rs a .0.1))
      (lte:rs ady (add:rs b .0.1))
      ?|  (gte:rs adx (sub:rs a .0.1))
          (gte:rs ady (sub:rs b .0.1))
      ==
  ==
::
++  check-routed
  ::  valid control runs and boundary endpoints for every edge
  |=  $:  res=resolved:attr
          c=coords:coord
          ro=(list redge-out:route)
      ==
  ^-  tang
  %+  roll  ro
  |=  [e=redge-out:route acc=tang]
  %+  weld  acc
  ^-  tang
  =/  n  (lent spline.e)
  ?.  &((gte n 4) =(1 (mod n 3)))
    ['invalid spline run length' ~]
  ?.  (on-boundary res c tail.e (snag 0 spline.e))
    ['tail endpoint off boundary' ~]
  ?.  (on-boundary res c head.e (snag (dec n) spline.e))
    ['head endpoint off boundary' ~]
  ~
::  +|  Corpus properties
::
::
++  test-route-corpus
  ;:  weld
    =/  t  (go unix-src)
    (category "unix" (check-routed res.t c.t ro.t))
  ::
    =/  t  (go world-src)
    (category "world" (check-routed res.t c.t ro.t))
  ::
    =/  t  (go fsm-src)
    (category "fsm" (check-routed res.t c.t ro.t))
  ::
    =/  t  (go shells-src)
    (category "shells" (check-routed res.t c.t ro.t))
  ::  ports.dot exercises compass attachment points
    =/  t  (go ports-src)
    (category "ports" (check-routed res.t c.t ro.t))
  ==
::  +|  Arrowheads
::
::
++  test-route-arrows-basic
  ;:  weld
  ::  directed: one normal (3-point) arrow, tip on the spline end
    =/  t  (go 'digraph {a->b}')
    =/  e  (snag 0 ro.t)
    =/  tip  (snag 0 (snag 0 arrows.e))
    ;:  weld
      (expect-eq !>(1) !>((lent arrows.e)))
      (expect-eq !>(3) !>((lent (snag 0 arrows.e))))
      (expect-eq !>((snag 3 spline.e)) !>(tip))
    ==
  ::  undirected: none
    =/  t  (go 'graph {a--b}')
    (expect-eq !>(0) !>((lent arrows:(snag 0 ro.t))))
  ==
::
++  test-route-box-arrow-clearance
  =/  t  (go 'digraph {rankdir=LR node [shape=box] a->b}')
  =/  e  (snag 0 ro.t)
  =/  tip  (snag 0 (snag 0 arrows.e))
  =/  head  (snag head.e nodes.res.t)
  =/  ctr  (~(got by pos.c.t) head.e)
  =/  dims  (~(got by dims.c.t) head.e)
  =/  boundary  (sub:rs x.ctr (div:rs w.dims .2))
  =/  pad  (node-stroke-pad:route res.t head.e)
  ;:  weld
    (expect !>((lth:rs x.tip boundary)))
    (expect !>((gte:rs (sub:rs boundary x.tip) pad)))
    (expect-eq !>((snag (dec (lent spline.e)) spline.e)) !>(tip))
  ==
::
++  test-route-arrow-dirs
  ;:  weld
  ::  dir=back: arrow at the spline start
    =/  t  (go 'digraph {a->b [dir=back]}')
    =/  e  (snag 0 ro.t)
    ;:  weld
      (expect-eq !>(1) !>((lent arrows.e)))
      (expect-eq !>((snag 0 spline.e)) !>((snag 0 (snag 0 arrows.e))))
    ==
  ::  dir=both: two arrows
    =/  t  (go 'digraph {a->b [dir=both]}')
    (expect-eq !>(2) !>((lent arrows:(snag 0 ro.t))))
  ::  dir=none
    =/  t  (go 'digraph {a->b [dir=none]}')
    (expect-eq !>(0) !>((lent arrows:(snag 0 ro.t))))
  ==
::
++  test-route-arrow-shapes
  ;:  weld
    =/  t  (go 'digraph {a->b [arrowhead=vee]}')
    (expect-eq !>(4) !>((lent (snag 0 arrows:(snag 0 ro.t)))))
  ::
    =/  t  (go 'digraph {a->b [arrowhead=diamond]}')
    (expect-eq !>(4) !>((lent (snag 0 arrows:(snag 0 ro.t)))))
  ::
    =/  t  (go 'digraph {a->b [arrowhead=dot]}')
    (expect-eq !>(8) !>((lent (snag 0 arrows:(snag 0 ro.t)))))
  ::
    =/  t  (go 'digraph {a->b [arrowhead=none]}')
    (expect-eq !>(0) !>((lent arrows:(snag 0 ro.t))))
  ==
::
++  test-route-reversed-arrow
  ::  the P7-reversed edge draws its arrow at its original head,
  ::  which is the drawn spline's start
  =/  t  (go 'digraph {a->b; b->a}')
  =/  e0  (snag 0 ro.t)
  =/  e1  (snag 1 ro.t)
  ;:  weld
    %+  expect-eq
      !>((snag (dec (lent spline.e0)) spline.e0))
    !>((snag 0 (snag 0 arrows.e0)))
  ::
    (expect-eq !>((snag 0 spline.e1)) !>((snag 0 (snag 0 arrows.e1))))
  ==
::
++  test-route-large-head-arrow
  ::  A large head node must not place the final control inside it
  =/  src
    %-  crip
    ;:  weld
      "digraph states \{ rankdir=LR node [shape=circle] "
      "start [shape=doublecircle] start -> idle "
      "idle -> running [label=start] "
      "running -> idle [label=stop] "
      "running -> done [label=finish] "
      "done [shape=doublecircle] }"
    ==
  =/  t  (go src)
  =/  e  (snag 1 ro.t)
  =/  arrow  (snag 0 arrows.e)
  =/  tip  (snag 0 arrow)
  =/  base  (snag 1 arrow)
  ;:  weld
    (expect-eq !>((snag (dec (lent spline.e)) spline.e)) !>(tip))
    (expect !>((gth:rs x.tip x.base)))
  ==
::  +|  Loops, fans, flats
::
::
++  test-route-self-loop
  =/  t  (go 'digraph {a->a; a->a}')
  =/  e0  (snag 0 ro.t)
  =/  e1  (snag 1 ro.t)
  =/  ctr  (~(got by pos.c.t) 0)
  ;:  weld
    (expect-eq !>(4) !>((lent spline.e0)))
    (expect-eq !>(4) !>((lent spline.e1)))
  ::  both loops bow right of the node center
    (expect !>((gth:rs x:(snag 1 spline.e0) x.ctr)))
    (expect !>((gth:rs x:(snag 1 spline.e1) x.ctr)))
  ::  fanned: second loop reaches further right
    %-  expect
    !>((gth:rs x:(snag 1 spline.e1) x:(snag 1 spline.e0)))
  ::  endpoints on the boundary
    (expect !>((on-boundary res.t c.t 0 (snag 0 spline.e0))))
    (expect !>((on-boundary res.t c.t 0 (snag 3 spline.e0))))
  ==
::
++  test-route-multi-edge-fan
  =/  t  (go 'digraph {a->b; a->b}')
  =/  e0  (snag 0 ro.t)
  =/  e1  (snag 1 ro.t)
  ;:  weld
    (expect-eq !>(2) !>((lent ro.t)))
  ::  control points differ between the parallel edges
    %-  expect
    !>(!=((snag 1 spline.e0) (snag 1 spline.e1)))
  ==
::
++  test-route-flat-edge
  =/  t  (go 'digraph { {rank=same; a b} a->b }')
  =/  e  (snag 0 ro.t)
  =/  p0  (snag 0 spline.e)
  =/  p3  (snag 3 spline.e)
  ;:  weld
    (expect !>((lth:rs x.p0 x.p3)))
    (expect !>((on-boundary res.t c.t 0 p0)))
    (expect !>((on-boundary res.t c.t 1 p3)))
  ==
::  +|  Public graph assembly
::
::
++  test-build-graph
  =/  r  (parse:parse 'digraph G {hello -> world}')
  ?>  ?=(%& -.r)
  =/  res  (resolve:attr p.r ~)
  =/  g  (rank-graph:rank res)
  =/  o  (order-graph:order res g)
  =/  c  (coord-graph:coord res g o)
  =/  pg  (build-graph:route res g c)
  ;:  weld
    (expect-eq !>(2) !>((lent nodes.pg)))
    (expect-eq !>(1) !>((lent edges.pg)))
    (expect-eq !>('hello') !>(name:(snag 0 nodes.pg)))
    (expect-eq !>('hello') !>(label:(snag 0 nodes.pg)))
    (expect !>((gth:rs x.size.canvas.pg .0)))
    (expect !>(directed.pg))
  ==
::
++  test-cluster-bounds
  =/  src
    %-  crip
    ;:  weld
      "digraph architecture \{ node [shape=box] "
      "subgraph cluster_web \{ label=\"Web\" browser -> gateway } "
      "subgraph cluster_data \{ label=\"Data\" api -> database } "
      "gateway -> api }"
    ==
  =/  t  (go src)
  =/  pg  (build-graph:route res.t g.t c.t)
  =/  cl  (snag 0 clusters.pg)
  =/  top-node  (snag 0 nodes.pg)
  =/  node-top  (add:rs y.center.top-node y.half.top-node)
  ?>  ?=(^ label.cl)
  ;:  weld
    (expect !>((gte:rs x.ll.bbox.cl .0)))
    (expect !>((gte:rs y.ll.bbox.cl .0)))
    (expect !>((lte:rs x.ur.bbox.cl x.size.canvas.pg)))
    (expect !>((lte:rs y.ur.bbox.cl y.size.canvas.pg)))
    (expect !>((gth:rs y.at.u.label.cl node-top)))
  ==
::
++  test-strict-label-clearance
  =/  src
    %-  crip
    ;:  weld
      "strict digraph unique_edges \{ rankdir=LR node [shape=box] "
      "Start -> Validate [label=first] "
      "Start -> Validate [label=\"last wins\", color=blue] "
      "Validate -> Done }"
    ==
  =/  t  (go src)
  =/  pg  (build-graph:route res.t g.t c.t)
  =/  edge  (snag 0 edges.pg)
  =/  start  (snag 0 nodes.pg)
  =/  validate  (snag 1 nodes.pg)
  ?>  ?=(^ label.edge)
  =/  label-half
    %+  div:rs
      w:(text-size:metrics .14 text.u.label.edge)
    .2
  =/  label-left  (sub:rs x.at.u.label.edge label-half)
  =/  label-right  (add:rs x.at.u.label.edge label-half)
  =/  start-right  (add:rs x.center.start x.half.start)
  =/  validate-left  (sub:rs x.center.validate x.half.validate)
  ;:  weld
    (expect-eq !>(2) !>((lent edges.pg)))
    (expect-eq !>('last wins') !>(text.u.label.edge))
    %+  expect-eq  !>(`'blue')
    !>((~(get by attrs.edge) 'color'))
  ::
    (expect !>((gte:rs label-left start-right)))
    (expect !>((lte:rs label-right validate-left)))
  ==
--
