::  urui-ace: $ace-spec -> the Ace loader configuration script.
::
::  Replaces the per-application static config file: the same javascript
::  is generated from data and served at the application's own url.
::
::  Phase 3 (W3.4) fills ++config-js.
::
/-  urui
|%
::
++  config-js
  ::  Emit the Ace basePath/modePath/themePath/workerPath script.
  ::
  |=  =ace-spec:urui
  ^-  @t
  ''
--
