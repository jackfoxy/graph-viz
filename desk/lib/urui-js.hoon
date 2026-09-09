::  urui-js: the shared browser runtime, as cords.
::
::  ++theme-bootstrap runs before first paint and must stay tiny.
::  ++core defines window.urui and is welded ahead of the consumer's
::  own script, which calls urui.boot(hooks).
::
::  Phase 3 (W3.5) fills these arms from the extracted regions.
::
|%
::
++  theme-bootstrap
  ::  Pre-paint theme read, parameterized on the session record.
  ::
  |=  [storage-key=@t version=@ud]
  ^-  @t
  ''
::
++  core
  ^-  @t
  ''
--
