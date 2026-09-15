::  urui-config: unit tests.
::
/-  urui
/+  *test, config=urui-config
|%
::
++  app
  ^-  app-config:urui
  :*  :*  name=%probe
          title='Probe "App"'
          base='/apps/probe'
          storage-key='probe.session.v2'
          storage-version=2
      ==
      :~  :*  name=%text
              label='Text'
              untitled='Untitled'
              ext=%txt
              leaf=%txt
              mime='text/plain'
              tabs=&
              refs=|
          ==
      ==
      :*  transport=%body
          path-header=~
          flag-header=`'x-overwrite'
          browse='/browse'
          load='/load'
          save='/save'
          delete='/delete'
      ==
      :*  render-debounce=350
          save-debounce=150
          min-explorer=180
          divider=10
          pane-min=25
          pane-max=70
          narrow=760
          max-source=262.144
      ==
      ~[['textTabs' %urui %tabs `%text]]
      ~[['Ctrl-S' 'save' %editor]]
      ~[[%ready 'Ready']]
      docs-root=`'/docs/probe/'
      share-param=`[name='text' max=12.288 param-max=16.384]
      ~[[%text-files 'Text Files']]
      :*  base='/apps/probe/ace'
          global='probeAce'
          version='1.44.0'
          mode='ace/mode/text'
          light='ace/theme/light'
          dark='ace/theme/dark'
          exts=~['ace/ext/searchbox']
          use-worker=|
      ==
  ==
::
++  source  (trip (emit:config app))
::
++  has
  |=  value=tape
  ^-  ?
  ?=(^ (find value source))
::
++  test-config-emits-valid-assignment
  ;:  weld
    (expect !>((has (trip 'window.URUI_CONFIG = {'))))
    (expect !>((has "};\0a")))
    (expect !>((has "\\\"App\\\"")))
  ==
::
++  test-config-emits-app-identity
  ;:  weld
    (expect !>((has "\"appId\"")))
    (expect !>((has "\"name\":\"probe\"")))
    (expect !>((has "\"storageKey\":\"probe.session.v2\"")))
    (expect !>((has "\"storageVersion\":2")))
  ==
::
++  test-config-emits-document-kinds
  ;:  weld
    (expect !>((has (trip '\22kinds\22:[{'))))
    (expect !>((has "\"ext\":\"txt\"")))
    (expect !>((has "\"leaf\":\"txt\"")))
    (expect !>((has "\"tabs\":true")))
    (expect !>((has "\"refs\":false")))
  ==
::
++  test-config-emits-endpoints
  ;:  weld
    (expect !>((has "\"transport\":\"body\"")))
    (expect !>((has "\"pathHeader\":null")))
    (expect !>((has "\"flagHeader\":\"x-overwrite\"")))
    (expect !>((has "\"delete\":\"/delete\"")))
  ==
::
++  test-config-emits-limits
  ;:  weld
    (expect !>((has "\"renderDebounce\":350")))
    (expect !>((has "\"paneMin\":25")))
    (expect !>((has "\"narrow\":760")))
    (expect !>((has "\"maxSource\":262144")))
  ==
::
++  test-config-emits-session-slots
  ;:  weld
    (expect !>((has "\"key\":\"textTabs\"")))
    (expect !>((has "\"owner\":\"urui\"")))
    (expect !>((has "\"shape\":\"tabs\"")))
    (expect !>((has "\"kind\":\"text\"")))
  ==
::
++  test-config-emits-shortcuts-and-statuses
  ;:  weld
    (expect !>((has "\"binding\":\"Ctrl-S\"")))
    (expect !>((has "\"command\":\"save\"")))
    (expect !>((has "\"when\":\"editor\"")))
    (expect !>((has (trip '\22statuses\22:[{'))))
  ==
::
++  test-config-emits-optional-values
  ;:  weld
    (expect !>((has "\"docsRoot\":\"/docs/probe/\"")))
    (expect !>((has (trip '\22shareParam\22:{'))))
    (expect !>((has "\"paramMax\":16384")))
    (expect !>((has (trip '\22permanentViews\22:[{'))))
  ==
::
++  test-config-emits-ace-settings
  ;:  weld
    (expect !>((has (trip '\22ace\22:{'))))
    (expect !>((has "\"global\":\"probeAce\"")))
    (expect !>((has "\"extensions\":[\"ace/ext/searchbox\"]")))
    (expect !>((has "\"useWorker\":false")))
  ==
--
