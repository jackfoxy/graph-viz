::  graph: positioned graph — the public consumable noun
::
::  Output of the layout pipeline and input to SVG codegen.  All
::  coordinates are @rs in points, y-up internally; the y-flip for
::  SVG happens at codegen (P11).  Node indices (edge endpoints)
::  refer to positions in the nodes list, matching resolution
::  order (P5).
::
|%
::
+$  fpair  [x=@rs y=@rs]
::  $bbox: lower-left and upper-right corners
::
+$  bbox  [ll=fpair ur=fpair]
::  $canvas: overall drawing size in points, and the scale applied
::
+$  canvas  [size=fpair scale=@rs]
::
+$  attrs  (map @t @t)
::  $spline: cubic bezier control runs; length = 1 mod 3
::
+$  spline  (list fpair)
::
+$  gnode
  $:  name=@t
      center=fpair
      half=fpair          :: half-extents: box is center +/- half
      shape=@t
      =attrs              :: complete resolved draw attrs
      label=@t            :: substituted label text
      label-at=fpair
  ==
::
+$  gedge
  $:  tail=@ud
      head=@ud
      =spline
      arrows=(list (list fpair))   :: arrowhead polygons
      label=(unit [text=@t at=fpair])
      =attrs
  ==
::
+$  gcluster
  $:  name=@t
      =bbox
      label=(unit [text=@t at=fpair])
      =attrs
  ==
::
+$  graph
  $:  name=@t
      =canvas
      directed=?
      nodes=(list gnode)
      edges=(list gedge)
      clusters=(list gcluster)
  ==
--
