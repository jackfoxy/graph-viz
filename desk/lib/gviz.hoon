::  gviz: top-level pipeline gate (P12)
::
::  Composes parse -> resolve -> layout -> codegen and maps every
::  failure to a structured $err:gviz.  Layout runs under +mule so
::  a crash becomes an %error %layout result, never an agent crash.
::  Shared by the agent and the tests.
::
/-  gviz, gg=graph
/+  parse=parse, attr=attr, rank=rank
/+  order=order, coord=coord, route=route
/+  svg=svg
|%
::
++  version  `[maj=@ud min=@ud pat=@ud]`[0 1 0]
::
++  engines
  ^-  (list [engine:gviz ?])
  :~  [%dot %.y]  [%neato %.n]  [%fdp %.n]  [%sfdp %.n]
      [%twopi %.n]  [%circo %.n]  [%patchwork %.n]  [%osage %.n]
  ==
::
++  formats
  ^-  (list [format:gviz ?])
  :~  [%svg %.y]  [%png %.n]  [%pdf %.n]  [%ps %.n]  [%json %.n]
      [%dot-out %.n]  [%plain %.n]  [%xdot %.n]  [%canon %.n]
  ==
::
++  run
  |=  cmd=command:gviz
  ^-  result:gviz
  ?-  -.cmd
    %version  [%version version]
    %plugins  [%plugins engines formats]
    %render   (render opts.cmd src.cmd)
  ==
::
++  render
  |=  [opts=render-opts:gviz src=@t]
  ^-  result:gviz
  ?.  =(%dot engine.opts)
    [%error %unsupported-engine engine.opts]
  ?.  =(%svg format.opts)
    [%error %unsupported-format format.opts]
  =/  pr  (parse:parse src)
  ?:  ?=(%| -.pr)
    ?:  ?=(%html -.p.pr)
      =/  at  pos.p.pr
      :+  %error  %unsupported-feature
      %-  crip
      "HTML labels not supported: line {<line.at>}, column {<col.at>}"
    [%error %parse line.pos.p.pr col.pos.p.pr 'syntax error']
  =/  res  (resolve:attr p.pr (convert-defaults defaults.opts))
  =/  lay  (mule |.((layout res)))
  ?:  ?=(%| -.lay)
    [%error %layout 'layout failed']
  =/  [g=ranked:rank o=ordered:order pg=graph:gg]  p.lay
  =/  pg
    ?~  scale.opts  pg
    %=  pg
      scale.canvas  %+  mul:rs  scale.canvas.pg
                    (div:rs (rd-rs:coord u.scale.opts) .72)
    ==
  =/  sv  (render:svg pg flip-y.opts)
  ?:  ?=(%| -.sv)
    [%error %unsupported-feature p.sv]
  =/  dg=(unit diag:gviz)
    ?.  verbose.opts  ~
    :-  ~
    :*  (lent nodes.res)
        (lent edges.res)
        (lent clusters.res)
        nrank.g
        (sub nall.g nreal.g)
        crossings.o
    ==
  :*  %svg
      ?:(quiet.opts ~ warnings.res)
      dg
      p.sv
      ?:(want-graph.opts `pg ~)
  ==
::
++  layout
  |=  res=resolved:attr
  ^-  [ranked:rank ordered:order graph:gg]
  =/  g  (rank-graph:rank res)
  =/  o  (order-graph:order res g)
  =/  c  (coord-graph:coord res g o)
  [g o (build-graph:route res g c)]
::
++  convert-defaults
  |=  ds=(list gattr:gviz)
  ^-  (list gattr:attr)
  (turn ds |=(d=gattr:gviz [targ.d name.d value.d]))
--
