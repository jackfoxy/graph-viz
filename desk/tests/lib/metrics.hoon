::  Tests for /lib/metrics and /sur/graph (P6)
::
/-  gg=graph
/+  *test, metrics
|%
::  +|  Helpers
::
::
++  wof
  |=  [txt=@t size=@rs]
  ^-  @rs
  w:(text-size:metrics size txt)
::
++  hof
  |=  [txt=@t size=@rs]
  ^-  @rs
  h:(text-size:metrics size txt)
::
++  expect-between
  |=  [lo=@rs v=@rs hi=@rs]
  ^-  tang
  ?:  &((gte:rs v lo) (lte:rs v hi))  ~
  :~  [%palm [": " ~ ~ ~] [leaf+"out of range" >[lo v hi]< ~]]
  ==
::  +|  Monotonicity
::
::
++  test-monotonic
  ;:  weld
    (expect !>((gte:rs (wof 'ab' .14) (wof 'a' .14))))
    (expect !>((gte:rs (wof 'a' .14) (wof '' .14))))
    (expect !>((gte:rs (wof 'hello world' .14) (wof 'hello' .14))))
    (expect !>((gth:rs (wof 'mmm' .14) (wof 'iii' .14))))
  ==
::
++  test-linear-in-size
  ::  width scales linearly with font size (2x is exact in fp)
  %+  expect-eq
    !>  (mul:rs .2 (wof 'hello' .14))
  !>  (wof 'hello' .28)
::  +|  Known widths vs Helvetica
::
::
++  test-known-widths
  ;:  weld
  ::  "hello" at 14pt: 2112/1000 * 14 = 29.568
    (expect-between .29.5 (wof 'hello' .14) .29.65)
  ::  "Hello, World!" at 14pt: 5723/1000 * 14 = 80.122
    (expect-between .80.0 (wof 'Hello, World!' .14) .80.25)
  ::  "123" at 10pt: 3*556/1000 * 10 = 16.68
    (expect-between .16.6 (wof '123' .10) .16.76)
  ==
::  +|  Lines and escapes
::
::
++  test-multiline
  ;:  weld
  ::  \n escape breaks lines: height doubles, width is the max
    (expect-between .23.9 (hof 'ab\\ncd' .10) .24.1)
    (expect-between .11.0 (wof 'ab\\ncd' .10) .11.24)
  ::  single line at 10pt is 12 high
    (expect-between .11.9 (hof 'ab' .10) .12.1)
  ::  literal newline breaks too
    (expect-between .23.9 (hof (crip "ab\0acd") .10) .24.1)
  ::  \l and \r break like \n
    (expect-between .23.9 (hof 'ab\\lcd' .10) .24.1)
    (expect-between .23.9 (hof 'ab\\rcd' .10) .24.1)
  ==
::
++  test-escapes
  ::  a non-break escape measures as its escaped character
  (expect-eq !>((wof 'azb' .14)) !>((wof 'a\\zb' .14)))
::
++  test-utf8
  ::  one multibyte codepoint = one fallback width: 600/1000 * 10
  (expect-between .5.9 (wof 'é' .10) .6.1)
::  +|  Positioned-graph sur
::
::
++  test-graph-sur-typecheck
  =/  g
    ^-  graph:gg
    :*  name='t'
        canvas=[[.100 .80] .1]
        directed=%.y
        :~  :*  name='a'
                center=[.20 .60]
                half=[.27 .18]
                shape='ellipse'
                attrs=~
                label='a'
                label-at=[.20 .60]
            ==
        ==
        :~  :*  tail=0
                head=0
                spline=~[[.20 .42] [.20 .35] [.20 .28] [.20 .21]]
                arrows=~[~[[.20 .21] [.17 .28] [.23 .28]]]
                label=~
                attrs=~
            ==
        ==
        ~
    ==
  ;:  weld
    (expect-eq !>(1) !>((lent nodes.g)))
    (expect-eq !>(4) !>((lent spline:(snag 0 edges.g))))
  ==
--
