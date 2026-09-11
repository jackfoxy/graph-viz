::  urui-shell: the Sail frame, built from a $shell-spec.
::
::  urui owns the document, header, explorer, pane frames, resizers, tab
::  strips, help panel, dialogs, and asset tags.  Consumer marl is spliced
::  into the named slots without interpretation.
::
/-  urui
/+  ujs=urui-js
|%
::
++  build
  ::  The whole document for one application.
  ::
  ::  Example:
  ::    ++  page  (build:shell spec)
  |=  spec=shell-spec:urui
  ^-  manx
  ?~  permanent-views.app-config.spec
    (compact spec)
  (full spec)
::
++  full
  ::  Full application shell with explorer, workspace, and dialogs.
  |=  spec=shell-spec:urui
  ^-  manx
  =/  id  app-id.app-config.spec
  =/  style-tags=marl
    %+  turn  styles.spec
    style-tag
  =/  script-tags=marl
    %+  turn  scripts.spec
    |=  src=@t
    ^-  manx
    ;script(src (trip src));
  =/  theme-js
    (theme-bootstrap:ujs storage-key.id storage-version.id)
  =/  boot=marl
    :~  ;script
          ;+  ;/  (trip theme-js)
        ==
    ==
  ;html
    ;head
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;title:"{(trip title.id)}"
      ;*  boot
      ;*  style-tags
    ==
    ;body
      ;header.app-header
        ;*  brand.spec
        ;*  toolbar.spec
      ==
      ;main#workbench.workbench
        ;+  (explorer spec)
        ;button#explorer-resizer.explorer-resizer
          =type              "button"
          =role              "separator"
          =aria-orientation  "vertical"
          =aria-label        "Resize explorer"
          ;span.sr-only: Resize explorer
        ==
        ;section#workspace.workspace
          ;+  (workspace-area editor.areas.spec app-config.spec)
          ;div#splitter.splitter
            =role              "separator"
            =tabindex          "0"
            =aria-orientation  "vertical"
            =aria-label        "Resize editor and preview"
            ;span.sr-only: Resize editor and preview
          ==
          ;+  (workspace-area result.areas.spec app-config.spec)
        ==
      ==
      ;+  (help-panel spec)
      ;+  context-menu
      ;+  error-dialog
      ;*  (extra-dialogs dialogs.spec)
      ;*  script-tags
    ==
  ==
::
++  compact
  ::  Three-area frame for applications with no permanent explorer views.
  |=  spec=shell-spec:urui
  ^-  manx
  =/  id  app-id.app-config.spec
  =/  style-tags=marl
    %+  turn  styles.spec
    style-tag
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
++  style-tag
  ::  Absolute paths are stylesheet links; other cords are inline CSS.
  |=  value=@t
  ^-  manx
  =/  chars  (trip value)
  ?:  ?&(?=(^ chars) =('/' i.chars))
    ;link(rel "stylesheet", href (trip value));
  ;style
    ;+  ;/  chars
  ==
::
++  explorer
  |=  spec=shell-spec:urui
  ^-  manx
  =/  area  reference.areas.spec
  =/  views  permanent-views.app-config.spec
  =/  kinds  kinds.app-config.spec
  ;aside.explorer-pane
    =id          (trip id.area)
    =aria-label  (trip label.area)
    =data-role   (trip role.area)
    ;div.explorer-header
      ;div#explorer-tabs.explorer-tabs
        =role        "tablist"
        =aria-label  (trip label.area)
        ;*  (explorer-tabs views &)
      ==
      ;button#explorer-collapse.icon-button.explorer-collapse
        =type           "button"
        =aria-label     "Collapse explorer"
        =aria-expanded  "true"
        ‹
      ==
    ==
    ;*  (explorer-panels views kinds &)
    ;*  body.area
  ==
::
++  explorer-tabs
  |=  [views=(list [@tas @t]) first=?]
  ^-  marl
  ?~  views  ~
  =/  [name=@tas label=@t]  i.views
  =/  view  `@t`name
  =/  tab-id  (cat 3 view '-tab')
  =/  panel-id  (cat 3 view '-panel')
  =/  wrap-class
    ?:  first  "explorer-tab-control active"
    "explorer-tab-control"
  =/  tab=manx
    ?:  first
      ;button.explorer-tab.active
        =id                  (trip tab-id)
        =type                "button"
        =role                "tab"
        =data-explorer-view  (trip view)
        =aria-selected       "true"
        =aria-controls       (trip panel-id)
        {(trip label)}
      ==
    ;button.explorer-tab
      =id                  (trip tab-id)
      =type                "button"
      =role                "tab"
      =data-explorer-view  (trip view)
      =aria-selected       "false"
      =aria-controls       (trip panel-id)
      =tabindex            "-1"
      {(trip label)}
    ==
  :-  ;div(class wrap-class, role "presentation")
        ;+  tab
      ==
  $(views t.views, first |)
::
++  explorer-panels
  |=  [views=(list [@tas @t]) kinds=(list doc-kind:urui) first=?]
  ^-  marl
  ?~  views  ~
  =/  [name=@tas label=@t]  i.views
  =/  view  `@t`name
  =/  tab-id  (cat 3 view '-tab')
  =/  panel-id  (cat 3 view '-panel')
  =/  tree-id  (cat 3 view '-tree')
  =/  tree-label=@t
    ?~  kinds  label
    (cat 3 label.i.kinds ' files')
  =/  tree=manx
    ;div.explorer-file-tree
      =id          (trip tree-id)
      =role        "tree"
      =aria-label  (trip tree-label)
      =aria-busy   "true"
      ;p: Loading…
    ==
  =/  panel=manx
    ?:  first
      ;div.explorer-panel
        =id               (trip panel-id)
        =role             "tabpanel"
        =aria-labelledby  (trip tab-id)
        ;+  tree
      ==
    ;div.explorer-panel
      =id               (trip panel-id)
      =hidden           ""
      =role             "tabpanel"
      =aria-labelledby  (trip tab-id)
      ;+  tree
    ==
  :-  panel
  $(views t.views, kinds ?~(kinds ~ t.kinds), first |)
::
++  workspace-area
  ::  The ++full-shell equivalent of ++section: adds the document-tab
  ::  strip and a heading id keyed to the area's $doc-kind, which the
  ::  editor's Ace host needs to label itself.
  |=  [area=area:urui config=app-config:urui]
  ^-  manx
  =/  pane-class
    ?:  =(%editor role.area)  "pane editor-pane"
    "pane preview-pane"
  =/  heading=marl
    ?~  heading.area  ~
    ?:  ?&  =(%editor role.area)  ?=(^ kind.area)  ==
      =/  heading-id  (trip (cat 3 `@t`u.kind.area '-source-heading'))
      :~  ;h2(id heading-id):"{(trip u.heading.area)}"
      ==
    :~  ;h2:"{(trip u.heading.area)}"
    ==
  =/  status=marl
    ?~  status-id.area  ~
    :~  ;span.status
          =id  (trip u.status-id.area)
          ;+  ;/  (trip (initial-status role.area statuses.config))
        ==
    ==
  ;section
    =id          (trip id.area)
    =class       pane-class
    =data-role   (trip role.area)
    ;div.pane-header
      ;*  heading
      ;*  status
      ;*  controls.area
    ==
    ;*  (document-strip area config)
    ;*  body.area
    ;*  (secondary-host secondary.area)
  ==
::
++  document-strip
  |=  [area=area:urui config=app-config:urui]
  ^-  marl
  ?.  strip.area  ~
  ?~  kind.area
    :~  ;div.tab-strip(id "{(trip id.area)}-tabs", role "tablist");
    ==
  =/  kind  (find-kind u.kind.area kinds.config)
  =/  label=@t  ?~(kind `@t`u.kind.area label.u.kind)
  =/  tabs-id  (cat 3 `@t`u.kind.area '-document-tabs')
  :~  ;div.document-tabs
        =id          (trip tabs-id)
        =role        "tablist"
        =aria-label  "Open {(trip label)} documents"
        ;span(hidden "");
      ==
  ==
::
++  secondary-host
  |=  value=(unit editor:urui)
  ^-  marl
  ?~  value  ~
  =/  editor  u.value
  =/  host-id  (trip id.editor)
  =/  host-label  (trip label.editor)
  =/  host-mode  (trip mode.editor)
  :~  ;div.editor-host
        =id          host-id
        =aria-label  host-label
        =data-mode   host-mode
        ;span(hidden "");
      ==
  ==
::
++  help-panel
  |=  spec=shell-spec:urui
  ^-  manx
  ;aside#help-panel.help-panel
    =hidden          ""
    =role            "dialog"
    =aria-modal      "true"
    =aria-labelledby  "help-title"
    ;div#editor-help-card.help-card.editor-help-card
      ;div.pane-header
        ;h2#help-title: Help
        ;button#close-help.icon-button.help-close
          =type        "button"
          =title       "Close"
          =aria-label  "Close help"
          ;span.close-icon(aria-hidden "true");
        ==
      ==
      ;*  help.spec
    ==
  ==
::
++  context-menu
  ^-  manx
  ;div#file-context-menu.file-context-menu(hidden "", role "menu")
    ;button#file-context-open(type "button", role "menuitem"): Open
    ;button#file-context-delete.danger-button
      =type  "button"
      =role  "menuitem"
      Delete
    ==
  ==
::
++  error-dialog
  ^-  manx
  ;aside#clay-error-modal.help-panel
    =hidden          ""
    =role            "dialog"
    =aria-modal      "true"
    =aria-labelledby  "clay-error-title"
    ;div.help-card
      ;div.pane-header
        ;h2#clay-error-title: Clay error
        ;button#close-clay-error
          =type        "button"
          =aria-label  "Close Clay error"
          ;span: Close
        ==
      ==
      ;pre#clay-error-message.clay-error-message;
    ==
  ==
::
++  extra-dialogs
  |=  dialogs=marl
  ^-  marl
  ?~  dialogs  ~
  :~  ;div.app-dialogs
        ;*  dialogs
      ==
  ==
::
++  initial-status
  ::  The editor pane starts on the vocabulary's first status
  ::  (conventionally "ready"); every other pane starts on the third
  ::  (conventionally "empty") — a fixed position in the consumer's own
  ::  status list, not something urui can name generically.
  |=  [role=area-role:urui statuses=(list [@tas @t])]
  ^-  @t
  ?~  statuses  ''
  =/  first-label=@t  +.i.statuses
  ?:  =(%editor role)  first-label
  =/  rest  t.statuses
  ?~  rest  first-label
  =/  rest  t.rest
  ?~  rest  first-label
  +.i.rest
::
++  find-kind
  |=  [name=@tas kinds=(list doc-kind:urui)]
  ^-  (unit doc-kind:urui)
  ?~  kinds  ~
  ?:  =(name name.i.kinds)  `i.kinds
  $(kinds t.kinds)
::
++  section
  ::  One area: pane header, optional tab strip, consumer body.
  ::
  ::  Used by ++compact (the frame for applications with no permanent
  ::  explorer views); ++full uses ++workspace-area instead, which also
  ::  renders the document-tab strip. Kept separate from ++compact
  ::  because its three call sites would otherwise repeat twenty lines
  ::  of Sail.
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
