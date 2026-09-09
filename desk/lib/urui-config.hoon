::  urui-config: $app-config -> window.URUI_CONFIG.
::
::  The browser runtime reads every consumer-specific value through this
::  one json object; nothing in urui's javascript names a consumer.
::
::  Phase 3 (W3.6) fills ++emit.
::
/-  urui
|%
::
++  emit
  ::  Emit `window.URUI_CONFIG = {...};` for one application.
  ::
  |=  =app-config:urui
  ^-  @t
  ''
--
