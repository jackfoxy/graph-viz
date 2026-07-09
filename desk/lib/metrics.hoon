::  metrics: text metrics (P6)
::
::  +text-size is the ONLY metrics entry point in the pipeline, so
::  a real font-metrics table can replace this one later without
::  touching any other stage.
::
::  Widths come from the standard Helvetica AFM table (thousandths
::  of an em per glyph, ASCII 32-126); other codepoints get a flat
::  fallback width.  Label escapes \n \l \r and literal newlines
::  break lines; any other backslash escape measures as its escaped
::  character.  Height is 1.2 em per line (graphviz LINESPACING).
::
|%
::
++  line-spacing  .1.2
::
++  fallback  600
::  +|  Public API
::
::
++  text-size
  ::  [font-size text] -> [w h] in points
  |=  [size=@rs text=@t]
  ^-  [w=@rs h=@rs]
  ?:  =('' text)  [.0 .0]
  =/  lines  (split-label (trip text))
  =/  wmax  (roll (turn lines line-w) max)
  :-  (mul:rs size (div:rs (sun:rs wmax) (sun:rs 1.000)))
  (mul:rs size (mul:rs line-spacing (sun:rs (lent lines))))
::  +|  Internals
::
::
++  split-label
  ::  split on \n \l \r escapes and literal newlines; other
  ::  backslash escapes reduce to their escaped character
  |=  tp=tape
  ^-  (list tape)
  =|  cur=tape
  =|  out=(list tape)
  |-  ^-  (list tape)
  ?~  tp  (flop [(flop cur) out])
  ?:  =('\0a' i.tp)
    $(tp t.tp, out [(flop cur) out], cur ~)
  ?.  =('\\' i.tp)
    $(tp t.tp, cur [i.tp cur])
  ?~  t.tp  (flop [(flop [i.tp cur]) out])
  ?:  ?|(=('n' i.t.tp) =('l' i.t.tp) =('r' i.t.tp))
    $(tp t.t.tp, out [(flop cur) out], cur ~)
  $(tp t.t.tp, cur [i.t.tp cur])
::
++  line-w
  ::  width of one line in thousandths of an em; multibyte UTF-8
  ::  sequences count once at the fallback width
  |=  tp=tape
  ^-  @ud
  ?~  tp  0
  ?:  (gte i.tp 0xc0)  (add fallback $(tp t.tp))
  ?:  (gte i.tp 0x80)  $(tp t.tp)
  (add (char-w i.tp) $(tp t.tp))
::
++  char-w
  |=  c=@tD
  ^-  @ud
  ?:  |((lth c 32) (gth c 126))  fallback
  (snag (sub c 32) helv)
::  +|  Helvetica AFM widths, ASCII 32-126
::
::
++  helv
  ^-  (list @ud)
  :~  278  278  355  556  556  889  667  191  333  333
      389  584  278  333  278  278  556  556  556  556
      556  556  556  556  556  556  278  278  584  584
      584  556  1.015  667  667  722  722  667  611  778
      722  278  500  667  556  833  722  778  667  778
      722  667  611  722  667  944  667  667  611  278
      278  278  469  556  333  556  556  500  556  556
      278  556  556  222  222  500  222  833  556  556
      556  556  333  500  278  556  500  722  500  500
      500  334  260  334  584
  ==
--
