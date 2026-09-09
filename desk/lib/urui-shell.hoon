::  urui-shell: the Sail frame, built from a $shell-spec.
::
::  urui owns the document, the header, the three area sections, their
::  pane headers and tab strips, and the script and style tags.  It
::  never owns what goes inside an area: `controls` and `body` are the
::  consumer's marl, spliced in place.
::
::  Phase 3 (W3.6) grows this into the full extracted frame — explorer,
::  resizers, dialogs, help panel.  What is here is the skeleton those
::  parts hang from, and every id and label comes from the spec, so the
::  markup contract is already the consumer's to set.
::
/-  urui
|%
::
++  build
  ::  The whole document for one application.
  ::
  ::  Example:
  ::    ++  page  (build:shell spec)
  |=  spec=shell-spec:urui
  ^-  manx
  =/  id  app-id.app-config.spec
  =/  style-tags=marl
    %+  turn  styles.spec
    |=  href=@t
    ^-  manx
    ;link(rel "stylesheet", href (trip href));
  =/  script-tags=marl
    %+  turn  scripts.spec
    |=  src=@t
    ^-  manx
    ;script(src (trip src));
  ;html
    ;head
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;title:"{(trip title.id)}"
      ;*  style-tags
    ==
    ;body(data-app (trip name.id))
      ;header.app-header
        ;*  brand.spec
        ;div.toolbar
          ;*  toolbar.spec
        ==
      ==
      ;main.app-shell
        ;+  (section reference.areas.spec)
        ;+  (section editor.areas.spec)
        ;+  (section result.areas.spec)
      ==
      ;div.app-dialogs
        ;*  dialogs.spec
      ==
      ;div.app-help(hidden "")
        ;*  help.spec
      ==
      ;*  script-tags
    ==
  ==
::
++  section
  ::  One area: pane header, optional tab strip, consumer body.
  ::
  ::  Called once per role from ++build.  Kept separate because the three
  ::  call sites would otherwise repeat twenty lines of Sail.
  |=  =area:urui
  ^-  manx
  =/  title=marl
    ?~  heading.area  ~
    :~  ;h2.pane-title:"{(trip u.heading.area)}"
    ==
  =/  status=marl
    ?~  status-id.area  ~
    :~  ;span.pane-status(id (trip u.status-id.area), role "status");
    ==
  =/  strip=marl
    ?.  strip.area  ~
    :~  ;div.tab-strip(id "{(trip id.area)}-tabs", role "tablist");
    ==
  =/  host=marl
    ?~  secondary.area  ~
    =/  ace  u.secondary.area
    =/  ace-id  (trip id.ace)
    =/  ace-label  (trip label.ace)
    =/  ace-mode  (trip mode.ace)
    ::  a tall-attribute element must have children; this one has none
    :~  ;div.editor-host(id ace-id, aria-label ace-label, data-mode ace-mode);
    ==
  ;section.pane
    =id  (trip id.area)
    =role  "region"
    =aria-label  (trip label.area)
    =data-role  (trip role.area)
    ;header.pane-header
      ;*  title
      ;*  status
      ;div.pane-actions
        ;*  controls.area
      ==
    ==
    ;*  strip
    ;*  host
    ;div.pane-body
      ;*  body.area
    ==
  ==
--
