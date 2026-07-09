::  +graph-viz!dot-svg: render DOT text from the dojo
::
::  Usage:
::    +graph-viz!dot-svg 'digraph {a -> b}'
::
::  Produces a result:gviz noun: [%svg ...] with the SVG text on
::  success, [%error ...] otherwise.
::
/-  gviz
/+  lib=gviz
:-  %say
|=  [* [src=@t ~] ~]
:-  %noun
(run:lib [%render 0v0 [%dot %svg ~ ~ %.n %.n %.n %.n] src])
