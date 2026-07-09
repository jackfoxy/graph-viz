::  %graph-viz: Graphviz DOT renderer in pure Hoon (P12)
::
::  Stateless: the caller subscribes to /result/[uid], pokes
::  %gviz-command carrying the same uid, and gets one %gviz-result
::  %fact on the path followed by a %kick.  No state survives the
::  event.  A poke with no matching subscriber is nacked with an
::  explanation of the protocol.
::
/-  gviz
/+  default-agent, lib=gviz
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 ~]
+$  card  card:agent:gall
--
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %n) bowl)
::
++  on-init
  ^-  (quip card _this)
  `this
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?.  =(%gviz-command mark)
    (on-poke:default mark vase)
  =/  cmd  !<(command:gviz vase)
  =/  uid
    ?-  -.cmd
      %render   uid.cmd
      %version  uid.cmd
      %plugins  uid.cmd
    ==
  =/  pax=path  /result/(scot %uv uid)
  ?.  %+  lien  ~(val by sup.bowl)
      |=([p=ship q=path] =(q pax))
    ~|  "%graph-viz: no subscriber on {<pax>}; ".
        "subscribe to /result/[uid] before poking"
        !!
  :_  this
  :~  [%give %fact ~[pax] %gviz-result !>((run:lib cmd))]
      [%give %kick ~[pax] ~]
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:default path)
    [%result @ ~]  `this
  ==
::
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-arvo   on-arvo:default
++  on-fail   on-fail:default
--
