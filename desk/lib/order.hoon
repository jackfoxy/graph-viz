::  order: ordering / crossing reduction (P8)
::
::  Per GKNV93 section 3 / lib/dotgen/mincross.c: initial order by
::  DFS from low ranks, then up to 8 iterations of weighted-median
::  sweeps (alternating down/up) each followed by transpose
::  (adjacent-swap) passes, keeping the best order seen by total
::  crossing count.  Iteration count and the median formula follow
::  the paper exactly.
::
::  v1 constraints: cluster members (innermost cluster only) are
::  kept contiguous within each rank after every pass; flat edges
::  forbid transpose swaps that would invert them and a final
::  stable topological pass puts flat tails before heads.  Full
::  recursive cluster layout is post-v1.
::
/+  attr=attr, rank=rank
|%
::  +|  Types
::
::
+$  ordered
  $:  order=(list (list @ud))    :: per rank, node ids left-to-right
      pos=(map @ud @ud)          :: node -> position within its rank
      crossings=@ud
  ==
::
+$  osamp
  $:  nrank=@ud
      rof=(map @ud @ud)
      down=(map @ud (list @ud))
      up=(map @ud (list @ud))
      flats=(list [t=@ud h=@ud])
      fset=(set [t=@ud h=@ud])
      clus=(map @ud @ud)
      all=(list @ud)
  ==
::
+$  ostate  [seen=(set @ud) acc=(map @ud (list @ud))]
::  +|  Public API
::
::
++  order-graph
  |=  [rs=resolved:attr g=ranked:rank]
  ^-  ordered
  ?:  =(0 nall.g)  [~ ~ 0]
  ~(run ord (prep rs g))
::
++  initial-crossings
  ::  crossings of the initial (pre-mincross) order, for the
  ::  never-worse property test
  |=  [rs=resolved:attr g=ranked:rank]
  ^-  @ud
  ?:  =(0 nall.g)  0
  =/  d  ~(. ord (prep rs g))
  (count:d base:d)
::  +|  Preparation
::
::
++  prep
  |=  [rs=resolved:attr g=ranked:rank]
  ^-  osamp
  =/  dn0=(map @ud (list @ud))
    %+  roll  edges.g
    |=  [re=rank-edge:rank m=(map @ud (list @ud))]
    ?:  flat.re  m
    %+  roll  (segs path.re)
    |=  [[u=@ud v=@ud] m2=_m]
    (~(put by m2) u [v (~(gut by m2) u ~)])
  =/  down  (~(run by dn0) flop)
  =/  up0=(map @ud (list @ud))
    %+  roll  edges.g
    |=  [re=rank-edge:rank m=(map @ud (list @ud))]
    ?:  flat.re  m
    %+  roll  (segs path.re)
    |=  [[u=@ud v=@ud] m2=_m]
    (~(put by m2) v [u (~(gut by m2) v ~)])
  =/  up  (~(run by up0) flop)
  =/  flats=(list [t=@ud h=@ud])
    %+  murn  edges.g
    |=  re=rank-edge:rank
    ^-  (unit [t=@ud h=@ud])
    ?.  flat.re  ~
    =/  t  (snag 0 path.re)
    =/  h  (rear path.re)
    ?:  =(t h)  ~
    ?.  =((~(got by ranks.g) t) (~(got by ranks.g) h))  ~
    `[t h]
  =/  clus  (cluster-map rs g)
  :*  nrank.g
      ranks.g
      down
      up
      flats
      (silt flats)
      clus
      (gulf 0 (dec nall.g))
  ==
::
++  segs
  ::  consecutive pairs of a path
  |=  p=(list @ud)
  ^-  (list [u=@ud v=@ud])
  =|  out=(list [u=@ud v=@ud])
  |-  ^-  (list [u=@ud v=@ud])
  ?~  p  (flop out)
  ?~  t.p  (flop out)
  $(p t.p, out [[i.p i.t.p] out])
::
++  cluster-map
  ::  node -> innermost cluster index; virtual nodes take the
  ::  cluster shared by both endpoints of their edge, if any
  |=  [rs=resolved:attr g=ranked:rank]
  ^-  (map @ud @ud)
  =/  cls  clusters.rs
  ?~  cls  ~
  =/  ncl  (lent cls)
  =/  depth
    |=  i=@ud
    ^-  @ud
    =/  d  0
    |-  ^-  @ud
    =/  p  parent:(snag i `(list rcluster:attr)`cls)
    ?~  p  d
    $(i u.p, d +(d))
  =/  base=(map @ud @ud)
    =|  m=(map @ud @ud)
    =/  i  0
    |-  ^-  (map @ud @ud)
    ?:  =(i ncl)  m
    =/  c  (snag i `(list rcluster:attr)`cls)
    =/  d  (depth i)
    =/  m2
      %+  roll  ~(tap in nodes.c)
      |=  [v=@ud acc=_m]
      =/  old  (~(get by acc) v)
      ?~  old  (~(put by acc) v i)
      ?:  (gte d (depth u.old))  (~(put by acc) v i)
      acc
    $(i +(i), m m2)
  ::  virtuals inherit a cluster shared by both edge endpoints
  %+  roll  edges.g
  |=  [re=rank-edge:rank m=_base]
  ?:  flat.re  m
  ?:  (lte (lent path.re) 2)  m
  =/  ct  (~(get by base) (snag 0 path.re))
  =/  ch  (~(get by base) (rear path.re))
  ?~  ct  m
  ?~  ch  m
  ?.  =(u.ct u.ch)  m
  =/  mids  (snip (slag 1 path.re))
  %+  roll  mids
  |=  [v=@ud m2=_m]
  (~(put by m2) v u.ct)
::  +|  Ordering engine
::
::
++  ord
  |_  smp=osamp
  ::
  ++  run
    ^-  ordered
    =/  a  (mincross base %.y)
    =/  b  (mincross base %.n)
    =/  fin  ?:((lte x.a x.b) ord.a ord.b)
    [fin (mk-pos fin) (count fin)]
  ::
  ++  mincross
    ::  one full pass; down-first selects sweep parity
    |=  [cur=(list (list @ud)) down-first=?]
    ^-  [x=@ud ord=(list (list @ud))]
    =/  best  cur
    =/  bestx  (count cur)
    =/  i  0
    |-  ^-  [x=@ud ord=(list (list @ud))]
    ?:  |(=(24 i) =(0 bestx))
      [bestx best]
    =/  nxt
      %-  flat-fix
      %-  clusterize
      %+  transpose
        (flat-fix (wmedian cur =(down-first =(0 (mod i 2)))))
      =(1 (mod i 4))
    =/  x  (count nxt)
    ?:  (lth x bestx)
      $(i +(i), cur nxt, best nxt, bestx x)
    $(i +(i), cur nxt)
  ::
  ++  base  (flat-fix (clusterize init-order))
  ::
  ++  init-order
    ::  BFS placement following down-segments (mincross.c
    ::  build_ranks uses a queue)
    ^-  (list (list @ud))
    ?:  =(0 nrank.smp)  ~
    =|  st=ostate
    =/  vs  all.smp
    =.  st
      |-  ^-  ostate
      ?~  vs  st
      ?:  (~(has in seen.st) i.vs)  $(vs t.vs)
      =.  st  (bfs st [i.vs ~])
      $(vs t.vs)
    %+  turn  (gulf 0 (dec nrank.smp))
    |=(r=@ud (flop (~(gut by acc.st) r ~)))
  ::
  ++  bfs
    |=  [st=ostate q=(list @ud)]
    ^-  ostate
    ?~  q  st
    =/  v  i.q
    ?:  (~(has in seen.st) v)  $(q t.q)
    =.  seen.st  (~(put in seen.st) v)
    =/  r  (~(got by rof.smp) v)
    =.  acc.st  (~(put by acc.st) r [v (~(gut by acc.st) r ~)])
    =/  ns
      %+  skip  (~(gut by down.smp) v ~)
      |=(x=@ud (~(has in seen.st) x))
    $(q (weld t.q ns))
  ::
  ++  mk-pos
    |=  order=(list (list @ud))
    ^-  (map @ud @ud)
    %+  roll  order
    |=  [members=(list @ud) m=(map @ud @ud)]
    =/  p  0
    |-  ^-  (map @ud @ud)
    ?~  members  m
    $(members t.members, p +(p), m (~(put by m) i.members p))
  ::
  ++  inversions
    |=  xs=(list @ud)
    ^-  @ud
    =/  total  0
    |-  ^-  @ud
    ?~  xs  total
    %=  $
      xs     t.xs
      total  (add total (lent (skim t.xs |=(y=@ud (lth y i.xs)))))
    ==
  ::
  ++  count
    ::  total crossings between all adjacent rank pairs
    |=  order=(list (list @ud))
    ^-  @ud
    ?:  (lte nrank.smp 1)  0
    =/  pos  (mk-pos order)
    =/  r  0
    =/  total  0
    |-  ^-  @ud
    ?:  =(r (dec nrank.smp))  total
    =/  seq
      %-  zing
      %+  turn  (snag r order)
      |=  u=@ud
      %+  sort
        %+  turn  (~(gut by down.smp) u ~)
        |=(v=@ud (~(got by pos) v))
      lth
    $(r +(r), total (add total (inversions seq)))
  ::
  ++  median-of
    ::  GKNV93 median_value over sorted neighbor positions
    |=  ps=(list @ud)
    ^-  (unit @rs)
    =/  k  (lent ps)
    ?:  =(0 k)  ~
    =/  m  (div k 2)
    ?:  =(1 (mod k 2))  `(sun:rs (snag m ps))
    ?:  =(2 k)
      `(div:rs (sun:rs (add (snag 0 ps) (snag 1 ps))) .2)
    =/  left  (sub (snag (dec m) ps) (snag 0 ps))
    =/  right  (sub (snag (dec k) ps) (snag m ps))
    ?:  =(0 (add left right))
      `(div:rs (sun:rs (add (snag (dec m) ps) (snag m ps))) .2)
    %-  some
    %+  div:rs
      %+  add:rs
        (mul:rs (sun:rs (snag (dec m) ps)) (sun:rs right))
      (mul:rs (sun:rs (snag m ps)) (sun:rs left))
    (sun:rs (add left right))
  ::
  ++  wmedian
    |=  [order=(list (list @ud)) down-sweep=?]
    ^-  (list (list @ud))
    ?:  (lte nrank.smp 1)  order
    =/  rs=(list @ud)
      ?:  down-sweep  (gulf 1 (dec nrank.smp))
      (flop (gulf 0 (sub nrank.smp 2)))
    |-  ^-  (list (list @ud))
    ?~  rs  order
    =/  pos  (mk-pos order)
    =/  members  (snag i.rs order)
    =/  adj  ?:(down-sweep up.smp down.smp)
    =/  meds=(map @ud @rs)
      %+  roll  members
      |=  [v=@ud m=(map @ud @rs)]
      =/  ps
        %+  sort
          %+  turn  (~(gut by adj) v ~)
          |=(x=@ud (~(got by pos) x))
        lth
      =/  md  (median-of ps)
      ?~(md m (~(put by m) v u.md))
    $(rs t.rs, order (snap order i.rs (apply-medians members meds)))
  ::
  ++  apply-medians
    ::  nodes without medians hold their slots; the rest sort by
    ::  median, stable on prior order
    |=  [members=(list @ud) meds=(map @ud @rs)]
    ^-  (list @ud)
    =/  dec=(list [m=@rs x=@ud v=@ud])
      =/  ix  0
      =/  ms  members
      =|  out=(list [m=@rs x=@ud v=@ud])
      |-  ^-  (list [m=@rs x=@ud v=@ud])
      ?~  ms  (flop out)
      =/  md  (~(get by meds) i.ms)
      ?~  md  $(ms t.ms)
      $(ms t.ms, ix +(ix), out [[u.md ix i.ms] out])
    =/  sorted
      %+  sort  dec
      |=  [a=[m=@rs x=@ud v=@ud] b=[m=@rs x=@ud v=@ud]]
      ?:  =(m.a m.b)  (lth x.a x.b)
      (lth:rs m.a m.b)
    =/  ms  members
    |-  ^-  (list @ud)
    ?~  ms  ~
    ?.  (~(has by meds) i.ms)
      [i.ms $(ms t.ms)]
    ?~  sorted  [i.ms $(ms t.ms)]
    [v.i.sorted $(ms t.ms, sorted t.sorted)]
  ::
  ++  pcross
    ::  crossings contributed by v's neighbors right of w's
    |=  [pos=(map @ud @ud) va=(list @ud) wa=(list @ud)]
    ^-  @ud
    =/  wp  (turn wa |=(x=@ud (~(got by pos) x)))
    %+  roll  va
    |=  [x=@ud acc=@ud]
    =/  a  (~(got by pos) x)
    (add acc (lent (skim wp |=(b=@ud (lth b a)))))
  ::
  ++  transpose
    ::  rev swaps equal-cost pairs too, escaping local minima
    ::  (mincross.c does the same on alternating iterations)
    |=  [order=(list (list @ud)) rev=?]
    ^-  (list (list @ud))
    =/  round  0
    |-  ^-  (list (list @ud))
    ?:  =(16 round)  order
    =/  res  (transpose-once order rev)
    ?.  changed.res  order.res
    $(round +(round), order order.res, rev %.n)
  ::
  ++  transpose-once
    |=  [order=(list (list @ud)) rev=?]
    ^-  [changed=? order=(list (list @ud))]
    =/  pos  (mk-pos order)
    =/  r  0
    =/  changed=?  %.n
    |-  ^-  [changed=? order=(list (list @ud))]
    ?:  =(r nrank.smp)  [changed order]
    =/  sw  (sweep-rank (snag r order) pos rev)
    %=  $
      r        +(r)
      order    (snap order r order.sw)
      pos      pos.sw
      changed  |(changed changed.sw)
    ==
  ::
  ++  sweep-rank
    |=  [members=(list @ud) pos=(map @ud @ud) rev=?]
    ^-  [changed=? order=(list @ud) pos=(map @ud @ud)]
    =/  changed=?  %.n
    =|  done=(list @ud)
    |-  ^-  [changed=? order=(list @ud) pos=(map @ud @ud)]
    ?~  members  [changed (flop done) pos]
    ?~  t.members  [changed (flop [i.members done]) pos]
    =/  v  i.members
    =/  w  i.t.members
    ?:  (~(has in fset.smp) [v w])
      $(members t.members, done [v done])
    =/  c1
      %+  add
        (pcross pos (~(gut by up.smp) v ~) (~(gut by up.smp) w ~))
      (pcross pos (~(gut by down.smp) v ~) (~(gut by down.smp) w ~))
    =/  c2
      %+  add
        (pcross pos (~(gut by up.smp) w ~) (~(gut by up.smp) v ~))
      (pcross pos (~(gut by down.smp) w ~) (~(gut by down.smp) v ~))
    ?.  ?|  (lth c2 c1)
            &(rev =(c2 c1) (gth c1 0))
        ==
      $(members t.members, done [v done])
    =/  pv  (~(got by pos) v)
    =/  pw  (~(got by pos) w)
    %=  $
      members  [v t.t.members]
      done     [w done]
      changed  %.y
      pos      (~(put by (~(put by pos) v pw)) w pv)
    ==
  ::
  ++  clusterize
    ::  keep innermost-cluster members contiguous, stably
    |=  order=(list (list @ud))
    ^-  (list (list @ud))
    ?:  =(~ clus.smp)  order
    %+  turn  order
    |=  members=(list @ud)
    =|  done=(set @ud)
    =/  ms  members
    |-  ^-  (list @ud)
    ?~  ms  ~
    =/  c  (~(get by clus.smp) i.ms)
    ?~  c  [i.ms $(ms t.ms)]
    ?:  (~(has in done) u.c)  $(ms t.ms)
    %+  weld
      %+  skim  members
      |=(v=@ud =(`u.c (~(get by clus.smp) v)))
    $(ms t.ms, done (~(put in done) u.c))
  ::
  ++  flat-fix
    ::  stable topological order within ranks by flat edges
    |=  order=(list (list @ud))
    ^-  (list (list @ud))
    ?:  =(~ flats.smp)  order
    %+  turn  order
    |=  members=(list @ud)
    =/  mset  (silt members)
    =/  cons
      %+  skim  flats.smp
      |=  [t=@ud h=@ud]
      &((~(has in mset) t) (~(has in mset) h))
    ?~  cons  members
    =|  out=(list @ud)
    |-  ^-  (list @ud)
    ?~  members  (flop out)
    =/  left  (silt `(list @ud)`members)
    =/  pick
      =/  ms  `(list @ud)`members
      |-  ^-  (unit @ud)
      ?~  ms  ~
      =/  blocked
        %+  lien  `(list [t=@ud h=@ud])`cons
        |=  [t=@ud h=@ud]
        &(=(h i.ms) (~(has in left) t) !=(t i.ms))
      ?:  blocked  $(ms t.ms)
      `i.ms
    ?~  pick
      (weld (flop out) `(list @ud)`members)
    %=  $
      members  (skip `(list @ud)`members |=(v=@ud =(v u.pick)))
      out      [u.pick out]
    ==
  --
--
