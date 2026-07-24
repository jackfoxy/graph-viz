::  route: edge routing, splines, arrowheads (P10)
::
::  v1 routes each edge through its virtual-node corridor as a
::  piecewise cubic bezier through the chain waypoints (straight
::  edges are one segment); box-constrained spline fitting
::  (routespl.c) is post-v1 behind the same interface.  Endpoints
::  clip to the node boundary (box or ellipse math); compass ports
::  override the attachment point.  Self-loops bow out to the
::  right; parallel edges between adjacent ranks fan apart; flat
::  edges run straight between facing sides.
::
::  Arrowheads render as polygons scaled by arrowsize, honoring
::  dir=forward/back/both/none and the P7 reversal flag, so arrows
::  always point along the original edge direction.  Splines end on
::  the node boundary; arrow tips sit on the endpoint.
::
::  +build-graph assembles the full public positioned graph.
::
/-  gg=graph
/+  attr=attr, rank=rank, coord=coord
|%
::  +|  Types
::
::
+$  fp  [x=@rs y=@rs]
::
+$  redge-out
  $:  eix=@ud
      tail=@ud
      head=@ud
      spline=(list fp)
      arrows=(list (list fp))
      label=(unit [text=@t at=fp])
  ==
::  +|  Vector helpers
::
::
++  vadd  |=([a=fp b=fp] `fp`[(add:rs x.a x.b) (add:rs y.a y.b)])
++  vsub  |=([a=fp b=fp] `fp`[(sub:rs x.a x.b) (sub:rs y.a y.b)])
++  vmul  |=([a=fp s=@rs] `fp`[(mul:rs x.a s) (mul:rs y.a s)])
++  vperp  |=(a=fp `fp`[(sub:rs .0 y.a) x.a])
++  hf  |=(a=@rs (div:rs a .2))
::
++  vlen
  |=  a=fp
  ^-  @rs
  (sqt:rs (add:rs (mul:rs x.a x.a) (mul:rs y.a y.a)))
::
++  vnorm
  |=  a=fp
  ^-  fp
  =/  l  (vlen a)
  ?:  (lte:rs l .1e-6)  [.1 .0]
  (vmul a (div:rs .1 l))
::
++  vlerp
  |=  [a=fp b=fp t=@rs]
  ^-  fp
  (vadd a (vmul (vsub b a) t))
::  +|  Clipping
::
::
++  is-elly
  |=  shp=@t
  ^-  ?
  ?|  =('ellipse' shp)
      =('circle' shp)
      =('oval' shp)
      =('egg' shp)
      =('doublecircle' shp)
      =('mcircle' shp)
  ==
::
++  node-shape
  |=  [res=resolved:attr v=@ud]
  ^-  @t
  ?:  (gte v (lent nodes.res))  'box'
  ~(shape gv:attr attrs:(snag v nodes.res))
::
++  ellipse-clip
  |=  [ctr=fp ab=fp target=fp]
  ^-  fp
  =/  d  (vsub target ctr)
  ?:  (lte:rs (vlen d) .1e-6)  (vadd ctr [x.ab .0])
  =/  qx  (div:rs x.d x.ab)
  =/  qy  (div:rs y.d y.ab)
  =/  t  (div:rs .1 (sqt:rs (add:rs (mul:rs qx qx) (mul:rs qy qy))))
  (vadd ctr (vmul d t))
::
++  box-clip
  |=  [ctr=fp ab=fp target=fp]
  ^-  fp
  =/  d  (vsub target ctr)
  =/  adx  ?:((lth:rs x.d .0) (sub:rs .0 x.d) x.d)
  =/  ady  ?:((lth:rs y.d .0) (sub:rs .0 y.d) y.d)
  ?:  &((lte:rs adx .1e-6) (lte:rs ady .1e-6))
    (vadd ctr [x.ab .0])
  =/  tx  ?:((lte:rs adx .1e-6) .1e9 (div:rs x.ab adx))
  =/  ty  ?:((lte:rs ady .1e-6) .1e9 (div:rs y.ab ady))
  (vadd ctr (vmul d ?:((lth:rs tx ty) tx ty)))
::
++  compass-pt
  ::  attachment for a compass port; ~ means use normal clipping
  ::  (%c and %any fall through)
  |=  [ctr=fp ab=fp elly=? c=@tas]
  ^-  (unit fp)
  =/  k  ?:(elly .0.7071068 .1)
  =/  ax  (mul:rs x.ab k)
  =/  ay  (mul:rs y.ab k)
  ?+  c  ~
    %n   `(vadd ctr [.0 y.ab])
    %s   `(vsub ctr [.0 y.ab])
    %e   `(vadd ctr [x.ab .0])
    %w   `(vsub ctr [x.ab .0])
    %ne  `(vadd ctr [ax ay])
    %se  `(vadd ctr [ax (sub:rs .0 ay)])
    %nw  `(vadd ctr [(sub:rs .0 ax) ay])
    %sw  `(vsub ctr [ax ay])
  ==
::
++  clip-end
  ::  boundary attachment for a real node, honoring compass ports
  |=  [res=resolved:attr c=coords:coord v=@ud target=fp pt=rport:attr]
  ^-  fp
  =/  ctr  `fp`(~(got by pos.c) v)
  =/  d  (~(got by dims.c) v)
  =/  ab  `fp`[(hf w.d) (hf h.d)]
  =/  elly  (is-elly (node-shape res v))
  ?^  compass.pt
    =/  cp  (compass-pt ctr ab elly u.compass.pt)
    ?^  cp  u.cp
    ?:(elly (ellipse-clip ctr ab target) (box-clip ctr ab target))
  ?:  elly  (ellipse-clip ctr ab target)
  (box-clip ctr ab target)
::  +|  Splines
::
::
++  through
  ::  piecewise cubic through waypoints (3k+1 control points)
  |=  pts=(list fp)
  ^-  (list fp)
  ?~  pts  ~
  =/  head  i.pts
  =/  rest  `(list fp)`t.pts
  =/  prev  head
  =|  acc=(list fp)
  |-  ^-  (list fp)
  ?~  rest  [head (flop acc)]
  =/  b  i.rest
  %=  $
    rest  t.rest
    prev  b
    acc   [b (vlerp prev b .0.6666667) (vlerp prev b .0.3333333) acc]
  ==
::
++  cubic-mid
  ::  Evaluate one cubic Bezier segment at t=0.5
  |=  [p0=fp p1=fp p2=fp p3=fp]
  ^-  fp
  =/  a  (vlerp p0 p1 .0.5)
  =/  b  (vlerp p1 p2 .0.5)
  =/  c  (vlerp p2 p3 .0.5)
  (vlerp (vlerp a b .0.5) (vlerp b c .0.5) .0.5)
::
++  spline-mid
  ::  Point halfway through a 3k+1 control-point spline
  |=  sp=(list fp)
  ^-  fp
  ?~  sp  [.0 .0]
  =/  points  `(list fp)`sp
  =/  count  (lent points)
  =/  segments  (div (dec count) 3)
  =/  middle  (div segments 2)
  =/  start  (mul middle 3)
  ?:  =(0 (mod segments 2))
    (snag start points)
  %:  cubic-mid
    (snag start points)
    (snag +(start) points)
    (snag (add 2 start) points)
    (snag (add 3 start) points)
  ==
::  +|  Arrowheads
::
::
++  arrow-poly
  ::  polygon for one arrowhead; dir points into the tip
  |=  [typ=@t tip=fp dir=fp size=@rs]
  ^-  (list (list fp))
  ?:  =('none' typ)  ~
  =/  len  (mul:rs .10 size)
  =/  wid  (mul:rs .7 size)
  =/  base  (vsub tip (vmul dir len))
  =/  pp  (vperp dir)
  =/  hw  (hf wid)
  ?:  =('vee' typ)
    :_  ~
    :~  (vadd base (vmul pp hw))
        tip
        (vsub base (vmul pp hw))
        (vsub tip (vmul dir (mul:rs len .0.6)))
    ==
  ?:  =('diamond' typ)
    =/  mid  (vsub tip (vmul dir (hf len)))
    :_  ~
    :~  tip
        (vadd mid (vmul pp hw))
        base
        (vsub mid (vmul pp hw))
    ==
  ?:  =('dot' typ)
    =/  r  (mul:rs .2 size)
    =/  cc  (vsub tip (vmul dir r))
    =/  rk  (mul:rs r .0.7071068)
    :_  ~
    :~  (vadd cc [r .0])
        (vadd cc [rk rk])
        (vadd cc [.0 r])
        (vadd cc [(sub:rs .0 rk) rk])
        (vsub cc [r .0])
        (vsub cc [rk rk])
        (vsub cc [.0 r])
        (vadd cc [rk (sub:rs .0 rk)])
    ==
  ::  normal, empty, and anything unrecognized: triangle
  :_  ~
  :~  tip
      (vadd base (vmul pp hw))
      (vsub base (vmul pp hw))
  ==
::
++  edge-arrows
  |=  [res=resolved:attr spline=(list fp) rev=? e=redge:attr]
  ^-  (list (list fp))
  ?:  (lth (lent spline) 2)  ~
  =/  gvd  ~(. gv:attr attrs.e)
  =/  dv  (fall dir:gvd ?:(directed.res 'forward' 'none'))
  =/  asz  (rd-rs:coord arrowsize:gvd)
  =/  n  (lent spline)
  =/  endp  (snag (dec n) spline)
  =/  endd  (vnorm (vsub endp (snag (sub n 2) spline)))
  =/  strtp  (snag 0 spline)
  =/  strtd  (vnorm (vsub strtp (snag 1 spline)))
  =/  fwd  |(=('forward' dv) =('both' dv))
  =/  bck  |(=('back' dv) =('both' dv))
  ;:  weld
    ?.  fwd  ~
    ?:  rev
      (arrow-poly arrowhead:gvd strtp strtd asz)
    (arrow-poly arrowhead:gvd endp endd asz)
  ::
    ?.  bck  ~
    ?:  rev
      (arrow-poly arrowtail:gvd endp endd asz)
    (arrow-poly arrowtail:gvd strtp strtd asz)
  ==
::  +|  Routing
::
::
++  route-graph
  |=  [res=resolved:attr g=ranked:rank c=coords:coord]
  ^-  (list redge-out)
  =/  fan-total=(map [@ud @ud] @ud)
    %+  roll  edges.g
    |=  [re=rank-edge:rank m=(map [@ud @ud] @ud)]
    ?.  =(2 (lent path.re))  m
    =/  k  [(snag 0 path.re) (snag 1 path.re)]
    (~(put by m) k +((~(gut by m) k 0)))
  =/  es  edges.g
  =|  seen=(map [@ud @ud] @ud)
  =|  out=(list redge-out)
  |-  ^-  (list redge-out)
  ?~  es  (flop out)
  =/  re  i.es
  =/  short  =(2 (lent path.re))
  =/  k
    ?.  short  0
    (~(gut by seen) [(snag 0 path.re) (snag 1 path.re)] 0)
  =/  total
    ?.  short  1
    (~(gut by fan-total) [(snag 0 path.re) (snag 1 path.re)] 1)
  %=  $
    es    t.es
    out   [(route-one res g c re k total) out]
    seen  ?.  short  seen
          %+  ~(put by seen)
            [(snag 0 path.re) (snag 1 path.re)]
          +(k)
  ==
::
++  route-one
  |=  $:  res=resolved:attr
          g=ranked:rank
          c=coords:coord
          re=rank-edge:rank
          k=@ud
          total=@ud
      ==
  ^-  redge-out
  =/  e  (snag eix.re edges.res)
  =/  tl  (snag 0 path.re)
  =/  hd  (snag (dec (lent path.re)) path.re)
  =/  pt-t  ?:(rev.re hport.e tport.e)
  =/  pt-h  ?:(rev.re tport.e hport.e)
  =/  spline
    ?:  =(tl hd)
      (self-loop res c tl k pt-t pt-h)
    =/  mids
      %+  turn  (snip (slag 1 path.re))
      |=(v=@ud `fp`(~(got by pos.c) v))
    ?^  mids
      =/  p0  (clip-end res c tl i.mids pt-t)
      =/  pn  (clip-end res c hd (rlast-fp mids) pt-h)
      (through (zing ~[[p0 ~] `(list fp)`mids [pn ~]]))
    =/  tctr  `fp`(~(got by pos.c) tl)
    =/  hctr  `fp`(~(got by pos.c) hd)
    =/  off
      ?:  =(1 total)  .0
      %+  mul:rs  .14
      (sub:rs (sun:rs k) (hf (sun:rs (dec total))))
    =/  od  (vperp (vnorm (vsub hctr tctr)))
    =/  c1  (vadd (vlerp tctr hctr .0.3333333) (vmul od off))
    =/  c2  (vadd (vlerp tctr hctr .0.6666667) (vmul od off))
    =/  p0  (clip-end res c tl c1 pt-t)
    =/  p3  (clip-end res c hd c2 pt-h)
    ::  Center-based controls can fall inside a large endpoint,
    ::  reversing the final tangent and its arrowhead.
    =/  c1  (vadd (vlerp p0 p3 .0.3333333) (vmul od off))
    =/  c2  (vadd (vlerp p0 p3 .0.6666667) (vmul od off))
    ~[p0 c1 c2 p3]
  =/  label=(unit [text=@t at=fp])
    =/  lt  (~(get by attrs.e) 'label')
    ?~  lt  ~
    =/  horiz  |(=(%lr rankdir.g) =(%rl rankdir.g))
    =/  offset  ?:(|(=(tl hd) !horiz) [.10 .0] [.0 .10])
    `[u.lt (vadd (spline-mid spline) offset)]
  [eix.re tl hd spline (edge-arrows res spline rev.re e) label]
::
++  rlast-fp
  |=  l=(list fp)
  ^-  fp
  =/  best=fp  [.0 .0]
  |-  ^-  fp
  ?~  l  best
  $(l t.l, best i.l)
::
++  self-loop
  ::  k-th right-side loop on node v
  |=  $:  res=resolved:attr
          c=coords:coord
          v=@ud
          k=@ud
          pt-t=rport:attr
          pt-h=rport:attr
      ==
  ^-  (list fp)
  =/  ctr  `fp`(~(got by pos.c) v)
  =/  d  (~(got by dims.c) v)
  =/  ext
    ;:  add:rs
      (hf w.d)
      .18
      (mul:rs .14 (sun:rs k))
    ==
  =/  c1  [(add:rs x.ctr ext) (add:rs y.ctr (mul:rs .0.8 (hf h.d)))]
  =/  c2  [(add:rs x.ctr ext) (sub:rs y.ctr (mul:rs .0.8 (hf h.d)))]
  =/  p0  (clip-end res c v c1 pt-t)
  =/  p3  (clip-end res c v c2 pt-h)
  ~[p0 c1 c2 p3]
::  +|  Public graph assembly
::
::
++  build-graph
  |=  [res=resolved:attr g=ranked:rank c=coords:coord]
  ^-  graph:gg
  =/  routed  (route-graph res g c)
  =/  nreal  (lent nodes.res)
  :*  (fall id.res '')
      [size.c scale.c]
      directed.res
    ::
      ?:  =(0 nreal)  ~
      %+  turn  (gulf 0 (dec nreal))
      |=  v=@ud
      ^-  gnode:gg
      =/  n  (snag v nodes.res)
      =/  ctr  (~(got by pos.c) v)
      =/  d  (~(got by dims.c) v)
      :*  name.n
          ctr
          [(hf w.d) (hf h.d)]
          (node-shape res v)
          attrs.n
          (node-label:coord res v)
          ctr
      ==
    ::
      %+  turn  routed
      |=  ro=redge-out
      ^-  gedge:gg
      =/  e  (snag eix.ro edges.res)
      [tail.ro head.ro spline.ro arrows.ro label.ro attrs.e]
    ::
      %+  turn  clusters.res
      |=  cl=rcluster:attr
      ^-  gcluster:gg
      =/  bb  (cluster-bbox c nodes.cl)
      :*  name.cl
          bb
          =/  lt  (~(get by attrs.cl) 'label')
          ?~  lt  ~
          `[u.lt [(hf (add:rs x.ll.bb x.ur.bb)) (sub:rs y.ur.bb .10)]]
          attrs.cl
      ==
  ==
::
++  cluster-bbox
  |=  [c=coords:coord vs=(set @ud)]
  ^-  bbox:gg
  =/  l  ~(tap in vs)
  ?~  l  [[.0 .0] [.0 .0]]
  =/  first
    =/  p  (~(got by pos.c) i.l)
    =/  d  (~(got by dims.c) i.l)
    :-  [(sub:rs x.p (hf w.d)) (sub:rs y.p (hf h.d))]
    [(add:rs x.p (hf w.d)) (add:rs y.p (hf h.d))]
  =/  rest  `(list @ud)`t.l
  =/  bb=[ll=fp ur=fp]  first
  |-  ^-  bbox:gg
  ?~  rest
    [(vsub ll.bb [.8 .8]) (vadd ur.bb [.8 .26])]
  =/  p  (~(got by pos.c) i.rest)
  =/  d  (~(got by dims.c) i.rest)
  =/  lo=fp  [(sub:rs x.p (hf w.d)) (sub:rs y.p (hf h.d))]
  =/  hi=fp  [(add:rs x.p (hf w.d)) (add:rs y.p (hf h.d))]
  %=  $
    rest  t.rest
    bb    :-  [(rmin:coord x.ll.bb x.lo) (rmin:coord y.ll.bb y.lo)]
          [(rmax:coord x.ur.bb x.hi) (rmax:coord y.ur.bb y.hi)]
  ==
--
