::  Tests for /sur/ast and /lib/print (P1)
::
::  Hand-built AST values prove the types check; printer goldens pin
::  the canonical DOT text used later as a parser test oracle.
::
/-  ast=ast
/+  *test, print
|%
::  +|  Builders
::
::
++  p0
  ^-  pos:ast
  [1 1]
::
++  node-ep
  |=  =id:ast
  ^-  endpoint:ast
  [%node [id ~ ~]]
::
++  node-stmt
  |=  [=id:ast attrs=alist:ast]
  ^-  stmt:ast
  [p0 [%node [id ~ ~] attrs]]
::
++  edge2
  |=  [a=id:ast b=id:ast attrs=alist:ast]
  ^-  stmt:ast
  [p0 [%edge (node-ep a) [(node-ep b) ~] attrs]]
::
++  hello-world
  ^-  graph:ast
  [strict=%.n directed=%.y id=~ stmts=~[(edge2 'hello' 'world' ~)]]
::  +|  Type checks
::
::
++  test-ast-typecheck
  ::  every statement variant builds and casts to graph:ast
  =/  g
    ^-  graph:ast
    :*  strict=%.y
        directed=%.n
        id=`'g'
        :~  [p0 [%set 'rankdir' 'LR']]
            [p0 [%attr %node ~[['shape' 'box']]]]
            (node-stmt 'a' ~[['label' 'A']])
            (edge2 'a' 'b' ~)
            [p0 [%sub `'s' ~[(node-stmt 'c' ~)]]]
        ==
    ==
  (expect-eq !>(5) !>((lent stmts.g)))
::
++  test-pos-preserved
  =/  s=stmt:ast  [[3 7] [%set 'a' 'b']]
  (expect-eq !>([3 7]) !>(pos.s))
::  +|  Printer goldens
::
::
++  test-print-empty
  %+  expect-eq
    !>  (crip "graph \{\0a}\0a")
  !>  (print:print [%.n %.n ~ ~])
::
++  test-print-hello-world
  %+  expect-eq
    !>  (crip "digraph \{\0a  hello -> world;\0a}\0a")
  !>  (print:print hello-world)
::
++  test-print-strict-undirected
  =/  g
    ^-  graph:ast
    :*  strict=%.y
        directed=%.n
        id=`'g'
        ~[(edge2 'a' 'b' ~[['color' 'red'] ['penwidth' '2']])]
    ==
  =/  expected
    ;:  weld
      "strict graph g \{\0a"
      "  a -- b [color=red, penwidth=2];\0a"
      "}\0a"
    ==
  (expect-eq !>((crip expected)) !>((print:print g)))
::
++  test-print-ports
  =/  g
    ^-  graph:ast
    :*  strict=%.n
        directed=%.y
        id=~
        :~  :-  p0
            :*  %edge
                [%node ['a' `'p' `%ne]]
                ~[[%node ['b' ~ `%s]]]
                ~
            ==
        ==
    ==
  =/  expected
    ;:  weld
      "digraph \{\0a"
      "  a:p:ne -> b:s;\0a"
      "}\0a"
    ==
  (expect-eq !>((crip expected)) !>((print:print g)))
::
++  test-print-nested-subgraph
  =/  g
    ^-  graph:ast
    :*  strict=%.n
        directed=%.n
        id=~
        :~  :-  p0
            :-  %sub
            :-  ~
            ~[[p0 [%sub `'inner' ~[(node-stmt 'x' ~)]]]]
        ==
    ==
  =/  expected
    ;:  weld
      "graph \{\0a"
      "  \{\0a"
      "    subgraph inner \{\0a"
      "      x;\0a"
      "    }\0a"
      "  }\0a"
      "}\0a"
    ==
  (expect-eq !>((crip expected)) !>((print:print g)))
::
++  test-print-all-forms
  ::  one graph exercising every statement form and both subgraph
  ::  renderings (block statement, inline edge endpoint)
  =/  g
    ^-  graph:ast
    :*  strict=%.n
        directed=%.y
        id=`'g'
        :~  [p0 [%set 'rankdir' 'LR']]
            [p0 [%attr %node ~[['shape' 'box']]]]
            [p0 [%attr %edge ~]]
            :-  p0
            :-  %sub
            :-  `'cluster_0'
            ~[(node-stmt 'a' ~) (node-stmt 'b' ~[['label' 'Node B']])]
            :-  p0
            :*  %edge
                [%node ['a' `'out' `%se]]
                ~[[%node ['b' ~ `%any]] (node-ep 'a b')]
                ~[['weight' '2']]
            ==
            :-  p0
            :*  %edge
                [%sub ~ ~[(node-stmt 'c' ~) (node-stmt 'd' ~)]]
                ~[(node-ep 'e')]
                ~
            ==
        ==
    ==
  =/  expected
    ;:  weld
      "digraph g \{\0a"
      "  rankdir=LR;\0a"
      "  node [shape=box];\0a"
      "  edge [];\0a"
      "  subgraph cluster_0 \{\0a"
      "    a;\0a"
      "    b [label=\"Node B\"];\0a"
      "  }\0a"
      "  a:out:se -> b:_ -> \"a b\" [weight=2];\0a"
      "  \{ c; d; } -> e;\0a"
      "}\0a"
    ==
  (expect-eq !>((crip expected)) !>((print:print g)))
::  +|  Id quoting
::
::
++  test-id-quoting
  ;:  weld
    (expect-eq !>("hello") !>((en-id:print 'hello')))
    (expect-eq !>("_x1") !>((en-id:print '_x1')))
    (expect-eq !>("-3.14") !>((en-id:print '-3.14')))
    (expect-eq !>(".5") !>((en-id:print '.5')))
    (expect-eq !>("2.") !>((en-id:print '2.')))
    (expect-eq !>("\"a b\"") !>((en-id:print 'a b')))
    (expect-eq !>("\"graph\"") !>((en-id:print 'graph')))
    (expect-eq !>("\"Strict\"") !>((en-id:print 'Strict')))
    (expect-eq !>("\"1x\"") !>((en-id:print '1x')))
    (expect-eq !>("\"say \\\"hi\\\"\"") !>((en-id:print 'say "hi"')))
  ==
--
