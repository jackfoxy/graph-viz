::  Tests for /lib/svg (P11: SVG codegen)
::
/-  gg=graph
/+  *test, parse, attr, rank, order, coord
/+  route, svg
|%
::  +|  Helpers
::
::
++  pipe
  |=  txt=@t
  ^-  graph:gg
  =/  r  (parse:parse txt)
  ?>  ?=(%& -.r)
  =/  res  (resolve:attr p.r ~)
  =/  g  (rank-graph:rank res)
  =/  o  (order-graph:order res g)
  =/  c  (coord-graph:coord res g o)
  (build-graph:route res g c)
::
++  svg-of
  |=  txt=@t
  ^-  tape
  =/  out  (render:svg (pipe txt) %.n)
  ?>  ?=(%& -.out)
  (trip p.out)
::
++  has-part
  |=  [hay=tape ndl=tape]
  ^-  ?
  ?=(^ (find ndl hay))
::
++  count-part
  |=  [hay=tape ndl=tape]
  ^-  @ud
  =/  n  0
  |-  ^-  @ud
  =/  hit  (find ndl hay)
  ?~  hit  n
  $(hay (slag +((need hit)) hay), n +(n))
::  +|  Formatting units
::
::
++  test-svg-fmt
  ;:  weld
    (expect-eq !>("27.00") !>((fmt:svg .27)))
    (expect-eq !>("-1.50") !>((fmt:svg .-1.5)))
    (expect-eq !>("0.13") !>((fmt:svg .0.125)))
    (expect-eq !>("0.00") !>((fmt:svg .0)))
  ==
::
++  test-svg-esc
  %+  expect-eq
    !>("&lt;a &amp; &quot;b&quot;&gt;")
  !>((esc:svg "<a & \"b\">"))
::
++  test-svg-colors
  ;:  weld
    (expect-eq !>("#b2dfee") !>((color-of:svg 'lightblue2')))
    (expect-eq !>("#00ff00") !>((color-of:svg 'green')))
    (expect-eq !>("#a020f0") !>((color-of:svg 'purple')))
    (expect-eq !>("#abc123") !>((color-of:svg '#abc123')))
    (expect-eq !>("#00ffff") !>((color-of:svg '0.5 1 1')))
    (expect-eq !>("#ff0000") !>((color-of:svg '0,1,1')))
    (expect-eq !>("nonesuch") !>((color-of:svg 'nonesuch')))
    (expect-eq !>("none") !>((color-of:svg 'transparent')))
  ==
::
++  test-svg-label-lines
  %+  expect-eq
    !>  ^-  (list [align=?(%c %l %r) text=tape])
        ~[[%c "ab"] [%l "cd"] [%c "ef"]]
  !>((label-lines:svg "ab\\ncd\\lef"))
::
++  test-svg-bio-label-offset
  ;:  weld
    (expect-eq !>(.7) !>((bio-label-offset:svg 'promoter')))
    (expect-eq !>(.7) !>((bio-label-offset:svg 'primersite')))
    (expect-eq !>(.0) !>((bio-label-offset:svg 'cds')))
    (expect-eq !>(.0) !>((bio-label-offset:svg 'rarrow')))
    (expect-eq !>(.0) !>((bio-label-offset:svg 'box')))
  ==
::  +|  Golden (hand-built positioned graph)
::
::
++  test-svg-golden
  =/  pg
    ^-  graph:gg
    :*  name='t'
        canvas=[[.100 .100] .1]
        directed=%.y
        :~  :*  name='A'
                center=[.50 .80]
                half=[.20 .10]
                shape='box'
                attrs=(malt ~[['style' 'filled']])
                label='A'
                label-at=[.50 .80]
            ==
            :*  name='B'
                center=[.50 .20]
                half=[.20 .10]
                shape='ellipse'
                attrs=~
                label='B'
                label-at=[.50 .20]
            ==
        ==
        :~  :*  tail=0
                head=1
                spline=~[[.50 .70] [.50 .60] [.50 .40] [.50 .30]]
                arrows=~[~[[.50 .30] [.53 .40] [.47 .40]]]
                label=~
                attrs=~
            ==
        ==
        ~
    ==
  =/  out  (render:svg pg %.n)
  ?>  ?=(%& -.out)
  =/  expected
    ;:  weld
      "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\0a"
      "<svg width=\"108.00pt\" height=\"108.00pt\" "
      "viewBox=\"0.00 0.00 108.00 108.00\" "
      "xmlns=\"http://www.w3.org/2000/svg\" "
      "xmlns:xlink=\"http://www.w3.org/1999/xlink\">\0a"
      "<g id=\"graph0\" class=\"graph\" "
      "transform=\"translate(4 4) scale(1.00)\">\0a"
      "<title>t</title>\0a"
      "<g id=\"edge1\" class=\"edge\">\0a"
      "<title>A-&gt;B</title>\0a"
      "<path fill=\"none\" stroke=\"#000000\" "
      "d=\"M50.00,30.00C50.00,40.00 50.00,60.00 50.00,70.00\"/>\0a"
      "<polygon fill=\"#000000\" stroke=\"#000000\" "
      "points=\"50.00,70.00 53.00,60.00 47.00,60.00\"/>\0a"
      "</g>\0a"
      "<g id=\"node1\" class=\"node\">\0a"
      "<title>A</title>\0a"
      "<polygon fill=\"#d3d3d3\" stroke=\"#000000\" "
      "points=\"30.00,10.00 70.00,10.00 70.00,30.00 30.00,30.00\"/>\0a"
      "<text text-anchor=\"middle\" x=\"50.00\" y=\"25.04\" "
      "font-family=\"Times,serif\" font-size=\"14.00\" "
      "fill=\"#000000\">A</text>\0a"
      "</g>\0a"
      "<g id=\"node2\" class=\"node\">\0a"
      "<title>B</title>\0a"
      "<ellipse fill=\"none\" stroke=\"#000000\" cx=\"50.00\" "
      "cy=\"80.00\" rx=\"20.00\" ry=\"10.00\"/>\0a"
      "<text text-anchor=\"middle\" x=\"50.00\" y=\"85.04\" "
      "font-family=\"Times,serif\" font-size=\"14.00\" "
      "fill=\"#000000\">B</text>\0a"
      "</g>\0a"
      "</g>\0a</svg>\0a"
    ==
  (expect-eq !>((crip expected)) !>(p.out))
::  +|  End-to-end structure
::
::
++  test-svg-structure
  =/  s  (svg-of 'digraph G {hello -> world}')
  =/  edge-pos  (need (find "<g id=\"edge1\"" s))
  =/  node-pos  (need (find "<g id=\"node1\"" s))
  ;:  weld
    (expect !>((has-part s "<?xml version=")))
    (expect !>((has-part s "<g id=\"node1\" class=\"node\">")))
    (expect !>((has-part s "<title>hello</title>")))
    (expect !>((has-part s "<g id=\"edge1\" class=\"edge\">")))
    (expect !>((has-part s "<title>hello-&gt;world</title>")))
    (expect !>((has-part s "</svg>")))
    (expect !>((lth edge-pos node-pos)))
  ::  balanced groups
    (expect-eq !>((count-part s "<g ")) !>((count-part s "</g>")))
  ==
::
++  test-svg-cluster-structure
  =/  s
    %-  svg-of
    'digraph {subgraph cluster_0 {label="p1"; a -> b} a -> c}'
  ;:  weld
    (expect !>((has-part s "class=\"cluster\"")))
    (expect !>((has-part s "<title>cluster_0</title>")))
    (expect !>((has-part s ">p1</text>")))
  ==
::
++  test-svg-styles
  =/  s
    %-  svg-of
    'digraph {a [style=filled, fillcolor=hotpink]; a -> b [style=dashed]}'
  ;:  weld
    (expect !>((has-part s "fill=\"#ff69b4\"")))
    (expect !>((has-part s "stroke-dasharray=\"5,2\"")))
  ==
::
++  test-svg-invis
  =/  s
    (svg-of 'digraph {node [style=invis]; a -> b [style=invis]}')
  ;:  weld
    (expect !>(!(has-part s "<ellipse")))
    (expect !>(!(has-part s "<path")))
  ::  titles survive for tooling
    (expect !>((has-part s "<title>a</title>")))
  ==
::
++  test-svg-flip-y
  =/  pg  (pipe 'digraph {a -> b}')
  =/  a  (render:svg pg %.n)
  =/  b  (render:svg pg %.y)
  ?>  &(?=(%& -.a) ?=(%& -.b))
  (expect !>(!=(p.a p.b)))
::
++  test-svg-record-rejected
  =/  out  (render:svg (pipe 'digraph {a [shape=record]}') %.n)
  (expect !>(?=(%| -.out)))
::
++  test-svg-real-shapes
  =/  shapes=(list @t)
    :~  'ellipse'  'circle'  'egg'  'triangle'  'box'  'square'
        'plaintext'  'plain'  'diamond'  'trapezium'  'parallelogram'
        'house'  'pentagon'  'hexagon'  'septagon'  'octagon'
        'note'  'tab'  'folder'  'box3d'  'component'  'underline'
        'cylinder'  'doublecircle'  'invtriangle'  'invtrapezium'
        'invhouse'  'doubleoctagon'  'tripleoctagon'  'Mdiamond'
        'Msquare'  'Mcircle'  'star'  'promoter'  'cds'  'terminator'
        'utr'  'insulator'  'ribosite'  'rnastab'  'proteasesite'
        'proteinstab'  'primersite'  'restrictionsite'  'fivepoverhang'
        'threepoverhang'  'noverhang'  'assembly'  'signature'
        'rpromoter'  'larrow'  'rarrow'  'lpromoter'  'polygon'
        'oval'  'point'  'none'  'rect'  'rectangle'
    ==
  =/  pass
    %+  lien  shapes
    |=  shape=@t
    =/  source  (cat 3 'digraph {a [shape=' (cat 3 shape ']}'))
    =/  out  (render:svg (pipe source) %.n)
    ?=(%& -.out)
  (expect !>(pass))
--
