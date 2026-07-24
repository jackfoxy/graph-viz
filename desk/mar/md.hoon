|_  doc=@t
  ::
  :: Turn stuff into %md
  ++  grab
    |%
    ::
    :: Assert that it's already markdown text
    ++  noun  @t
    ::
    :: Read it from %mime (e.g., if it's `|commit`ed from Unix)
    ++  mime
      |=  [mime-type=mite data=octs]
      ^-  @t
      q.data
    --
  ::
  :: Turn %md into other stuff
  ++  grow
    |%
    :: It is already a noun
    ++  noun  doc
    ::
    :: Convert it to %mime so the desk can be mounted
    ++  mime
      [/text/markdown (as-octs:mimes:html doc)]
    --
  ++  grad  %noun
--
