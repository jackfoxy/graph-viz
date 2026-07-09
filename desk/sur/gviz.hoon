::  gviz: command / response protocol (P12)
::
::  Stateless protocol: the caller subscribes to /result/[uid]
::  (uid chosen by the caller), pokes %gviz-command carrying the
::  same uid, and receives one %gviz-result %fact followed by a
::  %kick.  The full CLI flag-disposition table from the plan maps
::  onto $render-opts; only %dot / %svg are accepted in v1, the
::  rest of both enums are recognized and rejected as unsupported.
::
/-  gg=graph
|%
::
+$  engine  ?(%dot %neato %fdp %sfdp %twopi %circo %patchwork %osage)
::
+$  format
  $?  %svg  %svgz  %png  %pdf  %ps  %ps2  %eps  %gif  %jpg  %jpeg
      %json  %json0  %dot-json  %xdot  %xdot-json  %dot-out  %canon
      %gv  %plain  %plain-ext  %pov  %fig  %imap  %ismap  %cmap
      %cmapx  %tif  %tiff  %tk  %vml  %vrml  %wbmp  %webp  %pic
      %x11  %xlib
  ==
::  $gattr: one CLI default (-G/-N/-E; -A expands to all three)
::
+$  gattr  [targ=?(%graph %node %edge) name=@t value=@t]
::
+$  render-opts
  $:  =engine                          :: command name / -K
      =format                          :: -T; only %svg accepted
      defaults=(list gattr)            :: -G/-N/-E/-A, in order
      scale=(unit @rd)                 :: -s
      flip-y=?                         :: -y
      quiet=?                          :: -q: drop warnings
      verbose=?                        :: -v: phase diagnostics
      want-graph=?                     :: also return the noun
  ==
::
+$  command
  $%  [%render uid=@uv opts=render-opts src=@t]
      [%version uid=@uv]               :: -V
      [%plugins uid=@uv]               :: -P
  ==
::  $diag: -v per-phase diagnostics
::
+$  diag
  $:  nodes=@ud
      edges=@ud
      clusters=@ud
      nrank=@ud
      virtuals=@ud
      crossings=@ud
  ==
::
+$  err
  $%  [%parse line=@ud col=@ud msg=@t]
      [%unsupported-engine =engine]
      [%unsupported-format =format]
      [%unsupported-feature msg=@t]
      [%layout msg=@t]
  ==
::
+$  result
  $%  [%svg warnings=(list @t) diag=(unit diag) svg=@t graph=(unit graph:gg)]
      [%graph warnings=(list @t) graph=graph:gg]
      [%error =err]
      [%version ver=[maj=@ud min=@ud pat=@ud]]
      [%plugins engines=(list [engine ?]) formats=(list [format ?])]
  ==
--
