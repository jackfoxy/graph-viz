::  ast: DOT abstract syntax tree
::
::  Mirrors the DOT grammar (lang.html).  A graph holds a statement
::  list; statements are node / edge / attr-default / id=id /
::  subgraph.  Edge statements are chains (a -> b -> c) whose
::  endpoints are node references or subgraphs.  The edge operator
::  is not stored: it is implied by directedness of the graph, and
::  the parser (P3) rejects a mismatched operator.
::
::  Ids hold decoded text: quoted-string escapes are resolved and
::  +-concatenation applied by the parser.  Quoting decisions belong
::  to the printer (/lib/print).
::
::  Attribute lists stay ordered: resolution (P5) is latest-wins.
::  Every statement carries its source position for error reporting.
::
|%
::  +|  Lexical
::
::  $pos: source position, 1-indexed line and column
::
+$  pos  [line=@ud col=@ud]
::  $id: decoded DOT identifier text
::
+$  id  @t
::  $compass: compass point on a node; %any is DOT's '_'
::
+$  compass  ?(%n %ne %e %se %s %sw %w %nw %c %any)
::  +|  References and attributes
::
::  $node-ref: node id with optional port and compass point
::
+$  node-ref  [=id port=(unit id) compass=(unit compass)]
::  $attr: one name=value binding
::
+$  attr  [name=id value=id]
::  $alist: ordered attribute bindings; later bindings win
::
+$  alist  (list attr)
::  +|  Statements
::
::  $endpoint: one end of an edge chain
::
::  The $~ bunts on $endpoint and $stmt-body are load-bearing: the
::  stmt/stmt-body/subgraph/endpoint cycle overflows the compiler
::  (bail %over) unless the $% arms in the cycle carry explicit
::  non-recursive bunts.
::
+$  endpoint
  $~  [%node ['' ~ ~]]
  $%  [%node ref=node-ref]
      [%sub =subgraph]
  ==
::  $subgraph: named or anonymous statement group
::
::  Presence of the optional 'subgraph' keyword is not preserved.
::
+$  subgraph  [id=(unit id) stmts=(list stmt)]
::  $stmt: one statement plus its source position
::
+$  stmt  [=pos body=stmt-body]
::  $stmt-body: the five DOT statement forms
::
::  %node  node declaration with attributes
::  %edge  edge chain; to is nonempty, so every edge has >=2 ends
::  %attr  default attributes for subsequent graph/node/edge stmts
::  %set   bare id=id at statement level (graph attribute)
::  %sub   subgraph as a statement
::
+$  stmt-body
  $~  [%set '' '']
  $%  [%node ref=node-ref attrs=alist]
      [%edge from=endpoint to=(lest endpoint) attrs=alist]
      [%attr targ=?(%graph %node %edge) attrs=alist]
      [%set name=id value=id]
      [%sub =subgraph]
  ==
::  +|  Graph
::
::  $graph: a complete DOT source file
::
+$  graph  [strict=? directed=? id=(unit id) stmts=(list stmt)]
--
