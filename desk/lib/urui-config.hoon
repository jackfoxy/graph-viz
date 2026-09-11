::  urui-config: $app-config -> window.URUI_CONFIG.
::
::  The browser runtime reads every consumer-specific value through this
::  one json object; nothing in urui's javascript names a consumer.
/-  urui
|%
::
++  emit
  ::  Emit `window.URUI_CONFIG = {...};` for one application.
  ::
  |=  =app-config:urui
  ^-  @t
  %+  rap  3
  :~  'window.URUI_CONFIG = '
      (en:json:html (config-json app-config))
      ';\0a'
  ==
::
++  config-json
  |=  =app-config:urui
  ^-  json
  %-  pairs:enjs:format
  :~  ['appId' (app-id-json app-id.app-config)]
      ['kinds' a+(turn kinds.app-config doc-kind-json)]
      ['endpoints' (endpoints-json endpoints.app-config)]
      ['limits' (limits-json limits.app-config)]
      ['slots' a+(turn slots.app-config slot-json)]
      ['shortcuts' a+(turn shortcuts.app-config shortcut-json)]
      ['statuses' a+(turn statuses.app-config status-json)]
      ['docsRoot' (unit-text-json docs-root.app-config)]
      ['shareParam' (share-json share-param.app-config)]
      ['permanentViews' a+(turn permanent-views.app-config view-json)]
      ['ace' (ace-json ace-spec.app-config)]
  ==
::
++  app-id-json
  |=  id=app-id:urui
  ^-  json
  %-  pairs:enjs:format
  :~  ['name' s+name.id]
      ['title' s+title.id]
      ['base' s+base.id]
      ['storageKey' s+storage-key.id]
      ['storageVersion' (number storage-version.id)]
  ==
::
++  doc-kind-json
  |=  kind=doc-kind:urui
  ^-  json
  %-  pairs:enjs:format
  :~  ['name' s+name.kind]
      ['label' s+label.kind]
      ['untitled' s+untitled.kind]
      ['ext' s+ext.kind]
      ['leaf' s+leaf.kind]
      ['mime' s+mime.kind]
      ['tabs' b+tabs.kind]
      ['refs' b+refs.kind]
  ==
::
++  endpoints-json
  |=  endpoints=endpoints:urui
  ^-  json
  %-  pairs:enjs:format
  :~  ['transport' s+`@t`transport.endpoints]
      ['pathHeader' (unit-text-json path-header.endpoints)]
      ['flagHeader' (unit-text-json flag-header.endpoints)]
      ['browse' s+browse.endpoints]
      ['load' s+load.endpoints]
      ['save' s+save.endpoints]
      ['delete' s+delete.endpoints]
  ==
::
++  limits-json
  |=  limits=limits:urui
  ^-  json
  %-  pairs:enjs:format
  :~  ['renderDebounce' (number render-debounce.limits)]
      ['saveDebounce' (number save-debounce.limits)]
      ['minExplorer' (number min-explorer.limits)]
      ['divider' (number divider.limits)]
      ['paneMin' (number pane-min.limits)]
      ['paneMax' (number pane-max.limits)]
      ['narrow' (number narrow.limits)]
      ['maxSource' (number max-source.limits)]
  ==
::
++  slot-json
  |=  slot=slot:urui
  ^-  json
  %-  pairs:enjs:format
  :~  ['key' s+key.slot]
      ['owner' s+`@t`owner.slot]
      ['shape' s+`@t`shape.slot]
      ['kind' (unit-term-json kind.slot)]
  ==
::
++  shortcut-json
  |=  shortcut=shortcut:urui
  ^-  json
  %-  pairs:enjs:format
  :~  ['binding' s+binding.shortcut]
      ['command' s+command.shortcut]
      ['when' s+`@t`when.shortcut]
  ==
::
++  status-json
  |=  [name=@tas label=@t]
  ^-  json
  %-  pairs:enjs:format
  ~[['name' s+name] ['label' s+label]]
::
++  view-json
  |=  [name=@tas label=@t]
  ^-  json
  %-  pairs:enjs:format
  ~[['name' s+name] ['label' s+label]]
::
++  share-json
  |=  share=(unit [name=@t max=@ud param-max=@ud])
  ^-  json
  ?~  share  ~
  %-  pairs:enjs:format
  :~  ['name' s+name.u.share]
      ['max' (number max.u.share)]
      ['paramMax' (number param-max.u.share)]
  ==
::
++  ace-json
  |=  ace=ace-spec:urui
  ^-  json
  %-  pairs:enjs:format
  :~  ['base' s+base.ace]
      ['global' s+global.ace]
      ['version' s+version.ace]
      ['mode' s+mode.ace]
      ['light' s+light.ace]
      ['dark' s+dark.ace]
      ['extensions' a+(turn exts.ace |=(ext=@t s+ext))]
      ['useWorker' b+use-worker.ace]
  ==
::
++  unit-text-json
  |=  value=(unit @t)
  ^-  json
  ?~(value ~ s+u.value)
::
++  unit-term-json
  |=  value=(unit @tas)
  ^-  json
  ?~(value ~ s+u.value)
::
++  number
  ::  `scot %ud` groups digits with dots, which json numbers cannot carry.
  |=  value=@ud
  ^-  json
  =/  digits
    %+  skim  (trip (scot %ud value))
    |=(char=@tD !=('.' char))
  n+(crip digits)
--
