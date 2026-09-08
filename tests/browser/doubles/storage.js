'use strict';

const SESSION_KEY = 'graph-viz.session.v1';

const defaultSession = {
  version: 1,
  source: 'digraph saved { Alpha -> Beta }',
  paneWidth: 62,
  view: {scale: 2, x: 20, y: 30},
  preferences: {autoRender: false}
};

// localStorage double backed by a plain Map, seeded with a session record.

function createStorage(session = defaultSession) {
  const saved = new Map();
  if (session) saved.set(SESSION_KEY, JSON.stringify(session));
  const localStorage = {
    getItem: (key) => saved.get(key) ?? null,
    setItem: (key, value) => saved.set(key, value)
  };
  return {saved, localStorage};
}

module.exports = {createStorage, defaultSession, SESSION_KEY};
