::  svg: SVG codegen (P11)
::
::  Positioned graph -> SVG text following graphviz's -Tsvg
::  structure (<g class="node">/<g class="edge"> groups with
::  <title> children) so downstream CSS/JS tooling keeps working.
::  The y-up -> y-down flip happens here; the -y flag double-flips
::  (emits y-up coordinates unchanged).  The canvas scale factor
::  from size= is applied as a transform.
::
::  Record and HTML shapes are rejected as unsupported (the %|
::  branch carries the message).  Unknown color names pass through
::  untouched; the name table carries X11 values, which differ from
::  SVG for green, purple, gray and friends.  Edges precede nodes in
::  paint order so node fills and strokes remain on top.
::
/-  gg=graph
/+  attr=attr, metrics=metrics
|%
::  +|  Public API
::
::
++  render
  |=  [g=graph:gg flip-y=?]
  ^-  (each @t @t)
  =/  bad  (find-unsupported g)
  ?^  bad  [%| u.bad]
  [%& (crip page:~(. sv g flip-y))]
::
++  find-unsupported
  |=  g=graph:gg
  ^-  (unit @t)
  =/  ns  nodes.g
  |-  ^-  (unit @t)
  ?~  ns  ~
  =/  shp  shape.i.ns
  ?.  (real-shape shp)
    `(cat 3 'unsupported node shape: ' shp)
  $(ns t.ns)
::
++  real-shape
  |=  shp=@t
  ^-  ?
  ?+  shp  %.n
    %ellipse          %.y
    %circle           %.y
    %egg              %.y
    %triangle         %.y
    %box              %.y
    %square           %.y
    %plaintext        %.y
    %plain            %.y
    %diamond          %.y
    %trapezium        %.y
    %parallelogram    %.y
    %house            %.y
    %pentagon         %.y
    %hexagon          %.y
    %septagon         %.y
    %octagon          %.y
    %note             %.y
    %tab              %.y
    %folder           %.y
    %box3d            %.y
    %component        %.y
    %underline        %.y
    %cylinder         %.y
    %doublecircle     %.y
    %invtriangle      %.y
    %invtrapezium     %.y
    %invhouse         %.y
    %doubleoctagon    %.y
    %tripleoctagon    %.y
    %mdiamond         %.y
    %msquare          %.y
    %mcircle          %.y
    %star             %.y
    %promoter         %.y
    %cds              %.y
    %terminator       %.y
    %utr              %.y
    %insulator        %.y
    %ribosite         %.y
    %rnastab          %.y
    %proteasesite     %.y
    %proteinstab      %.y
    %primersite       %.y
    %restrictionsite  %.y
    %fivepoverhang    %.y
    %threepoverhang   %.y
    %noverhang        %.y
    %assembly         %.y
    %signature        %.y
    %rpromoter        %.y
    %larrow           %.y
    %rarrow           %.y
    %lpromoter        %.y
    %polygon          %.y
    %oval             %.y
    %point            %.y
    %none             %.y
    %rect             %.y
    %rectangle        %.y
  ==
::  +|  Number and text formatting
::
::
++  fmt
  ::  fixed two decimals, dot-style
  |=  x=@rs
  ^-  tape
  =/  neg  (lth:rs x .0)
  =/  ax  ?:(neg (sub:rs .0 x) x)
  =/  n  (abs:si (need (toi:rs (add:rs (mul:rs ax .100) .0.5))))
  =/  ip  (nfmt (div n 100))
  =/  fr  (mod n 100)
  ;:  weld
    ?:(neg "-" "")
    ip
    "."
    [(add '0' (div fr 10)) (add '0' (mod fr 10)) ~]
  ==
::
++  nfmt
  |=  n=@ud
  ^-  tape
  ?:  =(0 n)  "0"
  =|  out=tape
  |-  ^-  tape
  ?:  =(0 n)  out
  $(n (div n 10), out [(add '0' (mod n 10)) out])
::
++  esc
  ::  xml escaping
  |=  tp=tape
  ^-  tape
  %-  zing
  %+  turn  tp
  |=  c=@tD
  ^-  tape
  ?:  =('&' c)  "&amp;"
  ?:  =('<' c)  "&lt;"
  ?:  =('>' c)  "&gt;"
  ?:  =('"' c)  "&quot;"
  [c ~]
::
++  rd-rs  |=(d=@rd ^-(@rs (bit:rs (sea:rd d))))
::
++  font-family
  |=  f=@t
  ^-  tape
  ?:  =('Times-Roman' f)  "Times,serif"
  ?:  =('Helvetica' f)  "Helvetica,sans-Serif"
  ?:  =('Courier' f)  "Courier,monospace"
  (trip f)
::  +|  Colors
::
::
++  color-of
  ::  name / #hex / H S V triple -> svg color string
  |=  t=@t
  ^-  tape
  =/  tp  (trip t)
  ?~  tp  "black"
  ?:  =('#' i.tp)  tp
  =/  hit  (~(get by x11) (crip (cass tp)))
  ?^  hit  (trip u.hit)
  ::  h,s,v floats?
  =/  parts  (split-hsv tp)
  ?.  ?=([* * * ~] parts)  tp
  =/  h  (to-rs-t i.parts)
  =/  s  (to-rs-t i.t.parts)
  =/  v  (to-rs-t i.t.t.parts)
  ?:  |(?=(~ h) ?=(~ s) ?=(~ v))  tp
  (hsv-hex u.h u.s u.v)
::
++  to-rs-t
  |=  tp=tape
  ^-  (unit @rs)
  (bind (to-rd:attr (crip tp)) rd-rs)
::
++  split-hsv
  ::  split on spaces and commas
  |=  tp=tape
  ^-  (list tape)
  =|  cur=tape
  =|  out=(list tape)
  |-  ^-  (list tape)
  ?~  tp
    ?~(cur (flop out) (flop [(flop cur) out]))
  ?:  |(=(' ' i.tp) =(',' i.tp))
    ?~  cur  $(tp t.tp)
    $(tp t.tp, out [(flop cur) out], cur ~)
  $(tp t.tp, cur [i.tp cur])
::
++  bio-label-offset
  ::  Move labels below the centerline of baseline-style bio symbols
  |=  shp=@t
  ^-  @rs
  ?:  ?|  =('promoter' shp)
          =('terminator' shp)
          =('utr' shp)
          =('insulator' shp)
          =('ribosite' shp)
          =('rnastab' shp)
          =('proteasesite' shp)
          =('proteinstab' shp)
          =('primersite' shp)
          =('restrictionsite' shp)
          =('fivepoverhang' shp)
          =('threepoverhang' shp)
          =('noverhang' shp)
          =('assembly' shp)
      ==
    .7
  .0
::
++  hsv-hex
  |=  [h=@rs s=@rs v=@rs]
  ^-  tape
  =/  h6  (mul:rs h .6)
  =/  i
    ?:  (lth:rs h6 .1)  0
    ?:  (lth:rs h6 .2)  1
    ?:  (lth:rs h6 .3)  2
    ?:  (lth:rs h6 .4)  3
    ?:  (lth:rs h6 .5)  4
    5
  =/  f  (sub:rs h6 (sun:rs i))
  =/  p  (mul:rs v (sub:rs .1 s))
  =/  q  (mul:rs v (sub:rs .1 (mul:rs f s)))
  =/  w  (mul:rs v (sub:rs .1 (mul:rs (sub:rs .1 f) s)))
  =/  rgb=[r=@rs g=@rs b=@rs]
    ?+  i  [v w p]
      %1  [q v p]
      %2  [p v w]
      %3  [p q v]
      %4  [w p v]
      %5  [v p q]
    ==
  ;:  weld
    "#"
    (hex2 r.rgb)
    (hex2 g.rgb)
    (hex2 b.rgb)
  ==
::
++  hex2
  |=  c=@rs
  ^-  tape
  =/  n  (abs:si (need (toi:rs (add:rs (mul:rs c .255) .0.5))))
  =/  n  ?:((gth n 255) 255 n)
  =/  dig  "0123456789abcdef"
  ~[(snag (div n 16) dig) (snag (mod n 16) dig)]
::
++  x11
  ::  X11 color values (differ from SVG for green, purple, gray...)
  ^-  (map @t @t)
  %-  malt
  ^-  (list [@t @t])
  :~  ['black' '#000000']  ['white' '#ffffff']  ['red' '#ff0000']
      ['green' '#00ff00']  ['blue' '#0000ff']  ['yellow' '#ffff00']
      ['cyan' '#00ffff']  ['magenta' '#ff00ff']  ['gray' '#bebebe']
      ['grey' '#bebebe']  ['purple' '#a020f0']  ['maroon' '#b03060']
      ['orange' '#ffa500']  ['pink' '#ffc0cb']  ['brown' '#a52a2a']
      ['gold' '#ffd700']  ['silver' '#c0c0c0']  ['beige' '#f5f5dc']
      ['ivory' '#fffff0']  ['khaki' '#f0e68c']  ['lavender' '#e6e6fa']
      ['lime' '#00ff00']  ['olive' '#808000']  ['teal' '#008080']
      ['aqua' '#00ffff']  ['fuchsia' '#ff00ff']  ['crimson' '#dc143c']
      ['coral' '#ff7f50']  ['tomato' '#ff6347']  ['salmon' '#fa8072']
      ['orangered' '#ff4500']  ['hotpink' '#ff69b4']
      ['deeppink' '#ff1493']  ['skyblue' '#87ceeb']
      ['steelblue' '#4682b4']  ['navy' '#000080']
      ['royalblue' '#4169e1']  ['dodgerblue' '#1e90ff']
      ['deepskyblue' '#00bfff']  ['cornflowerblue' '#6495ed']
      ['slateblue' '#6a5acd']  ['mediumblue' '#0000cd']
      ['midnightblue' '#191970']  ['indigo' '#4b0082']
      ['darkblue' '#00008b']  ['darkgreen' '#006400']
      ['darkred' '#8b0000']  ['darkorange' '#ff8c00']
      ['darkgray' '#a9a9a9']  ['darkgrey' '#a9a9a9']
      ['dimgray' '#696969']  ['dimgrey' '#696969']
      ['lightgray' '#d3d3d3']  ['lightgrey' '#d3d3d3']
      ['lightblue' '#add8e6']  ['lightblue1' '#bfefff']
      ['lightblue2' '#b2dfee']  ['lightyellow' '#ffffe0']
      ['lightgreen' '#90ee90']  ['lightcyan' '#e0ffff']
      ['lightpink' '#ffb6c1']  ['lightsalmon' '#ffa07a']
      ['lightcoral' '#f08080']  ['lightskyblue' '#87cefa']
      ['forestgreen' '#228b22']  ['seagreen' '#2e8b57']
      ['springgreen' '#00ff7f']  ['limegreen' '#32cd32']
      ['mediumseagreen' '#3cb371']  ['palegreen' '#98fb98']
      ['greenyellow' '#adff2f']  ['yellowgreen' '#9acd32']
      ['chartreuse' '#7fff00']  ['lawngreen' '#7cfc00']
      ['turquoise' '#40e0d0']  ['violet' '#ee82ee']
      ['plum' '#dda0dd']  ['orchid' '#da70d6']
      ['thistle' '#d8bfd8']  ['sienna' '#a0522d']
      ['peru' '#cd853f']  ['chocolate' '#d2691e']
      ['firebrick' '#b22222']  ['indianred' '#cd5c5c']
      ['rosybrown' '#bc8f8f']  ['sandybrown' '#f4a460']
      ['tan' '#d2b48c']  ['goldenrod' '#daa520']
      ['wheat' '#f5deb3']  ['whitesmoke' '#f5f5f5']
      ['gainsboro' '#dcdcdc']  ['powderblue' '#b0e0e6']
      ['cadetblue' '#5f9ea0']  ['blueviolet' '#8a2be2']
      ['burlywood' '#deb887']  ['aliceblue' '#f0f8ff']
      ['azure' '#f0ffff']  ['mintcream' '#f5fffa']
      ['honeydew' '#f0fff0']  ['snow' '#fffafa']
      ['seashell' '#fff5ee']  ['linen' '#faf0e6']
      ['cornsilk' '#fff8dc']  ['bisque' '#ffe4c4']
      ['peachpuff' '#ffdab9']  ['navajowhite' '#ffdead']
      ['antiquewhite' '#faebd7']  ['transparent' 'none']
  ==
::  +|  Renderer
::
::
++  sv
  |_  [g=graph:gg flip-y=?]
  ::
  ++  yy  |=(y=@rs ?:(flip-y y (sub:rs y.size.canvas.g y)))
  ::
  ++  pt  |=(p=fpair:gg ^-(tape "{(fmt x.p)},{(fmt (yy y.p))}"))
  ::
  ++  page
    ^-  tape
    =/  s  scale.canvas.g
    =/  ow  (add:rs (mul:rs x.size.canvas.g s) .8)
    =/  oh  (add:rs (mul:rs y.size.canvas.g s) .8)
    ;:  weld
      "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\0a"
      "<svg width=\"{(fmt ow)}pt\" height=\"{(fmt oh)}pt\" "
      "viewBox=\"0.00 0.00 {(fmt ow)} {(fmt oh)}\" "
      "xmlns=\"http://www.w3.org/2000/svg\" "
      "xmlns:xlink=\"http://www.w3.org/1999/xlink\">\0a"
      "<g id=\"graph0\" class=\"graph\" "
      "transform=\"translate(4 4) scale({(fmt s)})\">\0a"
      "<title>{(esc (trip name.g))}</title>\0a"
      all-clusters
      all-edges
      all-nodes
      "</g>\0a</svg>\0a"
    ==
  ::
  ++  all-clusters
    ^-  tape
    =/  ix  1
    =/  cs  clusters.g
    =|  acc=(list tape)
    |-  ^-  tape
    ?~  cs  (zing (flop acc))
    $(cs t.cs, ix +(ix), acc [(en-cluster ix i.cs) acc])
  ::
  ++  all-nodes
    ^-  tape
    =/  ix  1
    =/  ns  nodes.g
    =|  acc=(list tape)
    |-  ^-  tape
    ?~  ns  (zing (flop acc))
    $(ns t.ns, ix +(ix), acc [(en-node ix i.ns) acc])
  ::
  ++  all-edges
    ^-  tape
    =/  ix  1
    =/  es  edges.g
    =|  acc=(list tape)
    |-  ^-  tape
    ?~  es  (zing (flop acc))
    $(es t.es, ix +(ix), acc [(en-edge ix i.es) acc])
  ::
  ++  en-cluster
    |=  [ix=@ud cl=gcluster:gg]
    ^-  tape
    =/  gvd  ~(. gv:attr attrs.cl)
    =/  styles  style:gvd
    =/  filled
      ?|  (lien styles |=(s=@t =('filled' s)))
          (~(has by attrs.cl) 'bgcolor')
      ==
    =/  fill
      ?.  filled  "none"
      =/  bg  bgcolor:gvd
      ?^(bg (color-of u.bg) (color-of fillcolor:gvd))
    =/  strk  (color-of color:gvd)
    =/  p1  ll.bbox.cl
    =/  p2  `fpair:gg`[x.ur.bbox.cl y.ll.bbox.cl]
    =/  p3  ur.bbox.cl
    =/  p4  `fpair:gg`[x.ll.bbox.cl y.ur.bbox.cl]
    =/  lbl=tape
      =/  lb  label.cl
      ?~  lb  ""
      (text-lines at.u.lb .0 text.u.lb attrs.cl)
    ;:  weld
      "<g id=\"clust{(nfmt ix)}\" class=\"cluster\">\0a"
      "<title>{(esc (trip name.cl))}</title>\0a"
      "<polygon fill=\"{fill}\" stroke=\"{strk}\" "
      "points=\"{(pt p1)} {(pt p2)} {(pt p3)} {(pt p4)}\"/>\0a"
      lbl
      "</g>\0a"
    ==
  ::
  ++  en-node
    |=  [ix=@ud n=gnode:gg]
    ^-  tape
    =/  gvd  ~(. gv:attr attrs.n)
    =/  styles  style:gvd
    =/  invis  (lien styles |=(s=@t =('invis' s)))
    =/  body-part=tape
      ?:  invis  ""
      =/  lbl=tape
        ?:  =('' label.n)  ""
        =/  at  label-at.n
        =/  off  (bio-label-offset shape.n)
        =/  at  [x.at (sub:rs y.at off)]
        (text-lines at x.half.n label.n attrs.n)
      (weld (shape-el n styles) lbl)
    ;:  weld
      "<g id=\"node{(nfmt ix)}\" class=\"node\">\0a"
      "<title>{(esc (trip name.n))}</title>\0a"
      body-part
      "</g>\0a"
    ==
  ::
  ++  stroke-bits
    ::  stroke color, width, dasharray from style + penwidth
    |=  [ats=attrs:attr styles=(list @t)]
    ^-  tape
    =/  gvd  ~(. gv:attr ats)
    =/  strk  (color-of color:gvd)
    =/  bold  (lien styles |=(s=@t =('bold' s)))
    =/  dashed  (lien styles |=(s=@t =('dashed' s)))
    =/  dotted  (lien styles |=(s=@t =('dotted' s)))
    =/  pw  (rd-rs penwidth:gvd)
    =/  pw  ?:(&(bold (lte:rs pw .1)) .2 pw)
    ;:  weld
      "stroke=\"{strk}\""
      ?:  =((fmt pw) "1.00")  ""
      " stroke-width=\"{(fmt pw)}\""
      ?:  dashed  " stroke-dasharray=\"5,2\""
      ?:  dotted  " stroke-dasharray=\"1,5\""
      ""
    ==
  ::
  ++  shape-points
    |=  [units=(list [ux=@rs uy=@rs]) cx=@rs cy=@rs rx=@rs ry=@rs]
    ^-  (list tape)
    %+  turn  units
    |=  [ux=@rs uy=@rs]
    ^-  tape
    %-  pt
    :-  (add:rs cx (mul:rs ux rx))
    (add:rs cy (mul:rs uy ry))
  ::
  ++  polygon-el
    |=  [units=(list [ux=@rs uy=@rs]) cx=@rs cy=@rs rx=@rs ry=@rs fill=tape sb=tape]
    ^-  tape
    ;:  weld
      "<polygon fill=\"{fill}\" {sb} points=\""
      (join-sp (shape-points units cx cy rx ry))
      "\"/>\0a"
    ==
  ::
  ++  polyline-el
    |=  [units=(list [ux=@rs uy=@rs]) cx=@rs cy=@rs rx=@rs ry=@rs sb=tape]
    ^-  tape
    ;:  weld
      "<polyline fill=\"none\" {sb} points=\""
      (join-sp (shape-points units cx cy rx ry))
      "\"/>\0a"
    ==
  ::
  ++  shape-el
    |=  [n=gnode:gg styles=(list @t)]
    ^-  tape
    =/  gvd  ~(. gv:attr attrs.n)
    =/  shp  shape.n
    =/  filled  (lien styles |=(s=@t =('filled' s)))
    =/  fill  ?:(filled (color-of fillcolor:gvd) "none")
    =/  sb  (stroke-bits attrs.n styles)
    =/  cx  x.center.n
    =/  cy  y.center.n
    =/  rx  x.half.n
    =/  ry  y.half.n
    =/  oct-units=(list [ux=@rs uy=@rs])
      :~  [.0.92 .0.38]  [.0.38 .0.92]  [.-0.38 .0.92]
          [.-0.92 .0.38]  [.-0.92 .-0.38]  [.-0.38 .-0.92]
          [.0.38 .-0.92]  [.0.92 .-0.38]
      ==
    ?:  ?|(=('plaintext' shp) =('plain' shp) =('none' shp))  ""
    ?:  =('underline' shp)
      ;:  weld
        "<path fill=\"none\" {sb} d=\"M{(fmt (sub:rs cx rx))},"
        "{(fmt (yy (sub:rs cy ry)))}L{(fmt (add:rs cx rx))},"
        "{(fmt (yy (sub:rs cy ry)))}\"/>\0a"
      ==
    ?:  =('doublecircle' shp)
      ;:  weld
        "<ellipse fill=\"{fill}\" {sb} cx=\"{(fmt cx)}\" "
        "cy=\"{(fmt (yy cy))}\" rx=\"{(fmt rx)}\" ry=\"{(fmt ry)}\"/>\0a"
        "<ellipse fill=\"none\" {sb} cx=\"{(fmt cx)}\" "
        "cy=\"{(fmt (yy cy))}\" rx=\"{(fmt (sub:rs rx .4))}\" "
        "ry=\"{(fmt (sub:rs ry .4))}\"/>\0a"
      ==
    ?:  =('mcircle' shp)
      ;:  weld
        "<ellipse fill=\"{fill}\" {sb} cx=\"{(fmt cx)}\" "
        "cy=\"{(fmt (yy cy))}\" rx=\"{(fmt rx)}\" ry=\"{(fmt ry)}\"/>\0a"
        (polyline-el ~[[.-0.72 .0.7] [.0.72 .0.7]] cx cy rx ry sb)
        (polyline-el ~[[.-0.72 .-0.7] [.0.72 .-0.7]] cx cy rx ry sb)
      ==
    ?:  =('egg' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.0 .1]  [.0.55 .0.92]  [.0.85 .0.7]  [.0.98 .0.38]
            [.1 .0]  [.0.94 .-0.4]  [.0.68 .-0.78]  [.0 .-1]
            [.-0.68 .-0.78]  [.-0.94 .-0.4]  [.-1 .0]
            [.-0.98 .0.38]  [.-0.85 .0.7]  [.-0.55 .0.92]
        ==
      (polygon-el units cx cy rx ry fill sb)
    ?:  ?|(=('ellipse' shp) =('circle' shp) =('oval' shp))
      ;:  weld
        "<ellipse fill=\"{fill}\" {sb} cx=\"{(fmt cx)}\" "
        "cy=\"{(fmt (yy cy))}\" rx=\"{(fmt rx)}\" ry=\"{(fmt ry)}\"/>\0a"
      ==
    ?:  =('point' shp)
      =/  c  (color-of color:gvd)
      ;:  weld
        "<ellipse fill=\"{c}\" {sb} cx=\"{(fmt cx)}\" "
        "cy=\"{(fmt (yy cy))}\" rx=\"1.80\" ry=\"1.80\"/>\0a"
      ==
    ?:  =('note' shp)
      ;:  weld
        %:  polygon-el
          ~[[.-1 .1] [.0.72 .1] [.1 .0.72] [.1 .-1] [.-1 .-1]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        %:  polyline-el
          ~[[.0.72 .1] [.0.72 .0.72] [.1 .0.72]]
          cx
          cy
          rx
          ry
          sb
        ==
      ==
    ?:  =('tab' shp)
      ;:  weld
        %:  polygon-el
          ~[[.-1 .0.82] [.-0.66 .0.82] [.-0.66 .1] [.1 .1] [.1 .-1] [.-1 .-1]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        (polyline-el ~[[.-1 .0.82] [.-0.66 .0.82]] cx cy rx ry sb)
      ==
    ?:  =('folder' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-1 .0.82]  [.-0.92 .1]  [.-0.34 .1]  [.-0.25 .0.82]
            [.1 .0.82]  [.1 .-1]  [.-1 .-1]
        ==
      (polygon-el units cx cy rx ry fill sb)
    ?:  =('box3d' shp)
      ;:  weld
        %:  polygon-el
          ~[[.-1 .0.82] [.-0.88 .1] [.1 .1] [.1 .-0.82] [.0.88 .-1] [.-1 .-1]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        %:  polyline-el
          ~[[.-1 .0.82] [.0.88 .0.82] [.1 .1]]
          cx
          cy
          rx
          ry
          sb
        ==
        (polyline-el ~[[.0.88 .0.82] [.0.88 .-1]] cx cy rx ry sb)
      ==
    ?:  =('component' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.86 .1]  [.1 .1]  [.1 .-1]  [.-0.86 .-1]
            [.-0.86 .-0.82]  [.-1 .-0.82]  [.-1 .-0.66]
            [.-0.86 .-0.66]  [.-0.86 .0.66]  [.-1 .0.66]
            [.-1 .0.82]  [.-0.86 .0.82]
        ==
      ;:  weld
        (polygon-el units cx cy rx ry fill sb)
        %:  polyline-el
          ~[[.-0.86 .0.82] [.-0.72 .0.82] [.-0.72 .0.66] [.-0.86 .0.66]]
          cx
          cy
          rx
          ry
          sb
        ==
        %:  polyline-el
          ~[[.-0.86 .-0.66] [.-0.72 .-0.66] [.-0.72 .-0.82] [.-0.86 .-0.82]]
          cx
          cy
          rx
          ry
          sb
        ==
      ==
    ?:  =('cylinder' shp)
      =/  top  (add:rs cy ry)
      =/  bot  (sub:rs cy ry)
      =/  cap  (mul:rs ry .0.18)
      ;:  weld
        "<path fill=\"{fill}\" {sb} d=\"M{(fmt (sub:rs cx rx))},"
        "{(fmt (yy (sub:rs top cap)))}C{(fmt (sub:rs cx rx))},"
        "{(fmt (yy top))} {(fmt (add:rs cx rx))},{(fmt (yy top))} "
        "{(fmt (add:rs cx rx))},{(fmt (yy (sub:rs top cap)))}L"
        "{(fmt (add:rs cx rx))},{(fmt (yy (add:rs bot cap)))}C"
        "{(fmt (add:rs cx rx))},{(fmt (yy bot))} "
        "{(fmt (sub:rs cx rx))},{(fmt (yy bot))} "
        "{(fmt (sub:rs cx rx))},{(fmt (yy (add:rs bot cap)))}Z\"/>\0a"
        "<path fill=\"none\" {sb} d=\"M{(fmt (sub:rs cx rx))},"
        "{(fmt (yy (sub:rs top cap)))}C{(fmt (sub:rs cx rx))},"
        "{(fmt (yy (sub:rs top (mul:rs cap .2))))} "
        "{(fmt (add:rs cx rx))},{(fmt (yy (sub:rs top (mul:rs cap .2))))} "
        "{(fmt (add:rs cx rx))},{(fmt (yy (sub:rs top cap)))}\"/>\0a"
      ==
    ?:  =('msquare' shp)
      ;:  weld
        (polygon-el ~[[.-1 .1] [.1 .1] [.1 .-1] [.-1 .-1]] cx cy rx ry fill sb)
        (polyline-el ~[[.-1 .0.72] [.-0.72 .1]] cx cy rx ry sb)
        (polyline-el ~[[.0.72 .1] [.1 .0.72]] cx cy rx ry sb)
        (polyline-el ~[[.1 .-0.72] [.0.72 .-1]] cx cy rx ry sb)
        (polyline-el ~[[.-0.72 .-1] [.-1 .-0.72]] cx cy rx ry sb)
      ==
    ?:  =('mdiamond' shp)
      ;:  weld
        (polygon-el ~[[.0 .1] [.1 .0] [.0 .-1] [.-1 .0]] cx cy rx ry fill sb)
        (polyline-el ~[[.-0.72 .0.28] [.-0.28 .0.72]] cx cy rx ry sb)
        (polyline-el ~[[.0.28 .0.72] [.0.72 .0.28]] cx cy rx ry sb)
        (polyline-el ~[[.0.72 .-0.28] [.0.28 .-0.72]] cx cy rx ry sb)
        (polyline-el ~[[.-0.28 .-0.72] [.-0.72 .-0.28]] cx cy rx ry sb)
      ==
    ?:  =('doubleoctagon' shp)
      ;:  weld
        (polygon-el oct-units cx cy rx ry fill sb)
        (polygon-el oct-units cx cy (sub:rs rx .4) (sub:rs ry .4) "none" sb)
      ==
    ?:  =('tripleoctagon' shp)
      ;:  weld
        (polygon-el oct-units cx cy rx ry fill sb)
        (polygon-el oct-units cx cy (sub:rs rx .4) (sub:rs ry .4) "none" sb)
        (polygon-el oct-units cx cy (sub:rs rx .8) (sub:rs ry .8) "none" sb)
      ==
    ?:  =('promoter' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.5 .0]  [.-0.5 .0.48]  [.0.25 .0.48]
            [.0.25 .0.62]  [.0.58 .0.36]  [.0.25 .0.1]
            [.0.25 .0.24]  [.-0.3 .0.24]  [.-0.3 .0]
        ==
      ;:  weld
        (polygon-el units cx cy rx ry fill sb)
        (polyline-el ~[[.-1 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('cds' shp)
      =/  units=(list [ux=@rs uy=@rs])
        ~[[.-1 .0.76] [.0.66 .0.76] [.1 .0] [.0.66 .-0.76] [.-1 .-0.76]]
      (polygon-el units cx cy rx ry fill sb)
    ?:  =('terminator' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.08 .0]  [.-0.08 .0.24]  [.-0.25 .0.24]
            [.-0.25 .0.48]  [.0.25 .0.48]  [.0.25 .0.24]
            [.0.08 .0.24]  [.0.08 .0]
        ==
      ;:  weld
        (polygon-el units cx cy rx ry fill sb)
        (polyline-el ~[[.-1 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('utr' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.25 .0]  [.-0.25 .0.12]  [.-0.08 .0.36]
            [.0.08 .0.36]  [.0.25 .0.12]  [.0.25 .0]
        ==
      ;:  weld
        (polygon-el units cx cy rx ry fill sb)
        (polyline-el ~[[.-1 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('primersite' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.5 .0.12]  [.0.16 .0.12]  [.0.16 .0.36]
            [.0.5 .0.12]  [.0.16 .-0.12]  [.0.16 .0]
            [.-0.5 .0]
        ==
      ;:  weld
        (polygon-el units cx cy rx ry fill sb)
        (polyline-el ~[[.-1 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('restrictionsite' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.32 .0.12]  [.0.34 .0.12]  [.0.34 .0.36]
            [.0.5 .0.36]  [.0.5 .-0.12]  [.-0.16 .-0.12]
            [.-0.16 .-0.36]  [.-0.32 .-0.36]
        ==
      ;:  weld
        (polygon-el units cx cy rx ry fill sb)
        (polyline-el ~[[.-1 .0] [.-0.32 .0]] cx cy rx ry sb)
        (polyline-el ~[[.0.5 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('fivepoverhang' shp)
      ;:  weld
        (polygon-el ~[[.-1 .0.06] [.-0.34 .0.06] [.-0.34 .0.3] [.-1 .0.3]] cx cy rx ry fill sb)
        %:  polygon-el
          ~[[.-0.66 .-0.3] [.-0.34 .-0.3] [.-0.34 .-0.06] [.-0.66 .-0.06]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        (polyline-el ~[[.-0.34 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('threepoverhang' shp)
      ;:  weld
        (polygon-el ~[[.0.34 .0.06] [.1 .0.06] [.1 .0.3] [.0.34 .0.3]] cx cy rx ry fill sb)
        %:  polygon-el
          ~[[.0.34 .-0.3] [.0.66 .-0.3] [.0.66 .-0.06] [.0.34 .-0.06]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        (polyline-el ~[[.-1 .0] [.0.34 .0]] cx cy rx ry sb)
      ==
    ?:  =('noverhang' shp)
      ;:  weld
        %:  polygon-el
          ~[[.-0.36 .0.06] [.-0.02 .0.06] [.-0.02 .0.3] [.-0.36 .0.3]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        %:  polygon-el
          ~[[.-0.36 .-0.3] [.-0.02 .-0.3] [.-0.02 .-0.06] [.-0.36 .-0.06]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        (polygon-el ~[[.0.06 .0.06] [.0.4 .0.06] [.0.4 .0.3] [.0.06 .0.3]] cx cy rx ry fill sb)
        (polygon-el ~[[.0.06 .-0.3] [.0.4 .-0.3] [.0.4 .-0.06] [.0.06 .-0.06]] cx cy rx ry fill sb)
        (polyline-el ~[[.-1 .0] [.-0.36 .0]] cx cy rx ry sb)
        (polyline-el ~[[.0.4 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('assembly' shp)
      ;:  weld
        (polygon-el ~[[.-0.34 .0.06] [.0.34 .0.06] [.0.34 .0.3] [.-0.34 .0.3]] cx cy rx ry fill sb)
        %:  polygon-el
          ~[[.-0.34 .-0.3] [.0.34 .-0.3] [.0.34 .-0.06] [.-0.34 .-0.06]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        (polyline-el ~[[.-1 .0] [.-0.34 .0]] cx cy rx ry sb)
        (polyline-el ~[[.0.34 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('signature' shp)
      ;:  weld
        (polygon-el ~[[.-1 .0.76] [.1 .0.76] [.1 .-0.76] [.-1 .-0.76]] cx cy rx ry fill sb)
        (polyline-el ~[[.-0.92 .0.06] [.-0.82 .-0.06]] cx cy rx ry sb)
        (polyline-el ~[[.-0.92 .-0.06] [.-0.82 .0.06]] cx cy rx ry sb)
        (polyline-el ~[[.-0.82 .-0.64] [.0.92 .-0.64]] cx cy rx ry sb)
      ==
    ?:  =('insulator' shp)
      ;:  weld
        %:  polygon-el
          ~[[.-0.16 .0.24] [.0.16 .0.24] [.0.16 .-0.24] [.-0.16 .-0.24]]
          cx
          cy
          rx
          ry
          fill
          sb
        ==
        %:  polyline-el
          ~[[.-0.25 .0.36] [.0.25 .0.36] [.0.25 .-0.36] [.-0.25 .-0.36] [.-0.25 .0.36]]
          cx
          cy
          rx
          ry
          sb
        ==
        (polyline-el ~[[.-1 .0] [.-0.25 .0]] cx cy rx ry sb)
        (polyline-el ~[[.0.25 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('ribosite' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.08 .0.24]  [.0 .0.16]  [.0.08 .0.24]
            [.0.08 .0.12]  [.0.16 .0.04]  [.0.08 .-0.04]
            [.0.08 .-0.16]  [.0 .-0.08]  [.-0.08 .-0.16]
            [.-0.08 .-0.04]  [.-0.16 .0.04]  [.-0.08 .0.12]
        ==
      ;:  weld
        (polygon-el units cx (add:rs cy (mul:rs ry .0.34)) rx ry fill sb)
        (polyline-el ~[[.0 .0] [.0 .0.18]] cx cy rx ry sb)
        (polyline-el ~[[.-1 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  ?|(=('rnastab' shp) =('proteinstab' shp))
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.06 .0.24]  [.0.06 .0.24]  [.0.12 .0.16]
            [.0.12 .0.04]  [.0.06 .-0.04]  [.-0.06 .-0.04]
            [.-0.12 .0.04]  [.-0.12 .0.16]
        ==
      ;:  weld
        (polygon-el units cx (add:rs cy (mul:rs ry .0.28)) rx ry fill sb)
        (polyline-el ~[[.0 .0] [.0 .0.16]] cx cy rx ry sb)
        (polyline-el ~[[.-1 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('proteasesite' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-0.08 .0.24]  [.0 .0.16]  [.0.08 .0.24]
            [.0.08 .0.12]  [.0.16 .0.04]  [.0.08 .-0.04]
            [.0.08 .-0.16]  [.0 .-0.08]  [.-0.08 .-0.16]
            [.-0.08 .-0.04]  [.-0.16 .0.04]  [.-0.08 .0.12]
        ==
      ;:  weld
        (polygon-el units cx (add:rs cy (mul:rs ry .0.34)) rx ry fill sb)
        (polyline-el ~[[.0 .0] [.0 .0.28]] cx cy rx ry sb)
        (polyline-el ~[[.-1 .0] [.1 .0]] cx cy rx ry sb)
      ==
    ?:  =('rpromoter' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-1 .0.76]  [.0.5 .0.76]  [.0.5 .1]  [.1 .0]
            [.0.5 .-1]  [.0.5 .-0.76]  [.0 .-0.76]  [.0 .-1]
            [.-0.5 .-1]  [.-0.5 .-0.76]  [.-1 .-0.76]
        ==
      (polygon-el units cx cy rx ry fill sb)
    ?:  =('lpromoter' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.1 .0.76]  [.-0.5 .0.76]  [.-0.5 .1]  [.-1 .0]
            [.-0.5 .-1]  [.-0.5 .-0.76]  [.0 .-0.76]  [.0 .-1]
            [.0.5 .-1]  [.0.5 .-0.76]  [.1 .-0.76]
        ==
      (polygon-el units cx cy rx ry fill sb)
    ?:  =('rarrow' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.-1 .0.76]  [.0.5 .0.76]  [.0.5 .1]  [.1 .0]
            [.0.5 .-1]  [.0.5 .-0.76]  [.-1 .-0.76]
        ==
      (polygon-el units cx cy rx ry fill sb)
    ?:  =('larrow' shp)
      =/  units=(list [ux=@rs uy=@rs])
        :~  [.1 .0.76]  [.-0.5 .0.76]  [.-0.5 .1]  [.-1 .0]
            [.-0.5 .-1]  [.-0.5 .-0.76]  [.1 .-0.76]
        ==
      (polygon-el units cx cy rx ry fill sb)
    =/  units=(list [ux=@rs uy=@rs])
      ?:  =('diamond' shp)
        ~[[.0 .1] [.1 .0] [.0 .-1] [.-1 .0]]
      ?:  =('triangle' shp)
        ~[[.0 .1] [.1 .-1] [.-1 .-1]]
      ?:  =('invtriangle' shp)
        ~[[.-1 .1] [.1 .1] [.0 .-1]]
      ?:  =('trapezium' shp)
        ~[[.-0.7 .1] [.0.7 .1] [.1 .-1] [.-1 .-1]]
      ?:  =('invtrapezium' shp)
        ~[[.-1 .1] [.1 .1] [.0.7 .-1] [.-0.7 .-1]]
      ?:  =('parallelogram' shp)
        ~[[.-0.7 .1] [.1 .1] [.0.7 .-1] [.-1 .-1]]
      ?:  =('house' shp)
        ~[[.-1 .-1] [.1 .-1] [.1 .0.25] [.0 .1] [.-1 .0.25]]
      ?:  =('invhouse' shp)
        ~[[.-1 .0.25] [.0 .-1] [.1 .0.25] [.1 .1] [.-1 .1]]
      ?:  =('pentagon' shp)
        :~  [.0 .1]  [.0.951 .0.309]  [.0.588 .-0.809]
            [.-0.588 .-0.809]  [.-0.951 .0.309]
        ==
      ?:  =('hexagon' shp)
        :~  [.1 .0]  [.0.5 .1]  [.-0.5 .1]
            [.-1 .0]  [.-0.5 .-1]  [.0.5 .-1]
        ==
      ?:  =('septagon' shp)
        :~  [.0 .1]  [.0.782 .0.623]  [.0.975 .-0.223]
            [.0.434 .-0.901]  [.-0.434 .-0.901]
            [.-0.975 .-0.223]  [.-0.782 .0.623]
        ==
      ?:  =('octagon' shp)
        :~  [.0.924 .0.383]  [.0.383 .0.924]  [.-0.383 .0.924]
            [.-0.924 .0.383]  [.-0.924 .-0.383]  [.-0.383 .-0.924]
            [.0.383 .-0.924]  [.0.924 .-0.383]
        ==
      ?:  =('star' shp)
        :~  [.0 .1]  [.0.235 .0.324]  [.0.951 .0.309]
            [.0.38 .-0.124]  [.0.588 .-0.809]  [.0 .-0.4]
            [.-0.588 .-0.809]  [.-0.38 .-0.124]
            [.-0.951 .0.309]  [.-0.235 .0.324]
        ==
      ::  box, square, rect, rectangle and default polygon
      ~[[.-1 .1] [.1 .1] [.1 .-1] [.-1 .-1]]
    (polygon-el units cx cy rx ry fill sb)
  ::
  ++  en-edge
    |=  [ix=@ud e=gedge:gg]
    ^-  tape
    =/  gvd  ~(. gv:attr attrs.e)
    =/  styles  style:gvd
    =/  invis  (lien styles |=(s=@t =('invis' s)))
    =/  tname  (trip name:(snag tail.e nodes.g))
    =/  hname  (trip name:(snag head.e nodes.g))
    =/  op  ?:(directed.g "->" "--")
    =/  path-part=tape
      ?:  invis  ""
      =/  sb  (stroke-bits attrs.e styles)
      ;:  weld
        "<path fill=\"none\" {sb} d=\""
        (path-d spline.e)
        "\"/>\0a"
      ==
    =/  arrow-part=tape
      ?:  invis  ""
      =/  ac  (color-of color:gvd)
      %-  zing
      %+  turn  arrows.e
      |=  poly=(list fpair:gg)
      ^-  tape
      ;:  weld
        "<polygon fill=\"{ac}\" stroke=\"{ac}\" points=\""
        (join-sp (turn poly pt))
        "\"/>\0a"
      ==
    =/  label-part=tape
      ?:  invis  ""
      =/  lb  label.e
      ?~  lb  ""
      %:  text-lines
        at.u.lb
        .0
        (crip (subst-edge (trip text.u.lb) tname hname op))
        attrs.e
      ==
    ;:  weld
      "<g id=\"edge{(nfmt ix)}\" class=\"edge\">\0a"
      "<title>{(esc tname)}{(esc op)}{(esc hname)}</title>\0a"
      path-part
      arrow-part
      label-part
      "</g>\0a"
    ==
  ::
  ++  path-d
    |=  sp=(list fpair:gg)
    ^-  tape
    ?~  sp  ""
    ;:  weld
      "M"
      (pt i.sp)
      "C"
      (join-sp (turn `(list fpair:gg)`t.sp pt))
    ==
  ::
  ++  subst-edge
    ::  \T \H \E substitutions for edge labels
    |=  [tp=tape tname=tape hname=tape op=tape]
    ^-  tape
    |-  ^-  tape
    ?~  tp  ~
    ?.  =('\\' i.tp)  [i.tp $(tp t.tp)]
    ?~  t.tp  [i.tp ~]
    ?:  =('T' i.t.tp)  (weld tname $(tp t.t.tp))
    ?:  =('H' i.t.tp)  (weld hname $(tp t.t.tp))
    ?:  =('E' i.t.tp)
      (weld (zing ~[tname op hname]) $(tp t.t.tp))
    [i.tp i.t.tp $(tp t.t.tp)]
  ::
  ++  text-lines
    ::  multi-line label text with \n \l \r alignment
    |=  [at=fpair:gg halfw=@rs txt=@t ats=attrs:attr]
    ^-  tape
    =/  gvd  ~(. gv:attr ats)
    =/  fs  (rd-rs fontsize:gvd)
    =/  fam  (font-family fontname:gvd)
    =/  fc  (color-of fontcolor:gvd)
    =/  lines  (label-lines (trip txt))
    =/  k  (lent lines)
    =/  lh  (mul:rs .1.2 fs)
    =/  top  (add:rs y.at (div:rs (mul:rs lh (sun:rs k)) .2))
    =/  i  0
    =|  acc=(list tape)
    |-  ^-  tape
    ?~  lines  (zing (flop acc))
    =/  base
      %+  sub:rs  top
      (mul:rs lh (add:rs (sun:rs i) .0.8))
    =/  anchor
      ?-  align.i.lines
        %c  "middle"
        %l  "start"
        %r  "end"
      ==
    =/  tx
      ?-  align.i.lines
        %c  x.at
        %l  (sub:rs x.at halfw)
        %r  (add:rs x.at halfw)
      ==
    =/  el
      ;:  weld
        "<text text-anchor=\"{anchor}\" x=\"{(fmt tx)}\" "
        "y=\"{(fmt (yy base))}\" font-family=\"{fam}\" "
        "font-size=\"{(fmt fs)}\" fill=\"{fc}\">"
        (esc text.i.lines)
        "</text>\0a"
      ==
    $(lines t.lines, i +(i), acc [el acc])
  --
::
++  join-sp
  |=  parts=(list tape)
  ^-  tape
  ?~  parts  ""
  =/  acc=tape  i.parts
  =/  rest=(list tape)  t.parts
  |-  ^-  tape
  ?~  rest  acc
  $(rest t.rest, acc :(weld acc " " i.rest))
::
++  label-lines
  ::  split label text on \n \l \r and newlines, keeping alignment
  |=  tp=tape
  ^-  (list [align=?(%c %l %r) text=tape])
  =|  cur=tape
  =|  out=(list [align=?(%c %l %r) text=tape])
  |-  ^-  (list [align=?(%c %l %r) text=tape])
  ?~  tp
    (flop `_out`[[%c (flop cur)] out])
  ?:  =('\0a' i.tp)
    $(tp t.tp, out [[%c (flop cur)] out], cur ~)
  ?.  =('\\' i.tp)
    $(tp t.tp, cur [i.tp cur])
  ?~  t.tp
    (flop `_out`[[%c (flop [i.tp cur])] out])
  ?:  =('n' i.t.tp)
    $(tp t.t.tp, out [[%c (flop cur)] out], cur ~)
  ?:  =('l' i.t.tp)
    $(tp t.t.tp, out [[%l (flop cur)] out], cur ~)
  ?:  =('r' i.t.tp)
    $(tp t.t.tp, out [[%r (flop cur)] out], cur ~)
  $(tp t.t.tp, cur [i.t.tp cur])
--
