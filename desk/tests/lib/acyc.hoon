::  Tests for /lib/acyc (P7: cycle breaking)
::
/+  *test, acyc
|%
::  +|  Helpers
::
::
++  is-dag
  ::  Kahn's algorithm; self-loops excluded
  |=  [n=@ud es=(list [t=@ud h=@ud])]
  ^-  ?
  ?:  =(0 n)  %.y
  =/  es  (skim es |=([t=@ud h=@ud] !=(t h)))
  =/  indeg=(map @ud @ud)
    %+  roll  es
    |=  [[t=@ud h=@ud] m=(map @ud @ud)]
    (~(put by m) h +((~(gut by m) h 0)))
  =/  outs=(map @ud (list @ud))
    %+  roll  es
    |=  [[t=@ud h=@ud] m=(map @ud (list @ud))]
    (~(put by m) t [h (~(gut by m) t ~)])
  =/  q=(list @ud)
    %+  skim  (gulf 0 (dec n))
    |=(v=@ud =(0 (~(gut by indeg) v 0)))
  =/  done  0
  |-  ^-  ?
  ?~  q  =(done n)
  =/  os  (~(gut by outs) i.q ~)
  =^  newq  indeg
    =|  nq=(list @ud)
    |-  ^-  [(list @ud) (map @ud @ud)]
    ?~  os  [nq indeg]
    =/  d  (dec (~(got by indeg) i.os))
    =.  indeg  (~(put by indeg) i.os d)
    $(os t.os, nq ?:(=(0 d) [i.os nq] nq))
  $(q (weld t.q newq), done +(done))
::
++  bare
  |=  aes=(list aedge:acyc)
  ^-  (list [@ud @ud])
  (turn aes |=(a=aedge:acyc [tail.a head.a]))
::  +|  Tests
::
::
++  test-acyc-chain
  %+  expect-eq
    !>  ~[[0 0 1 %.n] [1 1 2 %.n]]
  !>  (break-cycles:acyc 3 ~[[0 1] [1 2]])
::
++  test-acyc-cycle2
  %+  expect-eq
    !>  ~[[0 0 1 %.n] [1 0 1 %.y]]
  !>  (break-cycles:acyc 2 ~[[0 1] [1 0]])
::
++  test-acyc-cycle3
  %+  expect-eq
    !>  ~[[0 0 1 %.n] [1 1 2 %.n] [2 0 2 %.y]]
  !>  (break-cycles:acyc 3 ~[[0 1] [1 2] [2 0]])
::
++  test-acyc-self-loop
  ::  self-loops pass through unreversed
  %+  expect-eq
    !>  ~[[0 0 0 %.n] [1 0 1 %.n]]
  !>  (break-cycles:acyc 2 ~[[0 0] [0 1]])
::
++  test-acyc-dag-property
  ::  a tangle of cycles always comes out acyclic
  =/  es=(list [@ud @ud])
    :~  [0 1]  [1 2]  [2 0]  [2 3]  [3 1]
        [3 4]  [4 2]  [0 3]  [4 0]  [2 2]
    ==
  =/  aes  (break-cycles:acyc 5 es)
  ;:  weld
    (expect !>((is-dag 5 (bare aes))))
    (expect-eq !>(10) !>((lent aes)))
  ==
--
