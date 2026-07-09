::  Tests for /lib/gviz (P12: pipeline gate + flag dispositions)
::
/-  gviz
/+  *test, lib=gviz
|%
::  +|  Helpers
::
::
++  opts0
  ^-  render-opts:gviz
  [%dot %svg ~ ~ %.n %.n %.n %.n]
::
++  rr
  |=  [opts=render-opts:gviz src=@t]
  ^-  result:gviz
  (run:lib [%render 0v0 opts src])
::  +|  Happy path
::
::
++  test-run-hello
  =/  r  (rr opts0 'digraph {a->b}')
  ?>  ?=(%svg -.r)
  ;:  weld
    (expect !>((gth (met 3 svg.r) 100)))
    (expect-eq !>(~) !>(warnings.r))
    (expect-eq !>(~) !>(diag.r))
    (expect-eq !>(~) !>(graph.r))
  ==
::
++  test-run-version
  %+  expect-eq
    !>([%version 0 1 0])
  !>((run:lib [%version 0v0]))
::
++  test-run-plugins
  =/  r  (run:lib [%plugins 0v0])
  ?>  ?=(%plugins -.r)
  ;:  weld
    (expect !>((lien engines.r |=([e=engine:gviz on=?] &(=(%dot e) on)))))
    (expect !>((lien engines.r |=([e=engine:gviz on=?] &(=(%neato e) !on)))))
    (expect !>((lien formats.r |=([f=format:gviz on=?] &(=(%svg f) on)))))
    (expect !>((lien formats.r |=([f=format:gviz on=?] &(=(%png f) !on)))))
  ==
::  +|  Errors
::
::
++  test-run-parse-error
  %+  expect-eq
    !>([%error %parse 1 14 'syntax error'])
  !>((rr opts0 'digraph { a -- b }'))
::
++  test-run-html-unsupported
  =/  r  (rr opts0 'digraph { a -> <b> }')
  ?>  ?=(%error -.r)
  (expect !>(?=(%unsupported-feature -.err.r)))
::
++  test-run-record-unsupported
  =/  r  (rr opts0 'digraph {a [shape=record]}')
  ?>  ?=(%error -.r)
  (expect !>(?=(%unsupported-feature -.err.r)))
::
++  test-run-unsupported-format
  %+  expect-eq
    !>([%error %unsupported-format %png])
  =/  o  opts0
  !>((rr o(format %png) 'digraph {a}'))
::
++  test-run-unsupported-engine
  %+  expect-eq
    !>([%error %unsupported-engine %neato])
  =/  o  opts0
  !>((rr o(engine %neato) 'digraph {a}'))
::  +|  Options
::
::
++  test-run-warnings-and-quiet
  ;:  weld
    =/  r  (rr opts0 'digraph {a [foo=1]}')
    ?>  ?=(%svg -.r)
    (expect-eq !>(~['unknown attribute: foo']) !>(warnings.r))
  ::
    =/  o  opts0
    =/  r  (rr o(quiet %.y) 'digraph {a [foo=1]}')
    ?>  ?=(%svg -.r)
    (expect-eq !>(~) !>(warnings.r))
  ==
::
++  test-run-verbose-diag
  =/  o  opts0
  =/  r  (rr o(verbose %.y) 'digraph {a->b}')
  ?>  ?=(%svg -.r)
  (expect-eq !>(`[2 1 0 2 0 0]) !>(diag.r))
::
++  test-run-want-graph
  =/  o  opts0
  =/  r  (rr o(want-graph %.y) 'digraph {a->b}')
  ?>  ?=(%svg -.r)
  ?>  ?=(^ graph.r)
  (expect-eq !>(2) !>((lent nodes.u.graph.r)))
::
++  test-run-cli-defaults
  ::  -N shape=box reaches the nodes
  =/  o  opts0
  =/  r
    %+  rr  o(defaults ~[[%node 'shape' 'box']], want-graph %.y)
    'digraph {a->b}'
  ?>  ?=(%svg -.r)
  ?>  ?=(^ graph.r)
  (expect-eq !>('box') !>(shape:(snag 0 nodes.u.graph.r)))
::
++  test-run-scale
  ::  -s 36 halves the output scale factor
  =/  o  opts0
  =/  r  (rr o(scale `.~36, want-graph %.y) 'digraph {a->b}')
  ?>  ?=(%svg -.r)
  ?>  ?=(^ graph.r)
  (expect-eq !>(.0.5) !>(scale.canvas.u.graph.r))
--
