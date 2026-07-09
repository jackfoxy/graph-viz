::  rank: rank assignment (P7)
::
::  Per GKNV93 / lib/dotgen/rank.c: rank groups collapse into union
::  leaders (which can reintroduce cycles, so cycle breaking runs
::  again in leader space); longest-path sets initial leader ranks
::  honoring per-edge minlen; tightening pulls slack out of source
::  nodes; ranks normalize to 0; min/source and max/sink groups are
::  then forced to the extreme ranks, dot-style (edges they violate
::  become flat edges).  Edges spanning more than one rank get
::  virtual-node chains; same-rank edges are tagged flat.
::
::  Network-simplex refinement is a separable follow-up behind the
::  same interface.  rankdir is carried through untouched here: it
::  is a geometry transform applied at coordinates (P9) and codegen.
::
/+  attr=attr, acyc=acyc
|%
::  +|  Types
::
::  $rank-edge: one drawable edge after ranking.  path runs from
::  tail to head through any virtual nodes; flat edges (equal or
::  inverted ranks) keep just [tail head].  Self-loops come out
::  flat with tail = head.
::
+$  rank-edge  [eix=@ud rev=? flat=? path=(list @ud)]
::
+$  ranked
  $:  nreal=@ud
      nall=@ud
      nrank=@ud
      rankdir=?(%tb %lr %bt %rl)
      ranks=(map @ud @ud)
      edges=(list rank-edge)
  ==
::  $cedge: working edge with leader endpoints and minlen
::
+$  cedge
  $:  eix=@ud
      rev=?
      tail=@ud
      head=@ud
      lt=@ud
      lh=@ud
      ml=@ud
  ==
::  +|  Main
::
::
++  rank-graph
  |=  rs=resolved:attr
  ^-  ranked
  =/  n  (lent nodes.rs)
  =/  rd  ~(rankdir gv:attr gattrs.rs)
  ?:  =(0 n)
    [0 0 0 rd ~ ~]
  =/  uf  (build-uf ranks.rs)
  =/  ces  (collapse rs uf (from-resolved:acyc rs))
  =/  lr  (rank-leaders n uf ces)
  =/  minset
    (leaders-of uf ranks.rs (silt `(list rank-type:attr)`~[%min %source]))
  =/  maxset
    (leaders-of uf ranks.rs (silt `(list rank-type:attr)`~[%max %sink]))
  =.  lr  (force lr minset maxset)
  =/  nranks=(map @ud @ud)
    %+  roll  (gulf 0 (dec n))
    |=  [v=@ud m=(map @ud @ud)]
    (~(put by m) v (~(got by lr) (find-uf uf v)))
  =/  ch  (chains n nranks ces)
  [n nall.ch +((max-val ranks.ch)) rd ranks.ch edges.ch]
::  +|  Collapsing (rank groups)
::
::
++  collapse
  ::  map edges into leader space and re-break any cycles the
  ::  rank-group unions introduced
  |=  [rs=resolved:attr uf=(map @ud @ud) aes=(list aedge:acyc)]
  ^-  (list cedge)
  =/  base=(list cedge)
    %+  turn  aes
    |=  ae=aedge:acyc
    =/  e  (snag eix.ae edges.rs)
    :*  eix.ae
        rev.ae
        tail.ae
        head.ae
        (find-uf uf tail.ae)
        (find-uf uf head.ae)
        ~(minlen gv:attr attrs.e)
    ==
  =/  rb
    %+  break-cycles:acyc  (lent nodes.rs)
    (turn base |=(c=cedge [lt.c lh.c]))
  |-  ^-  (list cedge)
  ?~  base  ~
  ?~  rb  ~
  :_  $(base t.base, rb t.rb)
  ?.  rev.i.rb  i.base
  %=  i.base
    rev   !rev.i.base
    tail  head.i.base
    head  tail.i.base
    lt    lh.i.base
    lh    lt.i.base
  ==
::
++  build-uf
  |=  gs=(list rgroup:attr)
  ^-  (map @ud @ud)
  =|  m=(map @ud @ud)
  |-  ^-  (map @ud @ud)
  ?~  gs  m
  $(gs t.gs, m (union-all m nodes.i.gs))
::
++  union-all
  |=  [m=(map @ud @ud) ns=(list @ud)]
  ^-  (map @ud @ud)
  ?~  ns  m
  =/  first  i.ns
  =/  rest  t.ns
  |-  ^-  (map @ud @ud)
  ?~  rest  m
  $(rest t.rest, m (uf-union m first i.rest))
::
++  uf-union
  |=  [m=(map @ud @ud) a=@ud b=@ud]
  ^-  (map @ud @ud)
  =/  ra  (find-uf m a)
  =/  rb  (find-uf m b)
  ?:  =(ra rb)  m
  (~(put by m) rb ra)
::
++  find-uf
  |=  [m=(map @ud @ud) v=@ud]
  ^-  @ud
  =/  p  (~(gut by m) v v)
  ?:  =(p v)  v
  $(v p)
::
++  leaders-of
  |=  [uf=(map @ud @ud) gs=(list rgroup:attr) which=(set rank-type:attr)]
  ^-  (set @ud)
  =|  out=(set @ud)
  |-  ^-  (set @ud)
  ?~  gs  out
  ?.  (~(has in which) typ.i.gs)  $(gs t.gs)
  ?~  nodes.i.gs  $(gs t.gs)
  $(gs t.gs, out (~(put in out) (find-uf uf i.nodes.i.gs)))
::  +|  Ranking
::
::
++  rank-leaders
  ::  longest-path + source tightening + normalization
  |=  [n=@ud uf=(map @ud @ud) ces=(list cedge)]
  ^-  (map @ud @ud)
  =/  leaders=(list @ud)
    %~  tap  in
    %+  roll  (gulf 0 (dec n))
    |=  [v=@ud acc=(set @ud)]
    (~(put in acc) (find-uf uf v))
  =/  ins=(map @ud (list [frm=@ud ml=@ud]))
    %+  roll  ces
    |=  [c=cedge m=(map @ud (list [frm=@ud ml=@ud]))]
    ?:  =(lt.c lh.c)  m
    (~(put by m) lh.c [[lt.c ml.c] (~(gut by m) lh.c ~)])
  =/  outs=(map @ud (list [to=@ud ml=@ud]))
    %+  roll  ces
    |=  [c=cedge m=(map @ud (list [to=@ud ml=@ud]))]
    ?:  =(lt.c lh.c)  m
    (~(put by m) lt.c [[lh.c ml.c] (~(gut by m) lt.c ~)])
  =/  lr  (longest-path leaders ins)
  ::  tighten: a source with only-slack out-edges drops to its
  ::  nearest successor
  =.  lr
    %+  roll  leaders
    |=  [v=@ud acc=_lr]
    ?.  =(~ (~(gut by ins) v ~))  acc
    =/  ms  (min-slack-rank acc (~(gut by outs) v ~))
    ?~  ms  acc
    (~(put by acc) v u.ms)
  ::  normalize to rank 0
  =.  lr
    =/  least  (min-val lr)
    ?:  =(0 least)  lr
    (~(run by lr) |=(v=@ud (sub v least)))
  (balance lr leaders ins outs)
::
++  balance
  ::  ns.c-style balance: a node with exactly one in- and one
  ::  out-edge moves to the least-crowded rank in its feasible
  ::  window (its total edge length is the same anywhere in it)
  |=  $:  lr=(map @ud @ud)
          leaders=(list @ud)
          ins=(map @ud (list [frm=@ud ml=@ud]))
          outs=(map @ud (list [to=@ud ml=@ud]))
      ==
  ^-  (map @ud @ud)
  =/  cnt=(map @ud @ud)
    %+  roll  leaders
    |=  [v=@ud m=(map @ud @ud)]
    =/  r  (~(got by lr) v)
    (~(put by m) r +((~(gut by m) r 0)))
  =/  vs  leaders
  |-  ^-  (map @ud @ud)
  ?~  vs  lr
  =/  v  i.vs
  =/  is  (~(gut by ins) v ~)
  =/  os  (~(gut by outs) v ~)
  ?.  ?&(?=([* ~] is) ?=([* ~] os))
    $(vs t.vs)
  =/  low  (add (~(got by lr) frm.i.is) ml.i.is)
  =/  hr  (~(got by lr) to.i.os)
  ?:  (lth hr ml.i.os)  $(vs t.vs)
  =/  high  (sub hr ml.i.os)
  ?:  (gte low high)  $(vs t.vs)
  =/  cur  (~(got by lr) v)
  =/  pick
    =/  best  low
    =/  bestc  (~(gut by cnt) low 0)
    =/  r  +(low)
    |-  ^-  @ud
    ?:  (gth r high)  best
    =/  c  (~(gut by cnt) r 0)
    ?:  (lth c bestc)  $(r +(r), best r, bestc c)
    $(r +(r))
  ?:  =(pick cur)  $(vs t.vs)
  %=  $
    vs   t.vs
    lr   (~(put by lr) v pick)
    cnt  %+  ~(put by (~(put by cnt) cur (dec (~(gut by cnt) cur 1))))
           pick
         +((~(gut by cnt) pick 0))
  ==
::
++  longest-path
  ::  rank(v) = max over in-edges of rank(tail) + minlen
  |=  [vs=(list @ud) ins=(map @ud (list [frm=@ud ml=@ud]))]
  ^-  (map @ud @ud)
  |^
  =|  memo=(map @ud @ud)
  |-  ^-  (map @ud @ud)
  ?~  vs  memo
  $(vs t.vs, memo (visit memo i.vs))
  ::
  ++  visit
    |=  [memo=(map @ud @ud) v=@ud]
    ^-  (map @ud @ud)
    ?:  (~(has by memo) v)  memo
    =/  es  (~(gut by ins) v ~)
    =/  best=@ud  0
    |-  ^-  (map @ud @ud)
    ?~  es  (~(put by memo) v best)
    =.  memo  (visit memo frm.i.es)
    %=  $
      es    t.es
      best  (max best (add (~(got by memo) frm.i.es) ml.i.es))
    ==
  --
::
++  min-slack-rank
  ::  lowest rank a source can take against its successors
  |=  [lr=(map @ud @ud) os=(list [to=@ud ml=@ud])]
  ^-  (unit @ud)
  ?~  os  ~
  =/  best  (sub (~(got by lr) to.i.os) (min ml.i.os (~(got by lr) to.i.os)))
  =/  rest  t.os
  |-  ^-  (unit @ud)
  ?~  rest  `best
  =/  r  (~(got by lr) to.i.rest)
  $(rest t.rest, best (min best (sub r (min ml.i.rest r))))
::
++  force
  ::  dot-style: min/source members to rank 0, max/sink to the top
  |=  [lr=(map @ud @ud) minset=(set @ud) maxset=(set @ud)]
  ^-  (map @ud @ud)
  ?:  &(=(~ minset) =(~ maxset))  lr
  =/  maxr  (max-val lr)
  =.  lr
    %+  roll  ~(tap in minset)
    |=  [v=@ud acc=_lr]
    ?.((~(has by acc) v) acc (~(put by acc) v 0))
  %+  roll  ~(tap in maxset)
  |=  [v=@ud acc=_lr]
  ?.((~(has by acc) v) acc (~(put by acc) v maxr))
::
++  min-val
  |=  m=(map @ud @ud)
  ^-  @ud
  =/  l  ~(tap by m)
  ?~  l  0
  =/  best  +.i.l
  =/  rest=(list [@ud @ud])  t.l
  |-  ^-  @ud
  ?~  rest  best
  $(rest t.rest, best (min best +.i.rest))
::
++  max-val
  |=  m=(map @ud @ud)
  ^-  @ud
  =/  l  ~(tap by m)
  ?~  l  0
  =/  best  +.i.l
  =/  rest=(list [@ud @ud])  t.l
  |-  ^-  @ud
  ?~  rest  best
  $(rest t.rest, best (max best +.i.rest))
::  +|  Virtual chains
::
::
++  chains
  ::  insert virtual nodes for multi-rank edges; tag flat edges
  |=  [n=@ud nranks=(map @ud @ud) ces=(list cedge)]
  ^-  [nall=@ud ranks=(map @ud @ud) edges=(list rank-edge)]
  =/  next  n
  =/  ranks  nranks
  =|  out=(list rank-edge)
  |-  ^-  [nall=@ud ranks=(map @ud @ud) edges=(list rank-edge)]
  ?~  ces  [next ranks (flop out)]
  =/  c  i.ces
  =/  rt  (~(got by ranks) tail.c)
  =/  rh  (~(got by ranks) head.c)
  ?:  (gte rt rh)
    $(ces t.ces, out [[eix.c rev.c %.y [tail.c head.c ~]] out])
  ?:  =(+(rt) rh)
    $(ces t.ces, out [[eix.c rev.c %.n [tail.c head.c ~]] out])
  =/  span  (sub rh rt)
  =/  vids  (gulf next (sub (add next span) 2))
  =/  ranks2
    =/  r  +(rt)
    =/  vs  vids
    |-  ^-  (map @ud @ud)
    ?~  vs  ranks
    $(vs t.vs, r +(r), ranks (~(put by ranks) i.vs r))
  %=  $
    ces    t.ces
    next   (add next (dec span))
    ranks  ranks2
    out    [[eix.c rev.c %.n [tail.c (weld vids [head.c ~])]] out]
  ==
--
