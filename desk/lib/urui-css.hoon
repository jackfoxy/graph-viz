::  urui-css: the shared stylesheet, in composable sections.
::
::  Each arm is one cord of css text.  A consumer composes the sections
::  it wants and welds its own application rules after them, so the
::  cascade order stays the consumer's decision.
::
::  Phase 3 (W3.3) fills these arms from the extracted rules; until then
::  they are empty and compose to ''.
::
|%
::
+$  section
  ::  The composable css sections, in cascade order.
  ::
  $?  %tokens  %shell  %explorer  %tabs
      %dialogs  %controls  %responsive
  ==
::
++  tokens
  ^-  @t
  ''
::
++  shell
  ^-  @t
  ''
::
++  explorer
  ^-  @t
  ''
::
++  tabs
  ^-  @t
  ''
::
++  dialogs
  ^-  @t
  ''
::
++  controls
  ^-  @t
  ''
::
++  responsive
  ^-  @t
  ''
::
++  compose
  ::  Concatenate the named sections, in the order given.
  ::
  ::  Example:
  ::    (compose ~[%tokens %shell %explorer %tabs])
  |=  parts=(list section)
  ^-  @t
  %+  rap  3
  %+  turn  parts
  |=  name=section
  ^-  @t
  ?-  name
    %tokens      tokens
    %shell       shell
    %explorer    explorer
    %tabs        tabs
    %dialogs     dialogs
    %controls    controls
    %responsive  responsive
  ==
--
