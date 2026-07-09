::  print: AST -> canonical DOT text
::
::  Canonical form: two-space indents, one statement per line, every
::  statement semicolon-terminated except block subgraphs, ids quoted
::  only when required.  Parser tests (P3/P4) use this as an oracle:
::  parse->print->parse must be a fixpoint.
::
::  Subgraphs appearing as statements render as indented blocks;
::  subgraphs appearing as edge endpoints render inline.  A port
::  name that collides with a compass word (a:ne) prints ambiguously;
::  the parser owns that corner (P4).
::
/-  ast=ast
|%
::  +|  Public API
::
::
++  print
  ::  render a full DOT graph as text
  |=  g=graph:ast
  ^-  @t
  (crip ~(en-graph pr g))
::  +|  Graph renderer
::
::  +pr: door over the graph, so directedness (edge operator)
::  is available to every statement renderer
::
++  pr
  |_  g=graph:ast
  ::
  ++  edgeop
    ^-  tape
    ?:(directed.g " -> " " -- ")
  ::
  ++  en-graph
    ^-  tape
    ;:  weld
      ?:(strict.g "strict " "")
      ?:(directed.g "digraph" "graph")
      ?~(id.g "" (weld " " (en-id u.id.g)))
      " \{\0a"
      (en-stmts 1 stmts.g)
      "}\0a"
    ==
  ::
  ++  en-stmts
    |=  [depth=@ud stmts=(list stmt:ast)]
    ^-  tape
    %-  zing
    %+  turn  stmts
    |=  =stmt:ast
    (en-stmt depth stmt)
  ::
  ++  en-stmt
    |=  [depth=@ud =stmt:ast]
    ^-  tape
    ?:  ?=([%sub *] body.stmt)
      (en-sub-block depth subgraph.body.stmt)
    %+  runt  [(mul 2 depth) ' ']
    (weld (en-stmt-flat body.stmt) ";\0a")
  ::
  ++  en-stmt-flat
    ::  one statement, no indentation or terminator
    |=  body=stmt-body:ast
    ^-  tape
    ?-  -.body
        %node
      (weld (en-node-ref ref.body) (en-alist attrs.body))
    ::
        %edge
      =/  rhs=tape
        %-  zing
        %+  turn  `(list endpoint:ast)`to.body
        |=  ep=endpoint:ast
        (weld edgeop (en-endpoint ep))
      :(weld (en-endpoint from.body) rhs (en-alist attrs.body))
    ::
        %attr
      %+  weld  (trip targ.body)
      ?~(attrs.body " []" (en-alist attrs.body))
    ::
        %set
      :(weld (en-id name.body) "=" (en-id value.body))
    ::
        %sub
      (en-sub-inline subgraph.body)
    ==
  ::
  ++  en-endpoint
    |=  ep=endpoint:ast
    ^-  tape
    ?-  -.ep
      %node  (en-node-ref ref.ep)
      %sub   (en-sub-inline subgraph.ep)
    ==
  ::
  ++  en-sub-block
    |=  [depth=@ud sub=subgraph:ast]
    ^-  tape
    =/  sp  (mul 2 depth)
    ;:  weld
      %+  runt  [sp ' ']
      ?~  id.sub  "\{\0a"
      :(weld "subgraph " (en-id u.id.sub) " \{\0a")
      (en-stmts +(depth) stmts.sub)
      (runt [sp ' '] "}\0a")
    ==
  ::
  ++  en-sub-inline
    |=  sub=subgraph:ast
    ^-  tape
    =/  inner=tape
      %-  zing
      %+  turn  stmts.sub
      |=  =stmt:ast
      (weld (en-stmt-flat body.stmt) "; ")
    ;:  weld
      ?~(id.sub "" :(weld "subgraph " (en-id u.id.sub) " "))
      "\{ "
      inner
      "}"
    ==
  --
::  +|  Identifier rendering
::
::
++  en-id
  ::  render an id, quoting only when required
  |=  =id:ast
  ^-  tape
  =/  tp  (trip id)
  ?.  (needs-quote tp)  tp
  :(weld "\"" (escape-quotes tp) "\"")
::
++  needs-quote
  |=  tp=tape
  ^-  ?
  ?:  =(~ tp)  %.y
  ?:  (is-keyword tp)  %.y
  ?:  (is-name tp)  %.n
  ?:  (is-numeral tp)  %.n
  %.y
::
++  escape-quotes
  ::  DOT quoted strings: only '"' needs escaping; backslashes
  ::  pass through (label escapes like \n stay literal)
  |=  tp=tape
  ^-  tape
  %-  zing
  %+  turn  tp
  |=  c=@tD
  ^-  tape
  ?:(=('"' c) "\\\"" [c ~])
::
++  en-compass
  |=  c=compass:ast
  ^-  tape
  ?:(=(%any c) "_" (trip c))
::
++  en-node-ref
  |=  ref=node-ref:ast
  ^-  tape
  ;:  weld
    (en-id id.ref)
    ?~(port.ref "" (weld ":" (en-id u.port.ref)))
    ?~(compass.ref "" (weld ":" (en-compass u.compass.ref)))
  ==
::
++  en-alist
  ::  leading space + bracketed bindings; empty renders as nothing
  |=  attrs=alist:ast
  ^-  tape
  ?~  attrs  ""
  :(weld " [" (join-comma (turn attrs en-attr)) "]")
::
++  en-attr
  |=  =attr:ast
  ^-  tape
  :(weld (en-id name.attr) "=" (en-id value.attr))
::  +|  Character classes (DOT lexical grammar)
::
::
++  keywords
  ^-  (list tape)
  ~["node" "edge" "graph" "digraph" "subgraph" "strict"]
::
++  is-keyword
  ::  keywords are case-insensitive
  |=  tp=tape
  ^-  ?
  =/  low  (cass tp)
  (lien keywords |=(k=tape =(k low)))
::
++  is-name
  ::  unquoted id: [A-Za-z_\200-\377][A-Za-z0-9_\200-\377]*
  |=  tp=tape
  ^-  ?
  ?~  tp  %.n
  ?.  (is-name-head i.tp)  %.n
  (levy t.tp is-name-tail)
::
++  is-name-head
  |=  c=@tD
  ^-  ?
  ?|  &((gte c 'a') (lte c 'z'))
      &((gte c 'A') (lte c 'Z'))
      =('_' c)
      (gte c 0x80)
  ==
::
++  is-name-tail
  |=  c=@tD
  ^-  ?
  |((is-name-head c) (is-digit c))
::
++  is-digit
  |=  c=@tD
  ^-  ?
  &((gte c '0') (lte c '9'))
::
++  is-numeral
  ::  numeral: [-]?(.[0-9]+ | [0-9]+(.[0-9]*)?)
  |=  tp=tape
  ^-  ?
  =/  body=tape
    ?~  tp  tp
    ?:(=('-' i.tp) t.tp tp)
  ?~  body  %.n
  ?:  =('.' i.body)
    ?~  t.body  %.n
    ::  cast: wet +levy chokes on a ?~-refined nonempty tape
    (levy `tape`t.body is-digit)
  ?.  (is-digit i.body)  %.n
  =/  rest=tape  t.body
  =/  seen-dot=?  %.n
  |-  ^-  ?
  ?~  rest  %.y
  ?:  (is-digit i.rest)  $(rest t.rest)
  ?:  &(!seen-dot =('.' i.rest))
    $(rest t.rest, seen-dot %.y)
  %.n
::
++  join-comma
  |=  parts=(list tape)
  ^-  tape
  ?~  parts  ""
  =/  acc=tape  i.parts
  =/  rest=(list tape)  t.parts
  |-  ^-  tape
  ?~  rest  acc
  $(acc :(weld acc ", " i.rest), rest t.rest)
--
