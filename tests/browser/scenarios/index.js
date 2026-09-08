'use strict';

// Scenario inventory.  `shell` ones exercise the reusable application
// shell; `app` ones exercise graph-viz's own surfaces.

const shell = ['shell', 'explorer', 'docs', 'dialogs', 'files', 'session'];
const app = ['render', 'preview-view', 'dot-parse', 'visual-editing'];

module.exports = {shell, app, all: [...shell, ...app]};
