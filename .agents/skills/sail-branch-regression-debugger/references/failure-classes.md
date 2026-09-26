# Failure classes

Each class names the evidence that confirms it and the layer that owns the
fix. Confirm before fixing: several classes share a symptom.

## Missing or moved Sail node

The runtime binds elements by name at boot. A node that moved out of the area
whose arm emits it, or lost an id, leaves a `null` handle and the feature does
nothing — often with no console error, because the query result is only used
later.

Confirm: the id is absent from `page.html` on `dev` and present on `master`,
or present but under a different ancestor.
Owner: the area/body arm in `desk/lib/gviz-web.hoon` if the node is the
application's; `desk/lib/urui-shell.hoon` in urui if it is part of the shared
frame.

## Duplicate id

`document.querySelector` answers the first match. A node duplicated across two
area arms makes listeners land on the wrong copy, and the visible one never
responds.

Confirm: more than one occurrence of `id="x"` in `page.html`.
Owner: whichever arm emits the duplicate; usually the consumer.

## Changed `hidden` relationship

Visibility in this page is a chain, not a flag. An element may carry `hidden`
and still compute a non-`none` `display`; it is invisible only because an
ancestor's `[hidden]` rule hides it. Moving the element out of that ancestor,
or dropping the ancestor's rule, makes it appear — or the reverse.

Confirm: computed `display` of the element and of every ancestor, plus which
`[hidden]` rules exist in `style.css` for those selectors.
Owner: the CSS section that carries the `[hidden]` rule, plus the Sail arm
that establishes the ancestry.

## CSS selector or layout regression

The stylesheet is composed from ordered urui sections plus the application's
own rules; base controls precede component overrides. Regrouping changes
precedence even when every rule survives.

Confirm: the rule exists in both `style.css` files but loses the cascade on
`dev`, or its selector no longer matches the emitted markup.
Owner: `desk/lib/urui-css.hoon` for a shared section, the application CSS arm
for Graph Viz rules; if only the *order* changed, the `compose` call site.

## Stale or null element handle

A handle captured at module scope before the node exists, or kept across a
re-render that replaced the node, points at a detached element. Writes to it
succeed and change nothing visible.

Confirm: the handle is non-`null` but `document.contains(handle)` is false, or
the query runs before the markup it targets is inserted.
Owner: the JavaScript arm that captures the handle.

## Listener wiring

The listener was never registered — the boot arm returned early, the control
moved out of the block that wires it, or the runtime's `wire()` was not called.

Confirm: the control exists, the handler function exists, and the action has
no effect; re-registering it by hand in the console restores the behavior.
Owner: the boot arm, or `runtime.wire()` in `desk/lib/urui-js.hoon`.

## Event propagation and default submit

A control inside a `<form>` without `type="button"` submits and reloads. A
capture-phase shortcut dispatcher can claim a key before the control sees it.
`Enter` in a text input may be bound to an action explicitly.

Confirm: a navigation or reload occurs, or the handler runs with a different
event target than expected.
Owner: the Sail attribute (`type "button"`), or the shortcut registration.

## Initialization ordering

The browser bundle order is load-bearing: config, `core:urui-js`, mode code,
then the consumer tail that calls `window.urui.boot(...)`. Reading
`window.URUI_CONFIG` or a runtime accessor before its emitter ran yields
`undefined` and a silent no-op.

Confirm: the failing read happens earlier in `app.js` than the write, or an
Ace asset 404s and `#editor-load-error` becomes a visible alert.
Owner: the bundle composition in `desk/lib/gviz-web.hoon`, or the boot hook
order.

## Shared runtime ownership

The behavior was moved into `urui-js`/`urui-shell` and the consumer kept a
stale alias, or the consumer still implements a behavior the runtime now also
performs, so the two fight.

Confirm: the same effect is produced in both `desk/lib/urui-js.hoon` and
`desk/lib/gviz-web.hoon`, or the consumer alias no longer resolves.
Owner: urui, edited in `../urui` and synced. Delete the consumer's copy rather
than reimplementing.

## Test-harness-only failure

The page is correct and the harness is not: a double lacks a method the new
runtime calls, a stub returns a body the page rejects (an SVG with no
`viewBox`), a spec asserts a pre-refactor id, or `window.__GVIZ_BROWSER_TEST__`
was never set so the editor hooks are absent.

Confirm: the same interaction succeeds in a real browser against the compiled
assets but fails under the harness.
Owner: `tests/browser/doubles/` is urui's — fix it in `../urui` and sync;
scenarios and specs are Graph Viz's.
