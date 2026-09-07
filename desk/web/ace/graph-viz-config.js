(function configureGraphVizAce(global) {
  'use strict';

  if (!global.ace) {
    throw new Error('Graph Viz could not load the Ace runtime');
  }
  const basePath = '/apps/graph-viz/ace';
  for (const name of ['basePath', 'modePath', 'themePath', 'workerPath']) {
    global.ace.config.set(name, basePath);
  }
  global.ace.config.set('loadWorkerFromBlob', false);
  global.graphVizAceAssets = Object.freeze({
    version: '1.44.0',
    basePath,
    mode: 'ace/mode/dot',
    lightTheme: 'ace/theme/github',
    darkTheme: 'ace/theme/monokai',
    extensions: Object.freeze([
      'ace/ext/beautify',
      'ace/ext/prompt',
      'ace/ext/searchbox',
      'ace/ext/settings_menu'
    ]),
    useWorker: false
  });
})(window);
