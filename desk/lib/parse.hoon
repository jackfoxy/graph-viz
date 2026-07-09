::  parse: DOT text -> AST (P2: lexing primitives)
::
::  Built on the stdlib parser combinators (+rule over +nail), so
::  line/column tracking comes from +hair for free.  P3/P4 grow this
::  core into the full statement grammar.
::
::  Lexical grammar per lang.html:
::    - whitespace and three comment forms (//, /* */, line-start #)
::    - unquoted names   [A-Za-z_\200-\377][A-Za-z0-9_\200-\377]*
::    - numerals         [-]?(.[0-9]+ | [0-9]+(.[0-9]*)?)
::    - quoted strings   with \" escape and backslash-newline
::      continuation; all other backslash escapes kept verbatim
::      (label escapes like \n are decoded at render time, not here)
::    - +-concatenation of quoted strings
::    - case-insensitive keywords, excluded from unquoted ids but
::      legal quoted
::    - HTML-label opener < lexed as an %html marker carrying its
::      position, for P3 to reject as %unsupported-feature
::
/-  ast=ast
/+  print=print
|%
::  +|  Character classes
::
::
++  name-head  ;~(pose low hig cab (shim 128 255))
::
++  name-tail  ;~(pose name-head nud)
::
++  nonl
  ::  any character except newline
  ;~(less (just '\0a') next)
::
++  digits
  ::  one or more decimal digits, as text
  %+  cook  |=([d=@tD ds=tape] `tape`[d ds])
  (plus nud)
::  +|  Whitespace and comments
::
::
++  whit  (mask " \09\0a\0d")
::
++  cmt-line
  ::  // to end of line
  (cold ' ' ;~(plug (jest '//') (star nonl)))
::
++  cmt-block
  ::  /* */, non-nesting
  %+  cold  ' '
  ;~  plug
    (jest '/*')
    (star ;~(less (jest '*/') next))
    (jest '*/')
  ==
::
++  bol
  ::  succeed without consuming, only at column 1
  |=  tul=nail
  ^-  [p=hair q=(unit [p=~ q=nail])]
  ?:  =(1 q.p.tul)
    [p.tul [~ [~ tul]]]
  (fail tul)
::
++  cmt-hash
  ::  line-start # to end of line (C-preprocessor output)
  (cold ' ' ;~(plug bol hax (star nonl)))
::
++  gap
  ::  any run of whitespace and comments, possibly empty
  %+  cold  ~
  (star ;~(pose whit cmt-line cmt-block cmt-hash))
::  +|  Identifiers
::
::
++  name
  ::  unquoted id, keywords included (see +idt for exclusion)
  %+  cook  |=([h=@tD t=tape] (crip [h t]))
  ;~(plug name-head (star name-tail))
::
++  numeral
  ::  numeric id; product is the literal text
  %+  cook
    |=  [m=(unit @tD) body=tape]
    (crip ?~(m body [u.m body]))
  ;~  plug
    (punt hep)
    ;~  pose
      %+  cook  |=([d=@tD ds=tape] `tape`[d ds])
      ;~(plug dot digits)
    ::
      %+  cook
        |=  [ds=tape frac=(unit [d=@tD fs=tape])]
        ^-  tape
        ?~(frac ds (weld ds `tape`[d.u.frac fs.u.frac]))
      ;~(plug digits (punt ;~(plug dot (star nud))))
    ==
  ==
::
++  qchar
  ::  one logical character inside a quoted string; product is the
  ::  decoded text (a continuation decodes to nothing)
  ;~  pose
    (cold "\"" (jest '\\"'))
    (cold "" ;~(plug bas (just '\0a')))
  ::
    %+  cook  |=([a=@tD b=@tD] `tape`~[a b])
    ;~(plug bas next)
  ::
    %+  cook  |=(c=@tD `tape`~[c])
    ;~(less doq next)
  ==
::
++  quoted
  ::  one double-quoted string, decoded
  %+  cook  |=(a=(list tape) (crip (zing a)))
  (ifix [doq doq] (star qchar))
::
++  qstring
  ::  quoted string(s) joined by + (concatenation)
  %+  cook  |=([f=@t r=(list @t)] (rap 3 [f r]))
  ;~  plug
    quoted
    (star ;~(pfix ;~(plug gap lus gap) quoted))
  ==
::
++  kw
  ::  rule for one case-insensitive keyword, e.g. (kw %digraph);
  ::  word boundary is automatic because +name is maximal-munch
  |=  k=@tas
  %+  sear
    |=  t=@t
    ^-  (unit @tas)
    ?:(=(k (crip (cass (trip t)))) `k ~)
  name
::
++  idt
  ::  DOT ID: non-keyword name, numeral, or quoted string(s)
  ;~  pose
    qstring
    numeral
  ::
    %+  sear
      |=  t=@t
      ^-  (unit @t)
      ?:((is-keyword:print (trip t)) ~ `t)
    name
  ==
::  +|  HTML labels (unsupported feature)
::
::  $tok-id: an id, or the position of an HTML-label opener
::
+$  tok-id  $%([%id p=@t] [%html =pos:ast])
::
++  html-mark
  ::  detect < where an id may appear; consumes only the opener
  |=  tul=nail
  ^-  [p=hair q=(unit [p=pos:ast q=nail])]
  ?~  q.tul  (fail tul)
  ?.  =('<' i.q.tul)  (fail tul)
  =/  at=pos:ast  [p.p.tul q.p.tul]
  [p.tul [~ [at [(lust '<' p.tul) t.q.tul]]]]
::
++  idh
  ::  id or html marker, for grammar positions expecting an id
  ;~  pose
    (stag %id idt)
    (stag %html html-mark)
  ==
::  +|  Statement grammar
::
::
++  posed
  ::  pair a rule's product with its start position
  |*  sab=rule
  |=  tul=nail
  =/  at=pos:ast  [p.p.tul q.p.tul]
  =/  vex  (sab tul)
  ?~  q.vex  [p=p.vex q=~]
  [p=p.vex q=(some [p=[at p.u.q.vex] q=q.u.q.vex])]
::
++  to-compass
  ::  compass-point words; '_' is %any
  |=  t=@t
  ^-  (unit compass:ast)
  ?+  t  ~
    %n    `%n
    %ne   `%ne
    %e    `%e
    %se   `%se
    %s    `%s
    %sw   `%sw
    %w    `%w
    %nw   `%nw
    %c    `%c
    %'_'  `%any
  ==
::
++  is-cluster
  ::  cluster naming convention: subgraph id begins with "cluster"
  |=  sid=(unit @t)
  ^-  ?
  ?~  sid  %.n
  =('cluster' (crip (scag 7 (trip u.sid))))
::
++  nref
  ::  node reference: id [: port] [: compass].  With one suffix
  ::  field a compass word is a compass, anything else a port;
  ::  with two, the second must be a compass or the parse fails
  %+  sear
    |=  [i=@t sfx=(unit [p=@t q=(unit @t)])]
    ^-  (unit node-ref:ast)
    ?~  sfx  `[i ~ ~]
    ?~  q.u.sfx
      =/  c  (to-compass p.u.sfx)
      ?~  c  `[i `p.u.sfx ~]
      `[i ~ c]
    =/  c  (to-compass u.q.u.sfx)
    ?~  c  ~
    `[i `p.u.sfx c]
  ;~  plug
    idt
    %-  punt
    ;~  plug
      ;~(pfix gap col gap idt)
      (punt ;~(pfix gap col gap idt))
    ==
  ==
::
++  abind
  ::  one name=value binding
  %+  cook  |=([n=@t v=@t] `attr:ast`[n v])
  ;~(plug idt ;~(pfix gap tis gap idt))
::
++  agroup
  ::  one [ ... ] attribute group; bindings separated by
  ::  optional ; or ,
  %+  ifix  [sel ;~(plug gap ser)]
  %-  star
  ;~  pfix  gap
    ;~(sfix abind ;~(plug gap (punt ;~(pose mic com))))
  ==
::
++  attrs
  ::  attr_list: zero or more bracket groups, concatenated
  %+  cook  |=(a=(list alist:ast) `alist:ast`(zing a))
  (star ;~(pfix gap agroup))
::
++  attrs1
  ::  attr_list with at least one group (attr_stmt requires one).
  ::  note: (zing [f r]), not (weld f (zing r)) — welding alists
  ::  fuse-loops the compiler against this sur's recursive types
  %+  cook
    |=([f=alist:ast r=(list alist:ast)] `alist:ast`(zing [f r]))
  (plus ;~(pfix gap agroup))
::
++  atarg
  ::  attr_stmt target keyword
  ;~  pose
    (cold %graph (kw %graph))
    (cold %node (kw %node))
    (cold %edge (kw %edge))
  ==
::
++  attr-stmt
  %+  cook
    |=  [t=?(%graph %node %edge) at=alist:ast]
    `stmt-body:ast`[%attr t at]
  ;~(plug atarg attrs1)
::
++  set-stmt
  %+  cook  |=([n=@t v=@t] `stmt-body:ast`[%set n v])
  ;~(plug idt ;~(pfix gap tis gap idt))
::
++  node-stmt
  %+  cook
    |=([r=node-ref:ast at=alist:ast] `stmt-body:ast`[%node r at])
  ;~(plug nref attrs)
::
++  gram
  ::  directedness-parameterized grammar: edge operator, edge
  ::  chains with subgraph endpoints, subgraphs, statement lists
  |_  dir=?
  ::
  ++  eop
    ::  edge operator: -> in digraph, -- in graph; a mismatch is
    ::  a parse error at the operator's position
    ?:(dir (jest '->') (jest '--'))
  ::
  ++  endp
    ::  edge endpoint: subgraph or node reference
    ;~  pose
      (stag %sub subg)
      (stag %node nref)
    ==
  ::
  ++  edge-stmt
    %+  cook
      |=  [f=endpoint:ast r=(lest endpoint:ast) at=alist:ast]
      ^-  stmt-body:ast
      [%edge f r at]
    ;~  plug
      endp
      (plus ;~(pfix gap eop gap endp))
      attrs
    ==
  ::
  ++  subg
    ::  subgraph: [subgraph [id]] { stmt-list }; keyword optional.
    ::  +knee defers rule construction so the grammar can recurse
    %+  knee  *subgraph:ast
    |.  ~+
    %+  cook
      |=  [hed=(unit (unit @t)) st=(list stmt:ast)]
      ^-  subgraph:ast
      [?~(hed ~ u.hed) st]
    ;~  plug
      %-  punt
      ;~(sfix ;~(pfix (kw %subgraph) (punt ;~(pfix gap idt))) gap)
    ::
      (ifix [kel ;~(plug gap ker)] stmts)
    ==
  ::
  ++  one-stmt
    ::  one statement with its source position; order matters:
    ::  keywords can't be ids, sets and edges before bare nodes,
    ::  edge chains before lone subgraph statements
    %-  posed
    ;~  pose
      attr-stmt
      set-stmt
      edge-stmt
      (stag %sub subg)
      node-stmt
    ==
  ::
  ++  stmts
    ::  statement list; semicolon separators optional
    %-  star
    ;~  pfix  gap
      ;~(sfix one-stmt ;~(plug gap (punt mic)))
    ==
  --
::
++  header
  ::  strict? (graph | digraph) id?
  %+  cook
    |=  [s=(unit @tas) d=? i=(unit @t)]
    ^-  [strict=? directed=? id=(unit @t)]
    [?=(^ s) d i]
  ;~  plug
    ;~(pfix gap (punt ;~(sfix (kw %strict) gap)))
    ;~(pose (cold %.y (kw %digraph)) (cold %.n (kw %graph)))
    (punt ;~(pfix gap idt))
  ==
::
++  body
  ::  braced statement list for a graph of known directedness
  |=  dir=?
  ;~  pfix  gap
    (ifix [kel ;~(plug gap ker)] ~(stmts gram dir))
  ==
::
++  graf
  ::  a complete graph; directedness from the header selects the
  ::  edge operator for the body
  |=  tul=nail
  ^-  [p=hair q=(unit [p=graph:ast q=nail])]
  =/  hed  (header tul)
  ?~  q.hed  [p=p.hed q=~]
  =/  bod  ((body directed.p.u.q.hed) q.u.q.hed)
  ?~  q.bod  [p=(last p.hed p.bod) q=~]
  =/  grf=graph:ast
    :*  strict.p.u.q.hed
        directed.p.u.q.hed
        id.p.u.q.hed
        p.u.q.bod
    ==
  [p=(last p.hed p.bod) q=(some [p=grf q=q.u.q.bod])]
::  +|  Driver
::
::  $fail-at: parse failure, or HTML label (unsupported feature)
::
+$  fail-at
  $%  [%parse =pos:ast]
      [%html =pos:ast]
  ==
::
++  char-at
  ::  character at a source position, if any
  |=  [tp=tape at=pos:ast]
  ^-  (unit @tD)
  =/  ln  1
  =/  co  1
  |-  ^-  (unit @tD)
  ?~  tp  ~
  ?:  &(=(ln line.at) =(co col.at))  `i.tp
  ?:  =('\0a' i.tp)
    $(tp t.tp, ln +(ln), co 1)
  $(tp t.tp, co +(co))
::
++  parse
  ::  DOT text -> graph, or failure position
  |=  txt=@t
  ^-  (each graph:ast fail-at)
  =/  tp  (trip txt)
  =/  vex  ((full ;~(sfix graf gap)) [[1 1] tp])
  ?^  q.vex  [%& p.u.q.vex]
  =/  at=pos:ast  [p.p.vex q.p.vex]
  ?:  =(`'<' (char-at tp at))
    [%| %html at]
  [%| %parse at]
--
