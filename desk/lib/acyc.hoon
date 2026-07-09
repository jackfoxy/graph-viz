::  acyc: cycle breaking (P7)
::
::  DFS-based back-edge reversal per GKNV93 / lib/dotgen/acyclic.c:
::  roots are tried in node order, out-edges in document order, and
::  any edge into a node on the active DFS stack is reversed.  The
::  rev flag is kept so arrows render in the original direction.
::  Greedy-FAS quality is post-v1.
::
::  Self-loops are not traversed and come back unreversed; ranking
::  turns them into flat edges and routing (P10) draws them.
::
/+  attr=attr
|%
::
+$  aedge  [eix=@ud tail=@ud head=@ud rev=?]
::
+$  dstate  [seen=(set @ud) stk=(set @ud) rev=(set @ud)]
::
++  from-resolved
  |=  rs=resolved:attr
  ^-  (list aedge)
  %+  break-cycles  (lent nodes.rs)
  (turn edges.rs |=(e=redge:attr [tail.e head.e]))
::
++  break-cycles
  ::  edges keep their list position as eix
  |=  [n=@ud es=(list [tail=@ud head=@ud])]
  ^-  (list aedge)
  =/  rev  (dfs-rev n (out-adj es))
  =/  ix  0
  |-  ^-  (list aedge)
  ?~  es  ~
  :_  $(es t.es, ix +(ix))
  ?:  (~(has in rev) ix)
    [ix head.i.es tail.i.es %.y]
  [ix tail.i.es head.i.es %.n]
::
++  out-adj
  ::  out-edges per node, in document order; self-loops skipped
  |=  es=(list [tail=@ud head=@ud])
  ^-  (map @ud (list [eix=@ud to=@ud]))
  =/  ix  0
  =|  m=(map @ud (list [eix=@ud to=@ud]))
  |-  ^-  (map @ud (list [eix=@ud to=@ud]))
  ?~  es
    (~(run by m) flop)
  ?:  =(tail.i.es head.i.es)
    $(es t.es, ix +(ix))
  %=  $
    es  t.es
    ix  +(ix)
    m   %+  ~(put by m)  tail.i.es
        [[ix head.i.es] (~(gut by m) tail.i.es ~)]
  ==
::
++  dfs-rev
  ::  edge indexes to reverse
  |=  [n=@ud adj=(map @ud (list [eix=@ud to=@ud]))]
  ^-  (set @ud)
  |^
  =|  st=dstate
  =/  v  0
  |-  ^-  (set @ud)
  ?:  =(v n)  rev.st
  ?:  (~(has in seen.st) v)  $(v +(v))
  $(v +(v), st (go st v))
  ::
  ++  go
    |=  [st=dstate v=@ud]
    ^-  dstate
    =.  seen.st  (~(put in seen.st) v)
    =.  stk.st  (~(put in stk.st) v)
    =/  outs  (~(gut by adj) v ~)
    |-  ^-  dstate
    ?~  outs  st(stk (~(del in stk.st) v))
    ?:  (~(has in stk.st) to.i.outs)
      $(outs t.outs, rev.st (~(put in rev.st) eix.i.outs))
    ?:  (~(has in seen.st) to.i.outs)
      $(outs t.outs)
    $(outs t.outs, st (go st to.i.outs))
  --
--
