|%
::
+$  version
  [major=@ud minor=@ud patch=@ud]
::
+$  glob  (map path mime)
::
+$  url  cord
::
+$  glob-reference
  [hash=@uvH location=glob-location]
::
+$  glob-location
  $%  [%http =url]
      [%ames =ship]
  ==
::
+$  href
  $%  [%glob base=term =glob-reference]
      [%site =path]
  ==
::
+$  chad
  $~  [%install ~]
  $%  [%glob =glob]
      [%site ~]
      [%install ~]
      [%suspend glob=(unit glob)]
      [%hung err=cord]
  ==
::
+$  charge
  $:  =docket
      =chad
  ==
::
+$  clause
  $%  [%title title=@t]
      [%info info=@t]
      [%color color=@ux]
      [%glob-http url=cord hash=@uvH]
      [%glob-ames =ship hash=@uvH]
      [%image =url]
      [%site =path]
      [%base base=term]
      [%version =version]
      [%website website=url]
      [%license license=cord]
  ==
::
+$  docket
  $:  %1
      title=@t
      info=@t
      color=@ux
      =href
      image=(unit url)
      =version
      website=url
      license=cord
  ==
::
+$  charge-update
  $%  [%initial initial=(map desk charge)]
      [%add-charge =desk =charge]
      [%del-charge =desk]
  ==
--
