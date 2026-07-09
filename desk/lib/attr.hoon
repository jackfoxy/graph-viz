::  attr: attribute resolution (P5)
::
::  AST -> flat resolved graph per DOT scoping semantics: attr
::  statements set defaults for *subsequent* statements in their
::  scope; subgraphs inherit defaults at entry and changes do not
::  leak back out; nodes and edges take the defaults in force at
::  first mention, with explicit attrs layered latest-wins.  CLI
::  -G/-N/-E defaults seed the root scope, so file attrs override.
::
::  Output is flat: nodes in creation order (list index is the node
::  index used by all later layout stages), edges in document order
::  with subgraph endpoints expanded to cross products (strict
::  graphs merge duplicate edges), clusters and same-rank groups
::  extracted, unknown attributes preserved but warned about.
::
/-  ast=ast
/+  parse=parse
|%
::  +|  Public types
::
::
+$  attrs  (map @t @t)
::  $gattr: one CLI default (-G/-N/-E; -A expands to all three)
::
+$  gattr  [targ=?(%graph %node %edge) name=@t value=@t]
::
+$  rport  [port=(unit @t) compass=(unit compass:ast)]
::
+$  rnode  [name=@t =attrs]
::
+$  redge  [tail=@ud head=@ud tport=rport hport=rport =attrs]
::
+$  rank-type  ?(%same %min %max %source %sink)
::
+$  rgroup  [typ=rank-type nodes=(list @ud)]
::
+$  rcluster  [name=@t parent=(unit @ud) =attrs nodes=(set @ud)]
::
+$  resolved
  $:  strict=?
      directed=?
      id=(unit @t)
      gattrs=attrs
      nodes=(list rnode)
      edges=(list redge)
      clusters=(list rcluster)
      ranks=(list rgroup)
      warnings=(list @t)
  ==
::  +|  Internal types
::
::  $scope: defaults in force; copied (not shared) into subgraphs
::
+$  scope  [gdef=attrs ndef=attrs edef=attrs]
::  $frame: per-subgraph bookkeeping.  tl is reversed touch order.
::
+$  frame  [tl=(list @ud) ts=(set @ud) direct=attrs]
::
+$  epn  [idx=@ud pt=rport]
::
+$  state
  $:  strict=?
      directed=?
      nodes=(map @ud rnode)
      by-name=(map @t @ud)
      ncount=@ud
      edges=(map @ud redge)
      ecount=@ud
      ekey=(map [@ud @ud] @ud)
      clusters=(map @ud rcluster)
      ccount=@ud
      ranks=(list rgroup)
      unknowns=(set @t)
      wlist=(list @t)
  ==
::  +|  Resolution
::
::
++  resolve
  |=  [g=graph:ast defaults=(list gattr)]
  ^-  resolved
  =/  sc=scope  (seed defaults)
  =/  st=state  %*(. *state strict strict.g, directed directed.g)
  =.  unknowns.st
    %+  roll  defaults
    |=  [d=gattr acc=(set @t)]
    ?:((~(has in known) name.d) acc (~(put in acc) name.d))
  =/  res  (walk st sc *frame ~ stmts.g)
  =/  ws
    %+  turn  (sort ~(tap in unknowns.st.res) aor)
    |=(n=@t (cat 3 'unknown attribute: ' n))
  :*  strict.st.res
      directed.st.res
      id.g
      gdef.sc.res
      (node-list nodes.st.res ncount.st.res)
      (edge-list edges.st.res ecount.st.res)
      (cluster-list clusters.st.res ccount.st.res)
      (flop ranks.st.res)
      (weld (flop wlist.st.res) ws)
  ==
::
++  walk
  ::  execute statements; cpar is the innermost enclosing cluster
  |=  [st=state sc=scope fr=frame cpar=(unit @ud) sts=(list stmt:ast)]
  ^-  [fr=frame sc=scope st=state]
  ?~  sts  [fr sc st]
  =/  b  body.i.sts
  ?-    -.b
      %set
    =^  gd  st  (lay st gdef.sc [[name.b value.b] ~])
    %=  $
      sts  t.sts
      gdef.sc  gd
      direct.fr  (~(put by direct.fr) name.b value.b)
    ==
  ::
      %attr
    ?-    targ.b
        %graph
      =^  gd  st  (lay st gdef.sc attrs.b)
      %=  $
        sts  t.sts
        gdef.sc  gd
        direct.fr  (put-all direct.fr attrs.b)
      ==
        %node
      =^  nd  st  (lay st ndef.sc attrs.b)
      $(sts t.sts, ndef.sc nd)
        %edge
      =^  ed  st  (lay st edef.sc attrs.b)
      $(sts t.sts, edef.sc ed)
    ==
  ::
      %node
    =^  tr  st  (touch st sc fr id.ref.b)
    =/  old  (~(got by nodes.st) idx.tr)
    =^  atr  st  (lay st attrs.old attrs.b)
    =.  nodes.st  (~(put by nodes.st) idx.tr old(attrs atr))
    $(sts t.sts, fr fr.tr)
  ::
      %edge
    =/  eps=(list endpoint:ast)  [from.b to.b]
    =^  ev  st  (eval-eps st sc fr cpar eps)
    =^  ea  st  (lay st edef.sc attrs.b)
    =.  st  (link st groups.ev ea)
    $(sts t.sts, fr fr.ev)
  ::
      %sub
    =^  wr  st  (walk-sub st sc fr cpar subgraph.b)
    $(sts t.sts, fr fr.wr)
  ==
::
++  walk-sub
  ::  walk a subgraph in a child scope; returns its nodes in touch
  ::  order and the parent frame grown with them
  |=  [st=state sc=scope fr=frame cpar=(unit @ud) sub=subgraph:ast]
  ^-  [[touched=(list @ud) fr=frame] st=state]
  =/  cluster=?  (is-cluster:parse id.sub)
  =/  cidx=(unit @ud)  ?:(cluster `ccount.st ~)
  =?  ccount.st  cluster  +(ccount.st)
  =/  res
    %:  walk
      st
      sc
      *frame
      ?:(cluster cidx cpar)
      stmts.sub
    ==
  =/  ctl  (flop tl.fr.res)
  =.  st  st.res
  ::  a rank attr set directly in this subgraph forms a rank group
  =/  rk  (~(get by direct.fr.res) 'rank')
  =?  st  ?=(^ rk)
    =/  rt  (to-rank u.rk)
    ?~  rt
      st(wlist [(cat 3 'invalid rank value: ' u.rk) wlist.st])
    st(ranks [[u.rt ctl] ranks.st])
  =?  st  cluster
    %=  st
      clusters  %+  ~(put by clusters.st)  (need cidx)
                [(need id.sub) cpar gdef.sc.res (silt ctl)]
    ==
  [[ctl (absorb fr ctl)] st]
::
++  eval-eps
  ::  evaluate edge endpoints left to right into node groups
  |=  [st=state sc=scope fr=frame cpar=(unit @ud) eps=(list endpoint:ast)]
  ^-  [[groups=(list (list epn)) fr=frame] st=state]
  =|  acc=(list (list epn))
  |-  ^-  [[groups=(list (list epn)) fr=frame] st=state]
  ?~  eps  [[(flop acc) fr] st]
  ?-    -.i.eps
      %node
    =^  tr  st  (touch st sc fr id.ref.i.eps)
    %=  $
      eps  t.eps
      fr   fr.tr
      acc  [[[idx.tr [port.ref.i.eps compass.ref.i.eps]] ~] acc]
    ==
  ::
      %sub
    =^  wr  st  (walk-sub st sc fr cpar subgraph.i.eps)
    %=  $
      eps  t.eps
      fr   fr.wr
      acc  [(turn touched.wr |=(i=@ud `epn`[i [~ ~]])) acc]
    ==
  ==
::
++  link
  ::  edges between each consecutive pair of endpoint groups
  |=  [st=state groups=(list (list epn)) ea=attrs]
  ^-  state
  ?~  groups  st
  ?~  t.groups  st
  =.  st  (link-pair st i.groups i.t.groups ea)
  $(groups t.groups)
::
++  link-pair
  |=  [st=state ls=(list epn) rs=(list epn) ea=attrs]
  ^-  state
  ?~  ls  st
  $(ls t.ls, st (link-one st i.ls rs ea))
::
++  link-one
  |=  [st=state l=epn rs=(list epn) ea=attrs]
  ^-  state
  ?~  rs  st
  $(rs t.rs, st (add-edge st l i.rs ea))
::
++  add-edge
  ::  add one edge; strict graphs merge duplicates latest-wins
  |=  [st=state l=epn r=epn ea=attrs]
  ^-  state
  =/  key=[@ud @ud]
    ?:  |(directed.st (lte idx.l idx.r))
      [idx.l idx.r]
    [idx.r idx.l]
  =/  hit  ?:(strict.st (~(get by ekey.st) key) ~)
  ?^  hit
    =/  e  (~(got by edges.st) u.hit)
    st(edges (~(put by edges.st) u.hit e(attrs (~(uni by attrs.e) ea))))
  =/  idx  ecount.st
  %=  st
    edges   (~(put by edges.st) idx [idx.l idx.r pt.l pt.r ea])
    ecount  +(idx)
    ekey    (~(put by ekey.st) key idx)
  ==
::
++  touch
  ::  find or create a node; new nodes take current node defaults
  |=  [st=state sc=scope fr=frame name=@t]
  ^-  [[idx=@ud fr=frame] st=state]
  =/  hit  (~(get by by-name.st) name)
  ?^  hit
    [[u.hit (absorb fr [u.hit ~])] st]
  =/  idx  ncount.st
  =.  nodes.st  (~(put by nodes.st) idx [name ndef.sc])
  =.  by-name.st  (~(put by by-name.st) name idx)
  =.  ncount.st  +(idx)
  [[idx (absorb fr [idx ~])] st]
::
++  absorb
  ::  add nodes to a frame's touched set, keeping first-touch order
  |=  [fr=frame new=(list @ud)]
  ^-  frame
  ?~  new  fr
  ?:  (~(has in ts.fr) i.new)  $(new t.new)
  %=  $
    new    t.new
    tl.fr  [i.new tl.fr]
    ts.fr  (~(put in ts.fr) i.new)
  ==
::
++  lay
  ::  layer bindings latest-wins, recording unknown names
  |=  [st=state m=attrs new=alist:ast]
  ^-  [attrs state]
  ?~  new  [m st]
  =?  unknowns.st  !(~(has in known) name.i.new)
    (~(put in unknowns.st) name.i.new)
  $(new t.new, m (~(put by m) name.i.new value.i.new))
::
++  put-all
  |=  [m=attrs new=alist:ast]
  ^-  attrs
  ?~  new  m
  $(new t.new, m (~(put by m) name.i.new value.i.new))
::
++  seed
  ::  CLI defaults as outermost scope
  |=  defaults=(list gattr)
  ^-  scope
  =/  sc=scope  [~ ~ ~]
  |-  ^-  scope
  ?~  defaults  sc
  =/  d  i.defaults
  %=    $
      defaults  t.defaults
      sc
    ?-  targ.d
      %graph  sc(gdef (~(put by gdef.sc) name.d value.d))
      %node   sc(ndef (~(put by ndef.sc) name.d value.d))
      %edge   sc(edef (~(put by edef.sc) name.d value.d))
    ==
  ==
::  +|  Materialization
::
::
++  node-list
  |=  [m=(map @ud rnode) n=@ud]
  ^-  (list rnode)
  ?:  =(0 n)  ~
  (turn (gulf 0 (dec n)) |=(i=@ud (~(got by m) i)))
::
++  edge-list
  |=  [m=(map @ud redge) n=@ud]
  ^-  (list redge)
  ?:  =(0 n)  ~
  (turn (gulf 0 (dec n)) |=(i=@ud (~(got by m) i)))
::
++  cluster-list
  |=  [m=(map @ud rcluster) n=@ud]
  ^-  (list rcluster)
  ?:  =(0 n)  ~
  (turn (gulf 0 (dec n)) |=(i=@ud (~(got by m) i)))
::  +|  Known attributes (v1)
::
::
++  known
  ^-  (set @t)
  %-  silt
  ^-  (list @t)
  :~  'shape'  'label'  'width'  'height'  'fixedsize'  'color'
      'fillcolor'  'fontcolor'  'style'  'fontsize'  'fontname'
      'rankdir'  'rank'  'nodesep'  'ranksep'  'arrowhead'
      'arrowtail'  'dir'  'penwidth'  'bgcolor'  'size'  'ratio'
      'minlen'  'weight'  'arrowsize'
  ==
::  +|  Typed decoding
::
::  +gv: typed accessors over one resolved attribute map, with
::  graphviz defaults.  Word-valued attrs come back lowercased.
::
++  gv
  |_  m=attrs
  ::
  ++  raw  |=(n=@t (~(get by m) n))
  ::
  ++  label      (~(gut by m) 'label' '\\N')
  ++  fontname   (~(gut by m) 'fontname' 'Times-Roman')
  ++  color      (~(gut by m) 'color' 'black')
  ++  fillcolor  (~(gut by m) 'fillcolor' 'lightgrey')
  ++  fontcolor  (~(gut by m) 'fontcolor' 'black')
  ++  bgcolor    (raw 'bgcolor')
  ++  size-a     (raw 'size')
  ++  ratio      (raw 'ratio')
  ::
  ++  shape      ^-(@t (fall (bind (raw 'shape') low-t) 'ellipse'))
  ++  arrowhead  ^-(@t (fall (bind (raw 'arrowhead') low-t) 'normal'))
  ++  arrowtail  ^-(@t (fall (bind (raw 'arrowtail') low-t) 'normal'))
  ++  dir        ^-((unit @t) (bind (raw 'dir') low-t))
  ++  rank       ^-((unit rank-type) (biff (raw 'rank') to-rank))
  ::
  ++  width      (rd-or 'width' .~0.75)
  ++  height     (rd-or 'height' .~0.5)
  ++  fontsize   (rd-or 'fontsize' .~14)
  ++  penwidth   (rd-or 'penwidth' .~1)
  ++  nodesep    (rd-or 'nodesep' .~0.25)
  ++  ranksep    (rd-or 'ranksep' .~0.5)
  ++  minlen     (ud-or 'minlen' 1)
  ++  weight     (ud-or 'weight' 1)
  ++  arrowsize  (rd-or 'arrowsize' .~1)
  ::
  ++  fixedsize  ^-(? (fall (biff (raw 'fixedsize') to-bool) %.n))
  ::
  ++  rankdir
    ^-  ?(%tb %lr %bt %rl)
    =/  v  (raw 'rankdir')
    ?~  v  %tb
    ?+  (low-t u.v)  %tb
      %lr  %lr
      %bt  %bt
      %rl  %rl
    ==
  ::
  ++  style
    ::  comma-separated style words, lowercased, spaces dropped
    ^-  (list @t)
    =/  v  (raw 'style')
    ?~  v  ~
    (turn (split-comma (trip u.v)) |=(tp=tape (crip (cass tp))))
  ::
  ++  rd-or
    |=  [n=@t d=@rd]
    ^-  @rd
    =/  v  (raw n)
    ?~  v  d
    (fall (to-rd u.v) d)
  ::
  ++  ud-or
    |=  [n=@t d=@ud]
    ^-  @ud
    =/  v  (raw n)
    ?~  v  d
    (fall (to-ud u.v) d)
  --
::  +|  Value parsing
::
::
++  low-t  |=(t=@t (crip (cass (trip t))))
::
++  dig  |=(c=@tD &((gte c '0') (lte c '9')))
::
++  to-rank
  |=  t=@t
  ^-  (unit rank-type)
  ?+  t  ~
    %same    `%same
    %min     `%min
    %max     `%max
    %source  `%source
    %sink    `%sink
  ==
::
++  to-bool
  |=  t=@t
  ^-  (unit ?)
  ?+  (low-t t)  ~
    %true   `%.y
    %yes    `%.y
    %'1'    `%.y
    %false  `%.n
    %no     `%.n
    %'0'    `%.n
  ==
::
++  to-ud
  |=  t=@t
  ^-  (unit @ud)
  (rush t dem)
::
++  to-rd
  ::  decimal text to a double
  |=  t=@t
  ^-  (unit @rd)
  =/  tp  (trip t)
  =^  neg  tp
    ?~  tp  [%.n `tape`~]
    ?:  =('-' i.tp)  [%.y t.tp]
    [%.n tp]
  ?~  tp  ~
  =/  bd  (break-dot tp)
  ?.  &((levy ip.bd dig) (levy fp.bd dig))  ~
  ?:  &(?=(~ ip.bd) ?=(~ fp.bd))  ~
  =/  scale  (pow-10 (lent fp.bd))
  =/  v
    %+  div:rd
      (sun:rd (add (mul (tape-ud ip.bd) scale) (tape-ud fp.bd)))
    (sun:rd scale)
  `?:(neg (sub:rd .~0 v) v)
::
++  break-dot
  |=  tp=tape
  ^-  [ip=tape fp=tape]
  =|  ip=tape
  |-  ^-  [ip=tape fp=tape]
  ?~  tp  [(flop ip) ~]
  ?:  =('.' i.tp)  [(flop ip) t.tp]
  $(tp t.tp, ip [i.tp ip])
::
++  tape-ud
  |=  tp=tape
  ^-  @ud
  %+  roll  tp
  |=([c=@tD acc=@ud] (add (mul 10 acc) (sub c '0')))
::
++  pow-10
  |=  n=@ud
  ^-  @ud
  ?:(=(0 n) 1 (mul 10 $(n (dec n))))
::
++  split-comma
  |=  tp=tape
  ^-  (list tape)
  =|  cur=tape
  =|  out=(list tape)
  |-  ^-  (list tape)
  ?~  tp  (flop [(flop cur) out])
  ?:  =(',' i.tp)
    $(tp t.tp, out [(flop cur) out], cur ~)
  ?:  =(' ' i.tp)
    $(tp t.tp)
  $(tp t.tp, cur [i.tp cur])
--
