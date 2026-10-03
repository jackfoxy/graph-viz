---
name: sail-branch-regression-debugger
description: Diagnose, and on request fix, a Graph Viz browser regression where the Sail-generated page behaves correctly on `master` but not on `dev` — reproduce the same interaction on both revisions, trace the broken DOM/CSS/JavaScript contract to the layer that owns it, and repair it there. Not for Hoon compile errors, DOT parsing, layout-engine geometry, or Gall poke/subscription bugs that are not visible in the page.
---

# Sail branch-regression debugger

Graph Viz serves one page whose HTML, CSS and JavaScript are all generated from
Hoon. A regression that only appears on `dev` is almost always a **contract
break between two layers**, not a logic error inside one of them. The job is to
find which contract broke, prove it by reproduction, and fix it in the layer
that owns it.

Use this when a user action on the served page produces the wrong visible
result on `dev` and the right one on `master`. Do not use it for a `|commit`
failure, a DOT parse or layout difference, an SVG geometry question, or an
agent-protocol problem — those have nothing to do with the page contract.

## Ground rules

Treat `master` as the behavioral oracle and `dev` as the regression target.
Derive the shared ancestor rather than assuming one:

```bash
git merge-base master dev
```

**Never change what is checked out.** No `git checkout`, `git switch`,
`git restore`, `git reset`, or copying a file from one branch over another.
Read other revisions with `git show <rev>:<path>`, `git diff`, `git log`, and —
only when a revision must actually run — a detached worktree in a temp
directory that you remove afterwards. The user owns every commit; do not
create one.

## The five boundaries a visible bug can cross

| Layer | Lives in | Owner |
| --- | --- | --- |
| Application Sail + JavaScript | `desk/lib/gviz-web.hoon`, `desk/lib/gviz-clay.hoon`, `desk/app/graph-viz-web.hoon` | Graph Viz |
| Shared shell, config, CSS, runtime | `desk/sur/urui.hoon`, `desk/lib/urui-*.hoon` | urui |
| Synced copies in this repo | the paths in `../urui/bin/sync-manifest.txt` | urui — never edit here |
| Generated page / CSS / app.js and live DOM | compiled output, browser state | derived |
| Node doubles and real Chromium | `tests/browser/doubles/` (urui), `tests/browser/scenarios/` and `tests/browser/real/*.spec.js` (Graph Viz) | mixed |

`desk/web/ace/mode-dot.js` and `desk/web/ace/graph-viz-config.js` are *not* in
the manifest: the DOT mode is the application's. Everything else under
`desk/web/ace/` is synced.

The shared runtime finds the page by fixed names. A moved, renamed or
duplicated Sail node silently breaks one of these:

- shell ids: `#workbench`, `#workspace`, `#splitter`, `#explorer-resizer`,
  `#explorer-collapse`, `#help-panel`, `#close-help`, `#clay-error-modal`,
  `#clay-error-message`, `#close-clay-error`
- pane roles: `data-role="reference" | "editor" | "result"` on
  `#explorer-pane`, `#editor-pane`, `#preview-pane`
- per-kind conventions: `#${kind}-files` view owning `#${view}-tree`,
  `#add-${kind}-ref`, `#browse-${kind}`, `#load-${kind}`, `#save-${kind}`

## Method

### 1. State the behavior and the acceptance criterion

Write down the exact action, input values, starting page state and viewport,
and what "fixed" means observably. The criterion is normally parity with
`master` after the *same* valid action.

### 2. Reproduce on both revisions before reading any diff

A source diff of a 4,700-line refactor will offer a dozen plausible culprits.
Only reproduction narrows it.

```bash
VERE=~/piers/urbit .agents/skills/sail-branch-regression-debugger/scripts/emit-assets.sh master /tmp/gviz/master
VERE=~/piers/urbit .agents/skills/sail-branch-regression-debugger/scripts/emit-assets.sh dev    /tmp/gviz/dev
```

Each call builds a detached worktree in a temp directory, runs *that
revision's own* `tests/browser/real/serve-app.js` (node builtins only, no
`npm install` needed), writes `page.html`, `style.css`, `app.js` and
`ace-config.js`, then removes the worktree. `serve-app.js` hardcodes
`127.0.0.1:4173`, so the two revisions cannot be served at once — emit one,
then the other.

Then drive both asset sets through the identical script. The app only
publishes its editor hooks when the harness flag is present, so set it before
navigation:

```js
await context.addInitScript(() => {
  window.__GVIZ_BROWSER_TEST__ = {acePlatform: 'win', keyboardLayout: 'en-US'};
});
```

Stub the same backend on both sides — `**/apps/graph-viz/render`,
`**/apps/graph-viz/file/*/browse`, `/docs` — as
`tests/browser/real/fixtures/backend.js` does. A render stub must return an
SVG with a real `viewBox`, or the page rejects it with
`Invalid SVG: SVG has no usable view box` and nothing selectable appears.

### 3. Reconcile the report with what `master` actually does

If `master` produces the same result as `dev`, there is no regression: say so,
describe `master`'s real interaction, and stop. Do not invent the behavior the
reporter seems to expect. Report any mismatch between the wording and the
oracle explicitly.

### 4. Capture evidence, not impressions

For the failing step record: console errors and `pageerror`s, failed requests
and their status, any visible alert text (`#error`, `#editor-load-error`), the
active element, `hidden` and ARIA state on the element and **each ancestor**,
its computed `display`, the DOM ancestry itself, and whether the expected
listener ran at all.

`hidden` is routinely defeated by a `display` rule. `#attribute-form` computes
`display: grid` while `hidden` is set; it is invisible only because
`.inspector[hidden] { display: none }` hides its parent. Always check the
ancestor chain before concluding an element "should be visible".

### 5. Compare the three artifacts separately

Diff `page.html`, `style.css` and `app.js` as independent files. Structure,
cascade and behavior fail differently and a combined diff hides which one
moved. Whitespace and quoting differ harmlessly between revisions because the
generators changed; compare meaning, not bytes.

### 6. Trace the contract to its owner

Follow it in one direction: the Sail node and the area or body arm that emits
it → the CSS selectors that style or hide it → the JavaScript query that holds
its handle and the listener registered on it → the shared runtime wiring that
expects it by name. The break is at the first hop where the two sides disagree.

[references/failure-classes.md](references/failure-classes.md) lists the
recurring classes with the evidence that confirms each and the layer that owns
the fix. Read it once the failing hop is identified.

### 7. Narrow history only when it pays

If the trace is already conclusive, skip this. Otherwise use read-only
inspection first — `git log -S'<needle>' --oneline master..dev`,
`git log -p -- desk/lib/gviz-web.hoon` — and reach for a temporary worktree
bisect only when running intermediate commits would materially reduce
uncertainty. Remove the worktree when done.

## Fixing

Only when the user asks for a fix.

- Add the smallest failing test first when practical: a case in
  `tests/browser/scenarios/` if the doubles can show it, otherwise one in
  `tests/browser/real/visual-editing.spec.js` or the matching spec.
- Apply the **smallest** change at the owning layer. Preserve the urui
  extraction: never restore behavior by copying the pre-refactor monolith back
  from `master`.
- If the defect is in shared code, edit `../urui` first, then
  `bin/sync.sh` and `bin/verify-sync.sh --strict` here. Graph-Viz-only
  behavior stays in `desk/lib/gviz-web.hoon`. Never hand-edit a synced file in
  this repo — the next sync discards it.
- Follow `/hoon-style-guide` for every Hoon edit, and update an arm's comment
  when its signature or a non-obvious behavior changes.
- Do not refresh an asset digest or golden unless the output change is
  intentional and you have inspected it.

## Verification

Start with the smallest check that can prove the contract, and widen only as
far as the ownership boundary you touched.

```bash
# a Node scenario, against a compiled app.js
node tests/browser/run-scenarios.js /tmp/gviz/dev/app.js
# one focused Chromium case
VERE=~/piers/urbit npx playwright test --config tests/browser/real/playwright.config.js \
  tests/browser/real/visual-editing.spec.js -g '<case name>'
# the application suite (14 cases)
VERE=~/piers/urbit tests/browser/run-real.sh
# every Hoon file the edit touched — the only local check that catches a syntax error
node ../urui/bin/hoon-parse.js desk/lib/gviz-web.hoon
# only when shared files moved
bin/verify-sync.sh --strict
git diff --check
```

`desk/tests/lib/gviz-web.hoon` recompiles all three assets per arm and is too
slow for `../urui/bin/hoon-test.js`; run it with `-test /=graph-viz=/tests ~`
on a ship, and only when the local harness cannot prove the affected contract.

Review the final diff. State which checks ran, which did not, and why.

## Reporting

Give the observable behavior on each revision, the evidence that identifies the
broken hop, the owning layer, and the minimal fix — or, if the revisions agree,
say plainly that there is no regression and what `master` really does.
