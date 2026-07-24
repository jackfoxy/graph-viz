::  coord: coordinate assignment (P9)
::
::  Per GKNV93 section 4.2 / lib/dotgen/position.c: the rank axis
::  comes straight from ranks (ranksep + max node extent per rank);
::  the within-rank axis starts packed in P8 order and iterates the
::  priority/median method: nodes move toward the median of their
::  neighbors, high-priority nodes (virtual chain members most of
::  all) can push lower-priority ones aside but never cross a peer.
::  Order within ranks is therefore preserved exactly.
::
::  Node boxes: label extent from metrics + shape margins
::  (ellipse family scaled by sqrt 2), width/height minima,
::  fixedsize.  rankdir is a pure geometry transform applied on
::  output; layout is computed in TB space with axes swapped for
::  LR/RL.  The graph size attribute produces a scale factor in the
::  output (applied at codegen); ratio is out of scope for v1.
::
/+  attr=attr, rank=rank, order=order, metrics=metrics
|%
::  +|  Types
::
::
+$  coords
  $:  nreal=@ud
      nall=@ud
      rankdir=?(%tb %lr %bt %rl)
      size=[w=@rs h=@rs]
      scale=@rs
      pos=(map @ud [x=@rs y=@rs])     :: centers, points, y-up
      dims=(map @ud [w=@rs h=@rs])    :: full extents
  ==
::
+$  csamp
  $:  nall=@ud
      nreal=@ud
      nrank=@ud
      horiz=?
      nodesep=@rs
      ranksep=@rs
      rows=(list (list @ud))
      rof=(map @ud @ud)
      up=(map @ud (list @ud))
      down=(map @ud (list @ud))
      ww=(map @ud @rs)
      hh=(map @ud @rs)
      prio=(map @ud @ud)
  ==
::  +|  Small helpers
::
::
++  rd-rs  |=(d=@rd ^-(@rs (bit:rs (sea:rd d))))
::
++  rmax  |=([a=@rs b=@rs] ?:((gth:rs a b) a b))
::
++  rmin  |=([a=@rs b=@rs] ?:((lth:rs a b) a b))
::
++  half  |=(a=@rs (div:rs a .2))
::
++  rlast
  ::  last element, .0 when empty (wet +rear chokes on refined lists)
  |=  l=(list @rs)
  ^-  @rs
  =/  best  .0
  |-  ^-  @rs
  ?~  l  best
  $(l t.l, best i.l)
::
++  median-x
  |=  vals=(list @rs)
  ^-  @rs
  =/  s  (sort vals lth:rs)
  =/  k  (lent s)
  =/  m  (div k 2)
  ?:  =(1 (mod k 2))  (snag m s)
  (half (add:rs (snag (dec m) s) (snag m s)))
::  +|  Labels and node boxes
::
::
++  subst-label
  ::  \N and \G substitutions; anything else passes through
  |=  [t=@t name=@t gname=@t]
  ^-  @t
  =/  tp  (trip t)
  %-  crip
  |-  ^-  tape
  ?~  tp  ~
  ?.  =('\\' i.tp)  [i.tp $(tp t.tp)]
  ?~  t.tp  [i.tp ~]
  ?:  =('N' i.t.tp)  (weld (trip name) $(tp t.t.tp))
  ?:  =('G' i.t.tp)  (weld (trip gname) $(tp t.t.tp))
  [i.tp i.t.tp $(tp t.t.tp)]
::
++  subst-edge-label
  ::  \T, \H, and \E substitutions used when measuring edge labels
  |=  [tp=tape tname=tape hname=tape op=tape]
  ^-  tape
  |-  ^-  tape
  ?~  tp  ~
  ?.  =('\\' i.tp)  [i.tp $(tp t.tp)]
  ?~  t.tp  [i.tp ~]
  ?:  =('T' i.t.tp)  (weld tname $(tp t.t.tp))
  ?:  =('H' i.t.tp)  (weld hname $(tp t.t.tp))
  ?:  =('E' i.t.tp)
    (weld (zing ~[tname op hname]) $(tp t.t.tp))
  [i.tp i.t.tp $(tp t.t.tp)]
::
++  edge-label-ranksep
  ::  Reserve enough rank-axis room to center labels between nodes
  |=  [res=resolved:attr horiz=?]
  ^-  @rs
  %+  roll  edges.res
  |=  [e=redge:attr best=@rs]
  =/  raw  (~(get by attrs.e) 'label')
  ?~  raw  best
  =/  tail-name  name:(snag tail.e nodes.res)
  =/  head-name  name:(snag head.e nodes.res)
  =/  text
    %-  crip
    %:  subst-edge-label
      (trip u.raw)
      (trip tail-name)
      (trip head-name)
      ?:(directed.res "->" "--")
    ==
  =/  gvd  ~(. gv:attr attrs.e)
  =/  size  (text-size:metrics (rd-rs fontsize:gvd) text)
  =/  extent  ?:(horiz w.size h.size)
  (rmax best (add:rs extent .16))
::
++  node-label
  |=  [res=resolved:attr v=@ud]
  ^-  @t
  =/  n  (snag v nodes.res)
  %^  subst-label  ~(label gv:attr attrs.n)
    name.n
  ?~(id.res '' u.id.res)
::
++  node-dims
  ::  label + margins, shape expansion, minima, fixedsize
  |=  [res=resolved:attr v=@ud]
  ^-  [w=@rs h=@rs]
  =/  n  (snag v nodes.res)
  =/  gvd  ~(. gv:attr attrs.n)
  =/  minw  (mul:rs (rd-rs width:gvd) .72)
  =/  minh  (mul:rs (rd-rs height:gvd) .72)
  ?:  fixedsize:gvd  [minw minh]
  =/  ts  (text-size:metrics (rd-rs fontsize:gvd) (node-label res v))
  =/  shp  shape:gvd
  =/  elly  |(=('ellipse' shp) =('circle' shp) =('oval' shp))
  =/  bw  (add:rs w.ts .16)
  =/  bh  (add:rs h.ts .8)
  =/  w  (rmax minw ?:(elly (mul:rs bw .1.414214) bw))
  =/  h  (rmax minh ?:(elly (mul:rs bh .1.414214) bh))
  ?.  =('circle' shp)  [w h]
  [(rmax w h) (rmax w h)]
::  +|  Main
::
::
++  coord-graph
  |=  [res=resolved:attr g=ranked:rank o=ordered:order]
  ^-  coords
  ?:  =(0 nall.g)
    [0 0 %tb [.0 .0] .1 ~ ~]
  =/  nreal  (lent nodes.res)
  =/  dims=(map @ud [w=@rs h=@rs])
    =/  m
      %+  roll  (gulf 0 (dec nreal))
      |=  [v=@ud m=(map @ud [w=@rs h=@rs])]
      (~(put by m) v (node-dims res v))
    ?:  (lte nall.g nreal)  m
    %+  roll  (gulf nreal (dec nall.g))
    |=  [v=@ud m2=_m]
    (~(put by m2) v [.1 .1])
  =/  horiz  |(=(%lr rankdir.g) =(%rl rankdir.g))
  =/  ranksep
    =/  base  (mul:rs (rd-rs ~(ranksep gv:attr gattrs.res)) .72)
    (rmax base (edge-label-ranksep res horiz))
  =/  smp=csamp
    :*  nall.g
        nreal
        nrank.g
        horiz
        (mul:rs (rd-rs ~(nodesep gv:attr gattrs.res)) .72)
        ranksep
        order.o
        ranks.g
        (adj-of g %.y)
        (adj-of g %.n)
        (~(run by dims) |=([w=@rs h=@rs] ?:(horiz h w)))
        (~(run by dims) |=([w=@rs h=@rs] ?:(horiz w h)))
        (prio-of g nreal)
    ==
  =/  xs  (xpasses smp (xinit smp))
  =/  geo  (rank-geom smp)
  =/  all  (gulf 0 (dec nall.g))
  ::  normalize left edge to 0
  =/  minx
    =/  vs  all
    =/  best  (sub:rs (~(got by xs) 0) (half (~(got by ww.smp) 0)))
    |-  ^-  @rs
    ?~  vs  best
    =/  e  (sub:rs (~(got by xs) i.vs) (half (~(got by ww.smp) i.vs)))
    $(vs t.vs, best (rmin best e))
  =/  xs
    (~(run by xs) |=(x=@rs (sub:rs x minx)))
  =/  wtot
    =/  vs  all
    =/  best  .0
    |-  ^-  @rs
    ?~  vs  best
    =/  e  (add:rs (~(got by xs) i.vs) (half (~(got by ww.smp) i.vs)))
    $(vs t.vs, best (rmax best e))
  =/  htot  total.geo
  =/  pos=(map @ud [x=@rs y=@rs])
    %+  roll  all
    |=  [v=@ud m=(map @ud [x=@rs y=@rs])]
    =/  cx  (~(got by xs) v)
    =/  cy  (snag (~(got by rof.smp) v) cys.geo)
    %+  ~(put by m)  v
    ?-  rankdir.g
      %tb  [cx (sub:rs htot cy)]
      %bt  [cx cy]
      %lr  [cy (sub:rs wtot cx)]
      %rl  [(sub:rs htot cy) (sub:rs wtot cx)]
    ==
  =/  size=[w=@rs h=@rs]  ?:(horiz [htot wtot] [wtot htot])
  =/  clustered  ?=(^ clusters.res)
  =/  pos
    ?.  clustered  pos
    %-  ~(run by pos)
    |=  p=[x=@rs y=@rs]
    [(add:rs x.p .8) (add:rs y.p .8)]
  =/  size
    ?.  clustered  size
    [(add:rs w.size .16) (add:rs h.size .34)]
  :*  nreal
      nall.g
      rankdir.g
      size
      (scale-for gattrs.res size)
      pos
      dims
  ==
::
++  adj-of
  ::  upward (toward lower rank) or downward segment neighbors
  |=  [g=ranked:rank upward=?]
  ^-  (map @ud (list @ud))
  =/  m
    %+  roll  edges.g
    |=  [re=rank-edge:rank m=(map @ud (list @ud))]
    ?:  flat.re  m
    %+  roll  (segs:order path.re)
    |=  [[u=@ud v=@ud] m2=_m]
    ?:  upward
      (~(put by m2) v [u (~(gut by m2) v ~)])
    (~(put by m2) u [v (~(gut by m2) u ~)])
  (~(run by m) flop)
::
++  prio-of
  ::  virtual nodes get effectively infinite priority
  |=  [g=ranked:rank nreal=@ud]
  ^-  (map @ud @ud)
  =/  deg=(map @ud @ud)
    %+  roll  edges.g
    |=  [re=rank-edge:rank m=(map @ud @ud)]
    ?:  flat.re  m
    %+  roll  (segs:order path.re)
    |=  [[u=@ud v=@ud] m2=_m]
    =.  m2  (~(put by m2) u +((~(gut by m2) u 0)))
    (~(put by m2) v +((~(gut by m2) v 0)))
  %+  roll  (gulf 0 (dec nall.g))
  |=  [v=@ud m=(map @ud @ud)]
  %+  ~(put by m)  v
  ?:  (gte v nreal)  1.000
  (~(gut by deg) v 0)
::  +|  Rank axis
::
::
++  rank-geom
  |=  smp=csamp
  ^-  [cys=(list @rs) total=@rs]
  =/  hs=(list @rs)
    %+  turn  rows.smp
    |=  row=(list @ud)
    %+  roll  row
    |=  [v=@ud acc=@rs]
    (rmax (~(got by hh.smp) v) acc)
  =/  cys=(list @rs)
    =/  prev=(unit [cy=@rs h=@rs])  ~
    =/  ls  hs
    =|  out=(list @rs)
    |-  ^-  (list @rs)
    ?~  ls  (flop out)
    =/  cy
      ?~  prev  (half i.ls)
      ;:  add:rs
        cy.u.prev
        (half h.u.prev)
        ranksep.smp
        (half i.ls)
      ==
    $(ls t.ls, prev `[cy i.ls], out [cy out])
  :-  cys
  ?~  cys  .0
  (add:rs (rlast `(list @rs)`cys) (half (rlast hs)))
::  +|  Within-rank axis: priority/median method
::
::
++  xinit
  ::  pack each rank left to right in P8 order
  |=  smp=csamp
  ^-  (map @ud @rs)
  %+  roll  rows.smp
  |=  [row=(list @ud) xs=(map @ud @rs)]
  =/  prev=(unit @ud)  ~
  |-  ^-  (map @ud @rs)
  ?~  row  xs
  =/  x
    ?~  prev  (half (~(got by ww.smp) i.row))
    ;:  add:rs
      (~(got by xs) u.prev)
      (half (~(got by ww.smp) u.prev))
      nodesep.smp
      (half (~(got by ww.smp) i.row))
    ==
  $(row t.row, prev `i.row, xs (~(put by xs) i.row x))
::
++  xpasses
  |=  [smp=csamp xs=(map @ud @rs)]
  ^-  (map @ud @rs)
  =/  i  0
  |-  ^-  (map @ud @rs)
  ?:  =(8 i)  xs
  $(i +(i), xs (xpass smp xs =(0 (mod i 2))))
::
++  xpass
  |=  [smp=csamp xs=(map @ud @rs) downward=?]
  ^-  (map @ud @rs)
  ?:  (lte nrank.smp 1)  xs
  =/  rseq=(list @ud)
    ?:  downward  (gulf 1 (dec nrank.smp))
    (flop (gulf 0 (sub nrank.smp 2)))
  =/  adj  ?:(downward up.smp down.smp)
  |-  ^-  (map @ud @rs)
  ?~  rseq  xs
  $(rseq t.rseq, xs (xrank smp xs (snag i.rseq rows.smp) adj))
::
++  xrank
  ::  process one rank's nodes in descending priority
  |=  [smp=csamp xs=(map @ud @rs) row=(list @ud) adj=(map @ud (list @ud))]
  ^-  (map @ud @rs)
  =/  dec-list=(list [p=@ud x=@ud v=@ud])
    =/  ix  0
    =/  ms  row
    =|  out=(list [p=@ud x=@ud v=@ud])
    |-  ^-  (list [p=@ud x=@ud v=@ud])
    ?~  ms  (flop out)
    %=  $
      ms   t.ms
      ix   +(ix)
      out  [[(~(got by prio.smp) i.ms) ix i.ms] out]
    ==
  =/  bypr
    %+  turn
      %+  sort  dec-list
      |=  [a=[p=@ud x=@ud v=@ud] b=[p=@ud x=@ud v=@ud]]
      ?:  =(p.a p.b)  (lth x.a x.b)
      (gth p.a p.b)
    |=([p=@ud x=@ud v=@ud] v)
  |-  ^-  (map @ud @rs)
  ?~  bypr  xs
  $(bypr t.bypr, xs (xmove smp xs row i.bypr adj))
::
++  xmove
  |=  $:  smp=csamp
          xs=(map @ud @rs)
          row=(list @ud)
          v=@ud
          adj=(map @ud (list @ud))
      ==
  ^-  (map @ud @rs)
  =/  ns  (~(gut by adj) v ~)
  ?~  ns  xs
  =/  desired
    (median-x (turn `(list @ud)`ns |=(u=@ud (~(got by xs) u))))
  =/  cur  (~(got by xs) v)
  ?:  =(desired cur)  xs
  =/  p  (~(got by prio.smp) v)
  ?:  (gth:rs desired cur)
    (shove-right smp xs row v p desired)
  (shove-left smp xs row v p desired)
::
++  gap2
  |=  [smp=csamp a=@ud b=@ud]
  ^-  @rs
  ;:  add:rs
    (half (~(got by ww.smp) a))
    nodesep.smp
    (half (~(got by ww.smp) b))
  ==
::
++  after
  |=  [row=(list @ud) v=@ud]
  ^-  (list @ud)
  =/  ms  row
  |-  ^-  (list @ud)
  ?~  ms  ~
  ?:(=(v i.ms) t.ms $(ms t.ms))
::
++  before
  ::  nodes left of v, nearest first
  |=  [row=(list @ud) v=@ud]
  ^-  (list @ud)
  =|  acc=(list @ud)
  =/  ms  row
  |-  ^-  (list @ud)
  ?~  ms  ~
  ?:  =(v i.ms)  acc
  $(ms t.ms, acc [i.ms acc])
::
++  shove-right
  |=  $:  smp=csamp
          xs=(map @ud @rs)
          row=(list @ud)
          v=@ud
          p=@ud
          desired=@rs
      ==
  ^-  (map @ud @rs)
  =/  post  (after row v)
  =/  limit=(unit @rs)
    =/  req  .0
    =/  prev  v
    =/  ms  post
    |-  ^-  (unit @rs)
    ?~  ms  ~
    =/  req2  (add:rs req (gap2 smp prev i.ms))
    ?:  (gte (~(got by prio.smp) i.ms) p)
      `(sub:rs (~(got by xs) i.ms) req2)
    $(ms t.ms, prev i.ms, req req2)
  =/  newx
    ?~  limit  desired
    (rmin u.limit desired)
  ?:  (lte:rs newx (~(got by xs) v))  xs
  =.  xs  (~(put by xs) v newx)
  =/  prev  v
  =/  ms  post
  |-  ^-  (map @ud @rs)
  ?~  ms  xs
  =/  need  (add:rs (~(got by xs) prev) (gap2 smp prev i.ms))
  ?:  (gte:rs (~(got by xs) i.ms) need)  xs
  $(ms t.ms, prev i.ms, xs (~(put by xs) i.ms need))
::
++  shove-left
  |=  $:  smp=csamp
          xs=(map @ud @rs)
          row=(list @ud)
          v=@ud
          p=@ud
          desired=@rs
      ==
  ^-  (map @ud @rs)
  =/  pre  (before row v)
  =/  limit=(unit @rs)
    =/  req  .0
    =/  prev  v
    =/  ms  pre
    |-  ^-  (unit @rs)
    ?~  ms  ~
    =/  req2  (add:rs req (gap2 smp prev i.ms))
    ?:  (gte (~(got by prio.smp) i.ms) p)
      `(add:rs (~(got by xs) i.ms) req2)
    $(ms t.ms, prev i.ms, req req2)
  =/  newx
    ?~  limit  desired
    (rmax u.limit desired)
  ?:  (gte:rs newx (~(got by xs) v))  xs
  =.  xs  (~(put by xs) v newx)
  =/  prev  v
  =/  ms  pre
  |-  ^-  (map @ud @rs)
  ?~  ms  xs
  =/  need  (sub:rs (~(got by xs) prev) (gap2 smp prev i.ms))
  ?:  (lte:rs (~(got by xs) i.ms) need)  xs
  $(ms t.ms, prev i.ms, xs (~(put by xs) i.ms need))
::  +|  Scaling
::
::
++  scale-for
  ::  size="w,h" (or "s") in inches: scale factor <= 1 for codegen
  |=  [gat=attrs:attr drawn=[w=@rs h=@rs]]
  ^-  @rs
  =/  sz  (~(get by gat) 'size')
  ?~  sz  .1
  =/  parts  (split-comma:attr (trip u.sz))
  =/  vals=(list @rs)
    %+  murn  parts
    |=  tp=tape
    (bind (to-rd:attr (crip tp)) rd-rs)
  =/  mw=(unit @rs)
    ?~  vals  ~
    `(mul:rs i.vals .72)
  =/  mh=(unit @rs)
    ?~  vals  ~
    ?~  t.vals  `(mul:rs i.vals .72)
    `(mul:rs i.t.vals .72)
  ?~  mw  .1
  ?~  mh  .1
  ?:  |((lte:rs w.drawn .0) (lte:rs h.drawn .0))  .1
  %+  rmin  .1
  (rmin (div:rs u.mw w.drawn) (div:rs u.mh h.drawn))
--
