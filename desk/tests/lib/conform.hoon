::  P4 conformance corpus: every file parses, statement counts are
::  spot-checked, and parse->print->parse is a fixpoint (compared on
::  canonical text, which normalizes positions and layout).
::
/-  ast=ast
/+  *test, parse, print
/*  hello-src      %dot  /tests/dot/hello/dot
/*  unix-src       %dot  /tests/dot/unix/dot
/*  cluster-src    %dot  /tests/dot/cluster/dot
/*  fsm-src        %dot  /tests/dot/fsm/dot
/*  world-src      %dot  /tests/dot/world/dot
/*  shells-src     %dot  /tests/dot/shells/dot
/*  kw-src         %dot  /tests/dot/kw-quoted/dot
/*  uni-src        %dot  /tests/dot/unicode/dot
/*  deep-src       %dot  /tests/dot/deep-nest/dot
/*  empty-src      %dot  /tests/dot/empty/dot
/*  bit8-src       %dot  /tests/dot/eightbit/dot
/*  ports-src      %dot  /tests/dot/ports/dot
/*  sub-edges-src  %dot  /tests/dot/sub-edges/dot
|%
::  $entry: corpus file with expected statement counts
::
::  n: node statements, e: edge hops (arrows), s: subgraphs,
::  all counted through every nesting level
::
+$  entry  [name=@t src=@t n=@ud e=@ud s=@ud]
::
++  corpus
  ^-  (list entry)
  :~  ['hello' hello-src 0 1 0]
      ['unix' unix-src 0 49 0]
      ['cluster' cluster-src 0 9 2]
      ['fsm' fsm-src 4 14 0]
      ['world' world-src 68 54 14]
      ['shells' shells-src 27 38 9]
      ['kw-quoted' kw-src 1 3 0]
      ['unicode' uni-src 2 1 0]
      ['deep-nest' deep-src 2 0 11]
      ['empty' empty-src 0 0 0]
      ['eightbit' bit8-src 0 2 0]
      ['ports' ports-src 0 3 0]
      ['sub-edges' sub-edges-src 6 4 4]
  ==
::  +|  Helpers
::
::
++  get-graph
  |=  src=@t
  ^-  (unit graph:ast)
  =/  r  (parse:parse src)
  ?:(?=(%& -.r) `p.r ~)
::
++  counts
  |=  g=graph:ast
  ^-  [n=@ud e=@ud s=@ud]
  (count-stmts stmts.g)
::
++  count-stmts
  |=  sts=(list stmt:ast)
  ^-  [n=@ud e=@ud s=@ud]
  ?~  sts  [0 0 0]
  =/  hed  (count-body body.i.sts)
  =/  tal  $(sts t.sts)
  [(add n.hed n.tal) (add e.hed e.tal) (add s.hed s.tal)]
::
++  count-body
  |=  b=stmt-body:ast
  ^-  [n=@ud e=@ud s=@ud]
  ?-  -.b
      %node
    [1 0 0]
      %attr
    [0 0 0]
      %set
    [0 0 0]
      %sub
    =/  in  (count-stmts stmts.subgraph.b)
    [n.in e.in +(s.in)]
      %edge
    =/  eps=(list endpoint:ast)  [from.b to.b]
    =/  acc=[n=@ud e=@ud s=@ud]  [0 (lent to.b) 0]
    |-  ^-  [n=@ud e=@ud s=@ud]
    ?~  eps  acc
    ?.  ?=([%sub *] i.eps)  $(eps t.eps)
    =/  in  (count-stmts stmts.subgraph.i.eps)
    %=  $
      eps  t.eps
      acc  [(add n.acc n.in) (add e.acc e.in) (add s.acc +(s.in))]
    ==
  ==
::  +|  Tests
::
::
++  test-corpus-parses
  %+  roll  corpus
  |=  [en=entry acc=tang]
  %+  weld  acc
  %+  category  (trip name.en)
  =/  g  (get-graph src.en)
  ?~  g  ['corpus file failed to parse' ~]
  =/  c  (counts u.g)
  ;:  weld
    (expect-eq !>(n.en) !>(n.c))
    (expect-eq !>(e.en) !>(e.c))
    (expect-eq !>(s.en) !>(s.c))
  ==
::
++  test-corpus-fixpoint
  %+  roll  corpus
  |=  [en=entry acc=tang]
  %+  weld  acc
  %+  category  (trip name.en)
  =/  g1  (get-graph src.en)
  ?~  g1  ['parse 1 failed' ~]
  =/  t1  (print:print u.g1)
  =/  g2  (get-graph t1)
  ?~  g2  ['reparse of printed text failed' ~]
  =/  t2  (print:print u.g2)
  (expect-eq !>(t1) !>(t2))
--
