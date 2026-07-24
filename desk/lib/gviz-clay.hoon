::  Clay path and directory helpers for %graph-viz-web.
::
|%
::
++  storage-root  /data/graph-viz
::
++  file-path
  |=  [raw=@t ext=?(%txt %svg)]
  ^-  (unit path)
  =/  clean=@t
    =/  chars=tape  (trip raw)
    |-  ^-  @t
    ?~  chars  ''
    ?.  =('/' i.chars)  (crip chars)
    $(chars t.chars)
  =/  parsed=(unit path)
    %-  mole  |.
    (stab (cat 3 '/' clean))
  ?~  parsed  ~
  =/  rel=path  u.parsed
  ?:  =(~ rel)  ~
  ?.  %+  levy  rel
      |=  part=@ta
      ?&  !=('.' part)
          !=('..' part)
      ==
    ~
  =?  rel  !=(ext (rear rel))
    (snoc rel ext)
  `(weld storage-root rel)
::
++  browse-path
  |=  raw=@t
  ^-  (unit path)
  ?:  =('' raw)  `storage-root
  =/  clean=@t
    =/  chars=tape  (trip raw)
    |-  ^-  @t
    ?~  chars  ''
    ?.  =('/' i.chars)  (crip chars)
    $(chars t.chars)
  =/  parsed=(unit path)
    %-  mole  |.
    (stab (cat 3 '/' clean))
  ?~  parsed  ~
  =/  relative=path  u.parsed
  ?:  =(~ relative)  ~
  ?.  %+  levy  relative
      |=  part=@ta
      ?&  !=('.' part)
          !=('..' part)
      ==
    ~
  `(weld storage-root relative)
::
++  browse-text
  |=  [file=? children=(list @ta)]
  ^-  @t
  %-  en:json:html
  %-  pairs:enjs:format
  :~  ['file' b+file]
      ['children' a+(turn children |=(name=@ta s+name))]
  ==
--
