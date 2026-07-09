::  P0 smoke test: the desk builds and the stub agent behaves
::
::  Importing /app/graph-viz forces the agent (and its deps) to build,
::  so a passing run proves the desk compiles end to end.
::
/+  *test
/=  agent  /app/graph-viz
|%
::
++  test-stub-state
  ::  on-save of the fresh agent is the bunt of state-0
  ^-  tang
  %+  expect-eq
    !>  [%0 ~]
  on-save:~(. agent *bowl:gall)
::
++  test-poke-rejected
  ::  every poke is nacked until the protocol lands (P12)
  ^-  tang
  %-  expect-fail
  |.  (on-poke:~(. agent *bowl:gall) %noun !>(~))
--
