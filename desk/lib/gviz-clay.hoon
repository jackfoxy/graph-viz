/+  clay=urui-clay
|%
::
++  storage-root  /data/graph-viz
::
++  file-path
  |=  [raw=@t ext=?(%txt %svg)]
  ^-  (unit path)
  (file-path:clay storage-root raw ~[ext])
::
++  browse-path
  |=  raw=@t
  ^-  (unit path)
  (browse-path:clay storage-root raw)
::
++  browse-text
  |=  [file=? children=(list @ta)]
  ^-  @t
  (en:json:html (browse-json:clay file children))
--
