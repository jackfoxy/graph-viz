::  Tests for /lib/parse (P2: lexing primitives)
::
/-  ast=ast
/+  *test, parse
|%
::  +|  Helpers
::
::
++  fpos
  ::  farthest-failure position of a full parse expected to fail
  |*  [txt=tape sab=rule]
  p:((full sab) [[1 1] txt])
::
++  first-tok
  ::  product of the first token parsed, ignoring trailing input
  |*  [txt=tape sab=rule]
  =/  vex  (sab [[1 1] txt])
  ?~  q.vex  ~
  `p.u.q.vex
::  +|  Identifier classes
::
::
++  test-names
  ;:  weld
    (expect-eq !>(`'hello') !>((rust "hello" name:parse)))
    (expect-eq !>(`'_x1') !>((rust "_x1" name:parse)))
    (expect-eq !>(`'Ab9') !>((rust "Ab9" name:parse)))
    %+  expect-eq  !>(`(crip "caf\c3\a9"))
    !>((rust "caf\c3\a9" name:parse))
  ::
    (expect-eq !>(~) !>((rust "1x" name:parse)))
    (expect-eq !>(~) !>((rust "a-b" name:parse)))
  ==
::
++  test-numerals
  ;:  weld
    (expect-eq !>(`'2') !>((rust "2" numeral:parse)))
    (expect-eq !>(`'-3.14') !>((rust "-3.14" numeral:parse)))
    (expect-eq !>(`'.5') !>((rust ".5" numeral:parse)))
    (expect-eq !>(`'2.') !>((rust "2." numeral:parse)))
    (expect-eq !>(`'-.5') !>((rust "-.5" numeral:parse)))
    (expect-eq !>(~) !>((rust "-" numeral:parse)))
    (expect-eq !>(~) !>((rust "1.2.3" numeral:parse)))
    (expect-eq !>(~) !>((rust "." numeral:parse)))
  ==
::
++  test-quoted
  ;:  weld
    (expect-eq !>(`'hello') !>((rust "\"hello\"" quoted:parse)))
    (expect-eq !>(`'') !>((rust "\"\"" quoted:parse)))
  ::  \" decodes to a bare quote
    %+  expect-eq  !>(`'say "hi"')
    !>((rust "\"say \\\"hi\\\"\"" quoted:parse))
  ::  other backslash escapes kept verbatim
    %+  expect-eq  !>(`'a\\nb')
    !>((rust "\"a\\nb\"" quoted:parse))
  ::  backslash-newline is a continuation
    %+  expect-eq  !>(`'abcd')
    !>((rust "\"ab\\\0acd\"" quoted:parse))
  ::  literal newline is kept
    %+  expect-eq  !>(`(crip "a\0ab"))
    !>((rust "\"a\0ab\"" quoted:parse))
  ::  keywords are legal quoted
    (expect-eq !>(`'graph') !>((rust "\"graph\"" idt:parse)))
  ==
::
++  test-concat
  ;:  weld
    %+  expect-eq  !>(`'ab')
    !>((rust "\"a\"+\"b\"" qstring:parse))
  ::
    %+  expect-eq  !>(`'abc')
    !>((rust "\"a\" + \"b\" + \"c\"" qstring:parse))
  ::  comments are legal around +
    %+  expect-eq  !>(`'ab')
    !>((rust "\"a\" /* c */ + // d\0a\"b\"" qstring:parse))
  ::  + only joins quoted strings
    (expect-eq !>(~) !>((rust "\"a\" + b" qstring:parse)))
  ==
::  +|  Keywords
::
::
++  test-keywords
  ;:  weld
    %+  expect-eq  !>(`%digraph)
    !>((rust "digraph" (kw:parse %digraph)))
  ::
    %+  expect-eq  !>(`%digraph)
    !>((rust "DiGraph" (kw:parse %digraph)))
  ::
    %+  expect-eq  !>(`%digraph)
    !>((rust "DIGRAPH" (kw:parse %digraph)))
  ::
    %+  expect-eq  !>(`%strict)
    !>((rust "Strict" (kw:parse %strict)))
  ::  word boundary: no prefix match
    (expect-eq !>(~) !>((rust "digraphs" (kw:parse %digraph))))
  ::  keywords are not unquoted ids
    (expect-eq !>(~) !>((rust "graph" idt:parse)))
    (expect-eq !>(~) !>((rust "NODE" idt:parse)))
  ==
::  +|  Comments and whitespace
::
::
++  test-comments
  ;:  weld
    (expect-eq !>(`~) !>((rust "// foo" gap:parse)))
    (expect-eq !>(`~) !>((rust "/* a\0a b */" gap:parse)))
    (expect-eq !>(`~) !>((rust "# cpp\0a" gap:parse)))
  ::  all forms mixed, hash at column 1 mid-file
    %+  expect-eq  !>(`~)
    !>((rust "\0a  \0a# x\0a  // y\0a/* z */" gap:parse))
  ::  hash comment must start at column 1
    (expect-eq !>(~) !>((rust "  # x" gap:parse)))
  ==
::  +|  Error positions
::
::
++  test-error-positions
  ;:  weld
    (expect-eq !>([1 1]) !>((fpos "1x" name:parse)))
    (expect-eq !>([1 3]) !>((fpos "ab*cd" name:parse)))
  ::  unterminated quoted string fails at end of input
    (expect-eq !>([3 5]) !>((fpos "\"a\0ab\0a  cd" quoted:parse)))
  ==
::  +|  Statement-level builders
::
::
++  nn  |=(=id:ast `endpoint:ast`[%node [id ~ ~]])
::
++  n-s
  |=  [p=pos:ast =id:ast at=alist:ast]
  ^-  stmt:ast
  [p [%node [id ~ ~] at]]
::
++  e-s
  |=  [p=pos:ast f=id:ast ts=(lest id:ast) at=alist:ast]
  ^-  stmt:ast
  [p [%edge (nn f) [(nn i.ts) (turn t.ts nn)] at]]
::
++  ok
  |=  g=graph:ast
  ^-  (each graph:ast fail-at:parse)
  [%& g]
::  +|  Statement parsing
::
::
++  test-parse-hello
  %+  expect-eq
    !>  %-  ok
        [%.n %.y `'G' ~[(e-s [1 12] 'hello' ['world' ~] ~)]]
  !>  (parse:parse 'digraph G {hello -> world}')
::
++  test-parse-empty-headers
  ;:  weld
    %+  expect-eq  !>((ok [%.n %.n ~ ~]))
    !>((parse:parse 'graph{}'))
  ::
    %+  expect-eq  !>((ok [%.y %.y ~ ~]))
    !>((parse:parse 'STRICT DiGraph {}'))
  ::
    %+  expect-eq  !>((ok [%.y %.n `'Gg' ~]))
    !>((parse:parse 'strict graph Gg {}'))
  ==
::
++  test-parse-chain-attrs
  %+  expect-eq
    !>  %-  ok
        :*  %.n  %.y  ~
            ~[(e-s [2 3] 'a' ['b' 'c' ~] ~[['color' 'red']])]
        ==
  !>  (parse:parse 'digraph {\0a  a -> b -> c [color=red];\0a}')
::
++  test-parse-attr-groups
  ::  multiple bracket groups concatenate
  %+  expect-eq
    !>  %-  ok
        [%.n %.n ~ ~[(n-s [1 9] 'n' ~[['a' '1'] ['b' '2']])]]
  !>  (parse:parse 'graph { n [a=1] [b=2] }')
::
++  test-parse-alist-separators
  ::  ; and , and nothing all separate bindings
  %+  expect-eq
    !>  %-  ok
        [%.n %.n ~ ~[(n-s [1 9] 'n' ~[['a' '1'] ['b' '2'] ['c' '3']])]]
  !>  (parse:parse 'graph { n [a=1; b=2 c=3] }')
::
++  test-parse-attr-stmts
  %+  expect-eq
    !>  %-  ok
        :*  %.n  %.y  ~
            :~  [[1 11] [%attr %node ~[['shape' 'box'] ['color' 'blue']]]]
                [[1 41] [%attr %edge ~]]
                [[1 50] [%attr %graph ~[['x' 'y']]]]
        ==  ==
  !>  %-  parse:parse
      'digraph { node [shape=box, color=blue]; edge []; graph [x=y] }'
::
++  test-parse-set-stmt
  %+  expect-eq
    !>  (ok [%.n %.n ~ ~[[[1 9] [%set 'rankdir' 'LR']]]])
  !>  (parse:parse 'graph { rankdir = LR }')
::
++  test-parse-quoted-numeral-ids
  %+  expect-eq
    !>  (ok [%.n %.y ~ ~[(e-s [1 11] 'a b' ['3.14' ~] ~)]])
  !>  (parse:parse 'digraph { "a b" -> 3.14 }')
::
++  test-parse-stmt-separators
  ::  semicolons and newlines both optional separators
  %+  expect-eq
    !>  %-  ok
        :*  %.n  %.y  ~
            ~[(n-s [1 11] 'a' ~) (n-s [1 14] 'b' ~) (n-s [2 1] 'c' ~)]
        ==
  !>  (parse:parse 'digraph { a; b\0ac }')
::
++  test-parse-trailing-comment
  %+  expect-eq
    !>  (ok [%.n %.y ~ ~[(n-s [1 11] 'a' ~)]])
  !>  (parse:parse 'digraph { a }\0a// done\0a')
::  +|  Ports and subgraphs (P4)
::
::
++  test-parse-ports
  =/  expected=graph:ast
    :*  %.n  %.y  ~
        :~  :-  [1 11]
            :*  %edge
                [%node ['a' `'p1' ~]]
                ~[[%node ['b' ~ `%ne]]]
                ~
            ==
            :-  [2 1]
            :*  %edge
                [%node ['c' `'p2' `%sw]]
                ~[[%node ['d' `'q port' `%any]]]
                ~
            ==
        ==
    ==
  %+  expect-eq  !>((ok expected))
  !>  %-  parse:parse
      'digraph { a:p1 -> b:ne;\0ac:p2:sw -> d:"q port":_ }'
::
++  test-parse-bad-compass
  ::  two-field port with a non-compass second field fails
  =/  r  (parse:parse 'digraph { x:n:q }')
  (expect !>(?=(%| -.r)))
::
++  test-parse-subgraph-stmts
  ;:  weld
  ::  named subgraph statement, keyword form
    %+  expect-eq
      !>  %-  ok
          :*  %.n  %.y  ~
              ~[[[1 11] [%sub `'s' ~[(n-s [1 24] 'a' ~)]]]]
          ==
    !>  (parse:parse 'digraph { subgraph s { a } }')
  ::  anonymous, keyword optional
    %+  expect-eq
      !>  %-  ok
          :*  %.n  %.y  ~
              ~[[[1 11] [%sub ~ ~[(n-s [1 13] 'b' ~)]]]]
          ==
    !>  (parse:parse 'digraph { { b } }')
  ==
::
++  test-parse-subgraph-endpoints
  =/  expected=graph:ast
    :*  %.n  %.y  ~
        :~  :-  [1 11]
            :*  %edge
                [%sub ~ ~[(n-s [1 12] 'a' ~) (n-s [1 14] 'b' ~)]]
                ~[[%node ['c' ~ ~]]]
                ~
            ==
        ==
    ==
  %+  expect-eq  !>((ok expected))
  !>  (parse:parse 'digraph { {a b} -> c }')
::  +|  Parse errors
::
::
++  test-parse-errors
  ;:  weld
  ::  wrong edge op for directedness; the shared first char of
  ::  -> and -- matches, so the position is the op's second char
    %+  expect-eq  !>([%| %parse 1 14])
    !>((parse:parse 'digraph { a -- b }'))
  ::
    %+  expect-eq  !>([%| %parse 1 12])
    !>((parse:parse 'graph { a -> b }'))
  ::
    %+  expect-eq  !>([%| %parse 3 6])
    !>((parse:parse 'digraph {\0a  a -> b\0a  c -- d\0a}'))
  ::  unclosed brace fails at end of input
    %+  expect-eq  !>([%| %parse 1 12])
    !>((parse:parse 'digraph { a'))
  ::  html label opener
    %+  expect-eq  !>([%| %html 1 16])
    !>((parse:parse 'digraph { a -> <table>x }'))
  ==
::  +|  HTML labels
::
::
++  test-html-rejected
  ;:  weld
    %+  expect-eq  !>(`[%html 1 1])
    !>((first-tok "<table>x" idh:parse))
  ::
    %+  expect-eq  !>(`[%id 'abc'])
    !>((first-tok "abc" idh:parse))
  ::  position reported through preceding gap
    %+  expect-eq  !>(`[%html 3 3])
    !>((first-tok "\0a\0a  <b>" ;~(pfix gap:parse idh:parse)))
  ==
--
