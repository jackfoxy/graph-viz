::  svg: scalable vector graphics text
::
=,  mimes:html
|_  txt=@t
::
++  grab
  |%
  ++  noun  @t
  ++  mime  |=([p=mite q=octs] `@t`q.q)
  --
++  grow
  |%
  ++  noun  txt
  ++  mime  [/image/svg-xml (as-octs txt)]
  --
++  grad  %mime
--
