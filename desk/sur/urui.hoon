::  urui: shared UI contract.
::
::  The whole public surface of the urui shell, as data.  A consuming
::  application builds one $shell-spec and one $app-config; urui builds
::  the page, the css, and the browser runtime from those.
::
::  urui never imports a consumer's /sur and never names a consumer.
::  The dependency direction is strictly consumer -> urui.
::
|%
::
+$  app-id
  ::  Identity and namespace of the consuming application.
  ::
  ::  Example:
  ::    [%sample 'Sample' '/apps/sample' 'sample.session.v1' 1]
  $:  name=@tas
      title=@t
      base=@t
      storage-key=@t
      storage-version=@ud
  ==
::
+$  doc-kind
  ::  One class of document the application edits or displays.
  ::
  ::  `leaf` is the clay extension the document is stored under; `ext`
  ::  is the suffix a tab label shows.  They differ whenever a mark is
  ::  reused for a format that names itself differently — DOT stored as
  ::  `%txt` and labelled `.dot` is the case that forced the split.
  ::  `tabs` asks for a document tab strip, `refs` for the Add Ref control.
  $:  name=@tas
      label=@t
      untitled=@t
      ext=@ta
      leaf=@ta
      mime=@t
      tabs=?
      refs=?
  ==
::
+$  area-role  ?(%reference %editor %result)
::
+$  area
  ::  One of the three UI regions.
  ::
  ::  There is no default area.  The consumer supplies all three; urui
  ::  ships the frame, the tab strip, and the status line, never a
  ::  preview, a grid, or a secondary editor implementation.
  $:  role=area-role
      id=@t
      label=@t
      heading=(unit @t)
      status-id=(unit @t)
      kind=(unit @tas)
      strip=?
      controls=marl
      body=marl
      secondary=(unit editor)
  ==
::
+$  editor
  ::  An Ace host managed by urui.
  ::
  $:  id=@t
      label=@t
      mode=@t
      wrap=?
      read-only=?
      max-bytes=@ud
  ==
::
+$  ace-spec
  ::  Vendored Ace runtime parameters.
  ::
  ::  `global` is the window property the loader publishes, kept
  ::  consumer-named so an adopting application need not rename it.
  $:  base=@t
      global=@t
      version=@t
      mode=@t
      light=@t
      dark=@t
      exts=(list @t)  ::  Full module ids, e.g. 'ace/ext/searchbox'.
      use-worker=?
  ==
::
+$  transport  ?(%header %body)
::
+$  endpoints
  ::  The four file operations and how the path travels.
  ::
  ::  %header sends the clay path in `path-header`; %body sends it as a
  ::  json object with `path` segments, `source` text, and `overwrite`.
  ::  `{kind}` in a route is replaced by the $doc-kind name.
  $:  =transport
      path-header=(unit @t)
      flag-header=(unit @t)
      browse=@t
      load=@t
      save=@t
      delete=@t
  ==
::
+$  slot
  ::  One persisted field of the session record.
  ::
  ::  `key` is the json key as it already appears on disk, so an
  ::  existing record keeps loading without migration.
  $:  key=@t
      owner=?(%urui %app)
      shape=?(%tabs %active %next %scalar %record)
      kind=(unit @tas)
  ==
::
+$  shortcut
  ::  An application chord urui dispatches on the app's behalf.
  ::
  ::  %editor/%no-editor test Ace focus; %preview uses the consumer
  ::  runtime option `shortcuts.preview`, even while Ace has focus.
  ::  Register command handlers through `runtime.shortcuts.register`.
  ::
  $:  binding=@t
      command=@t
      when=?(%always %preview %editor %no-editor)
  ==
::
+$  limits
  ::  Numeric policy, in milliseconds, pixels, percent, and bytes.
  ::
  $:  render-debounce=@ud
      save-debounce=@ud
      min-explorer=@ud
      divider=@ud
      pane-min=@ud
      pane-max=@ud
      narrow=@ud
      max-source=@ud
  ==
::
+$  app-config
  ::  Everything the browser runtime needs, as data.
  ::
  ::  Emitted to the page as one json object; nothing in urui's
  ::  javascript reads a consumer name except through this record.
  $:  =app-id
      kinds=(list doc-kind)
      =endpoints
      =limits
      slots=(list slot)
      shortcuts=(list shortcut)
      statuses=(list [@tas @t])
      docs-root=(unit @t)
      share-param=(unit [name=@t max=@ud param-max=@ud])
      permanent-views=(list [@tas @t])
      =ace-spec
  ==
::
+$  shell-spec
  ::  Everything the Sail frame needs.
  ::
  ::  `brand`, `toolbar`, `help`, and `dialogs` are consumer marl slots;
  ::  `scripts` and `styles` are emitted in the order given.
  $:  =app-config
      brand=marl
      toolbar=marl
      areas=[reference=area editor=area result=area]
      help=marl
      dialogs=marl
      styles=(list @t)
      scripts=(list @t)
  ==
--
