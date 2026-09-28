'use strict';

// Shared Playwright double for the %graph-viz HTTP surface.
//
// `installBackend(page, options)` installs one route per option present, so
// a spec declares only the endpoints it depends on.  Both document stores
// share one json file wire, `/apps/graph-viz/files`; its options are:
//   * browse: `true` for an empty root, or a function of `{scope}`
//     returning file paths, each a segment array ending in its mark
//   * dotLoad, svgLoad: a function of the joined path (`left/txt`)
//     returning the text, a literal text, or a fulfillment object
//   * save: a function of `{kind, path, body, overwrite, base, request}`;
//     returning `{status: 409}` answers `exists`, any other failing
//     status an `internal` error, and anything else success
// `render` and `docs` keep their own routes.

// A handler returns DEFER to keep the route for itself, e.g. to park it.
const DEFER = Symbol('backend.defer');

function fulfillment(result, base) {
  if (result === undefined || result === null) return base;
  if (typeof result === 'string') return {...base, body: result};
  return {...base, ...result};
}

async function call(handler, argument) {
  return typeof handler === 'function' ? await handler(argument) : undefined;
}

//  what the agent would hash; any stable token will do here
function hashOf(text) {
  let hash = 0;
  for (const char of String(text)) {
    hash = (hash * 31 + char.codePointAt(0)) | 0;
  }
  return `0v${(hash >>> 0).toString(32)}`;
}

function json(status, body) {
  return {status, contentType: 'application/json', body: JSON.stringify(body)};
}

function failure(status, code, message) {
  return json(status, {
    ok: false,
    error: {code, message, retryable: false, details: []}
  });
}

async function installBackend(page, options = {}) {
  const {browse, render, dotLoad, svgLoad, save, docs} = options;
  const wired = [browse, dotLoad, svgLoad, save].some((handler) => {
    return handler !== undefined;
  });

  if (wired) {
    await page.route('**/apps/graph-viz/files', async (route) => {
      const request = route.request();
      const body = JSON.parse(request.postData() || '{}');
      const path = Array.isArray(body.path) ? body.path : [];
      const joined = path.join('/');
      const kind = path.at(-1) === 'txt' ? 'dot' : 'svg';
      if (body.op === 'browse') {
        const found = typeof browse === 'function'
          ? await browse({scope: body.scope, request}) : [];
        const entries = (found || []).map((entry) => {
          return Array.isArray(entry) ? {path: entry, kind: 'file'} : entry;
        });
        return route.fulfill(json(200, {ok: true, entries}));
      }
      if (body.op === 'load') {
        const handler = kind === 'dot' ? dotLoad : svgLoad;
        const result = typeof handler === 'function'
          ? await handler(joined, request) : handler;
        if (result === undefined) {
          return route.fulfill(failure(404, 'not-found', `${joined} not found`));
        }
        if (typeof result !== 'string') return route.fulfill(result);
        return route.fulfill(json(200, {
          ok: true, text: result, hash: hashOf(result)
        }));
      }
      if (body.op === 'save') {
        const result = await call(save, {
          kind, path: joined, body: body.text, overwrite: body.overwrite,
          base: body.base, request
        });
        if (result?.status === 409) {
          return route.fulfill(failure(409, 'exists', `${joined} exists`));
        }
        if (result?.status >= 400) {
          return route.fulfill(failure(
            result.status, 'internal', String(result.body || 'failed')
          ));
        }
        return route.fulfill(json(200, {ok: true, hash: hashOf(body.text)}));
      }
      return route.fulfill(json(200, {ok: true}));
    });
  }

  if (render !== undefined) {
    await page.route('**/apps/graph-viz/render', async (route) => {
      const request = route.request();
      const source = request.postData() || '';
      const result = typeof render === 'function'
        ? await render(source, request, route)
        : render;
      if (result === DEFER) return;
      await route.fulfill(fulfillment(result, {
        status: 200,
        contentType: 'image/svg+xml',
        body: ''
      }));
    });
  }

  if (docs !== undefined) {
    const {
      index = '<!doctype html><title>Graph Viz Docs</title>',
      pagesGlob = '**/docs/**',
      pages = '<!doctype html><title>Graph Viz / Users Guide</title>'
    } = docs === true ? {} : docs;
    await page.route('**/docs', async (route) => {
      await route.fulfill({status: 200, contentType: 'text/html', body: index});
    });
    await page.route(pagesGlob, async (route) => {
      await route.fulfill({status: 200, contentType: 'text/html', body: pages});
    });
  }
}

module.exports = {installBackend, DEFER};
