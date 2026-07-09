::  Tests for /lib/attr (P5: attribute resolution)
::
::  Scoping cases follow the semantics in lang.html: defaults apply
::  to subsequent statements in scope, subgraphs inherit at entry,
::  nodes/edges bind defaults at first mention.
::
/-  ast=ast
/+  *test, parse, attr
|%
::  +|  Helpers
::
::
++  rz
  |=  [txt=@t dfl=(list gattr:attr)]
  ^-  resolved:attr
  =/  r  (parse:parse txt)
  ?>  ?=(%& -.r)
  (resolve:attr p.r dfl)
::
++  gna
  ::  attrs of the named node
  |=  [rs=resolved:attr n=@t]
  ^-  attrs:attr
  =/  ns  nodes.rs
  |-  ^-  attrs:attr
  ?~  ns  !!
  ?:(=(n name.i.ns) attrs.i.ns $(ns t.ns))
::
++  ends
  ::  [tail head] pairs of all edges
  |=  rs=resolved:attr
  ^-  (list [@ud @ud])
  (turn edges.rs |=(e=redge:attr [tail.e head.e]))
::  +|  Scoping
::
::
++  test-defaults-subsequent
  ::  attr statements bind only later statements
  =/  rs  (rz 'digraph { a; node [shape=box]; b; }' ~)
  ;:  weld
    (expect-eq !>(~) !>((~(get by (gna rs 'a')) 'shape')))
    (expect-eq !>(`'box') !>((~(get by (gna rs 'b')) 'shape')))
  ==
::
++  test-subgraph-scope-isolation
  ::  subgraphs inherit at entry; changes do not leak out
  =/  rs
    %+  rz
      'digraph { node [color=red]; { node [color=blue]; a; } b; }'
    ~
  ;:  weld
    (expect-eq !>(`'blue') !>((~(get by (gna rs 'a')) 'color')))
    (expect-eq !>(`'red') !>((~(get by (gna rs 'b')) 'color')))
  ==
::
++  test-first-use-defaults
  ::  a node binds the defaults in force at first mention
  =/  rs  (rz 'digraph { a; node [color=green]; a -> b; }' ~)
  ;:  weld
    (expect-eq !>(~) !>((~(get by (gna rs 'a')) 'color')))
    (expect-eq !>(`'green') !>((~(get by (gna rs 'b')) 'color')))
  ==
::
++  test-latest-wins
  =/  rs
    (rz 'digraph { node [color=red]; a [color=blue, color=green]; }' ~)
  (expect-eq !>(`'green') !>((~(get by (gna rs 'a')) 'color')))
::
++  test-cli-defaults
  ::  -N seeds outermost node defaults; file attrs override
  =/  rs
    %+  rz  'digraph { a; b [shape=circle]; }'
    ~[[%node 'shape' 'box']]
  ;:  weld
    (expect-eq !>(`'box') !>((~(get by (gna rs 'a')) 'shape')))
    (expect-eq !>(`'circle') !>((~(get by (gna rs 'b')) 'shape')))
  ==
::
++  test-cli-graph-default
  ;:  weld
  ::  file set overrides -G
    %+  expect-eq  !>(`'TB')
    =/  rs  (rz 'digraph { rankdir=TB }' ~[[%graph 'rankdir' 'LR']])
    !>((~(get by gattrs.rs) 'rankdir'))
  ::  -G alone survives to the root graph attrs
    %+  expect-eq  !>(`'LR')
    =/  rs  (rz 'digraph { a }' ~[[%graph 'rankdir' 'LR']])
    !>((~(get by gattrs.rs) 'rankdir'))
  ==
::  +|  Structure
::
::
++  test-rank-groups
  =/  rs  (rz 'digraph { {rank=same; a b} {rank=min; c} }' ~)
  ;:  weld
    (expect-eq !>(2) !>((lent ranks.rs)))
    (expect-eq !>([%same ~[0 1]]) !>((snag 0 ranks.rs)))
    (expect-eq !>([%min ~[2]]) !>((snag 1 ranks.rs)))
  ==
::
++  test-subgraph-endpoint-expansion
  =/  rs  (rz 'digraph { {a b} -> {c d}; }' ~)
  ;:  weld
    (expect-eq !>(4) !>((lent nodes.rs)))
    (expect-eq !>(~[[0 2] [0 3] [1 2] [1 3]]) !>((ends rs)))
  ==
::
++  test-strict-merge
  ;:  weld
  ::  strict digraph merges duplicate edges latest-wins
    =/  rs
      (rz 'strict digraph { a -> b [color=red]; a -> b [color=blue]; }' ~)
    ;:  weld
      (expect-eq !>(1) !>((lent edges.rs)))
      %+  expect-eq  !>(`'blue')
      !>((~(get by attrs:(snag 0 edges.rs)) 'color'))
    ==
  ::  non-strict keeps both
    =/  rs  (rz 'digraph { a -> b; a -> b; }' ~)
    (expect-eq !>(2) !>((lent edges.rs)))
  ::  strict undirected: b--a duplicates a--b
    =/  rs  (rz 'strict graph { a -- b; b -- a [color=red]; }' ~)
    ;:  weld
      (expect-eq !>(1) !>((lent edges.rs)))
      %+  expect-eq  !>(`'red')
      !>((~(get by attrs:(snag 0 edges.rs)) 'color'))
    ==
  ==
::
++  test-clusters
  =/  rs
    %+  rz
      %-  crip
      ;:  weld
        "digraph \{ subgraph cluster_0 \{ label=p1; a; "
        "subgraph cluster_in \{ b; } } c; }"
      ==
    ~
  =/  c0  (snag 0 clusters.rs)
  =/  c1  (snag 1 clusters.rs)
  ;:  weld
    (expect-eq !>(2) !>((lent clusters.rs)))
    (expect-eq !>('cluster_0') !>(name.c0))
    (expect-eq !>(~) !>(parent.c0))
    (expect-eq !>(`'p1') !>((~(get by attrs.c0) 'label')))
    (expect-eq !>((silt ~[0 1])) !>(nodes.c0))
    (expect-eq !>('cluster_in') !>(name.c1))
    (expect-eq !>(`0) !>(parent.c1))
    (expect-eq !>((silt ~[1])) !>(nodes.c1))
  ==
::
++  test-edge-defaults-and-ports
  =/  rs
    (rz 'digraph { edge [color=red]; a:p:ne -> b:sw [penwidth=2]; }' ~)
  =/  e  (snag 0 edges.rs)
  ;:  weld
    (expect-eq !>(`'red') !>((~(get by attrs.e) 'color')))
    (expect-eq !>(`'2') !>((~(get by attrs.e) 'penwidth')))
    (expect-eq !>([`'p' `%ne]) !>(tport.e))
    (expect-eq !>([~ `%sw]) !>(hport.e))
  ==
::
++  test-unknown-warnings
  =/  rs  (rz 'digraph { a [foo=1]; }' ~)
  ;:  weld
    (expect-eq !>(~['unknown attribute: foo']) !>(warnings.rs))
    (expect-eq !>(`'1') !>((~(get by (gna rs 'a')) 'foo')))
  ==
::  +|  Typed decoding
::
::
++  test-typed-decoders
  =/  m=attrs:attr
    %-  malt
    ^-  (list [@t @t])
    :~  ['width' '0.75']
        ['fixedsize' 'TRUE']
        ['rankdir' 'LR']
        ['style' 'filled, rounded']
        ['rank' 'same']
        ['shape' 'Box']
    ==
  ;:  weld
    (expect-eq !>(.~0.75) !>(~(width gv:attr m)))
    (expect-eq !>(.~14) !>(~(fontsize gv:attr m)))
    (expect-eq !>('\\N') !>(~(label gv:attr m)))
    (expect-eq !>(%.y) !>(~(fixedsize gv:attr m)))
    (expect-eq !>(%lr) !>(~(rankdir gv:attr m)))
    (expect-eq !>(~['filled' 'rounded']) !>(~(style gv:attr m)))
    (expect-eq !>(`%same) !>(~(rank gv:attr m)))
    (expect-eq !>('box') !>(~(shape gv:attr m)))
    (expect-eq !>(`.~-1.5) !>((to-rd:attr '-1.5')))
    (expect-eq !>(`.~2) !>((to-rd:attr '2.')))
    (expect-eq !>(`.~0.5) !>((to-rd:attr '.5')))
    (expect-eq !>(~) !>((to-rd:attr 'x')))
  ==
--
