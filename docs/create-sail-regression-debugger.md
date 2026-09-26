# Create a Sail branch-regression debugging skill

Use `$skill-creator` to create a project-local skill named
`sail-branch-regression-debugger` under
`.agents/skills/sail-branch-regression-debugger/`.

Do not debug or patch the application until the skill has been created and
validated. Do not commit anything; the user owns Git commits.

## Context to inspect

Before designing the skill, read:

- the repository's `AGENTS.md` instructions, including `.codex/AGENTS.md`;
- the existing `$sail-markup` and `$hoon-style-guide` skills;
- `README.md`, especially the browser editor and testing sections;
- `~/gitrepos/urui/README.md`;
- all directly relevant records in `~/gitrepos/urui/docs/`, beginning with
  `w3.6-page-diff.md`, `w4.3-runtime-extraction.md`, `remaining-work-plan.md`,
  and `session-handoff.md`;
- the `master`, `dev`, and merge-base versions of relevant Graph Viz files.

Treat `master` as the behavioral oracle and `dev` as the regression target.
The branches currently share `master` as their merge base, but the skill must
derive this with Git instead of assuming it. Preserve the checked-out branch
and all user changes. Prefer `git show <revision>:<path>` and read-only diffs;
never switch branches, reset files, or overwrite one branch with the other.

## Skill scope

The skill should diagnose and, when the user asks, fix UI regressions where a
Sail-generated Graph Viz page works on `master` but fails on `dev`. It must
understand that the visible page crosses several boundaries:

1. application-owned Sail and JavaScript in `desk/lib/gviz-web.hoon`;
2. the shared urui shell, config, CSS, and JavaScript libraries;
3. synced copies in Graph Viz, whose source of truth is `~/gitrepos/urui`;
4. generated HTML/CSS/JavaScript and browser runtime state;
5. Node browser doubles and real Playwright behavior.

Keep the skill specific to evidence-driven Sail/browser regressions. Do not
turn the first bug below into a universal diagnosis or prescribe a fix before
reproduction proves the cause. The skill description must be discriminating
enough not to activate for ordinary Hoon, DOT, layout-engine, or Gall protocol
bugs.

## Required debugging method

Encode a concise workflow that makes the agent:

- restate the exact observable behavior and acceptance criterion;
- reproduce the same user action, input values, page state, and viewport on
  `master` and `dev` before trusting a source diff;
- reconcile ambiguous bug wording with the actual `master` behavior and report
  any mismatch instead of inventing intended behavior;
- capture browser console errors, failed requests, visible alerts, focus,
  `hidden`/ARIA state, relevant DOM ancestry, computed display, and event
  effects;
- compare emitted page structure, CSS, and JavaScript as separate artifacts;
- trace a broken DOM contract from Sail area/body placement through CSS
  selectors and JavaScript queries/listeners into shared urui runtime wiring;
- narrow the first bad commit when useful, using read-only history inspection
  or a safe temporary worktree only when it will materially reduce uncertainty;
- add the smallest failing regression test before the fix when practical;
- apply the smallest source fix at the owning layer, preserving the urui
  extraction rather than copying the old monolith back from `master`;
- update shared code in `~/gitrepos/urui` first and use the documented sync
  workflow when the defect is shared; keep Graph Viz-only behavior in Graph
  Viz;
- follow `$hoon-style-guide` for every Hoon edit and update an arm's comment
  when its signature or non-obvious behavior changes;
- avoid digest/golden updates unless the changed output is intentional and has
  been inspected.

The workflow should distinguish at least these failure classes: missing or
moved Sail nodes, duplicate IDs, a changed `hidden` relationship, CSS selector
or layout regressions, stale/null JavaScript element handles, listener wiring,
event propagation/default-submit behavior, initialization ordering, shared
runtime ownership, and test-harness-only failures.

## Verification guidance

Teach the skill to choose the smallest useful checks first, then expand in
proportion to the touched ownership boundary. Reference the repository's real
commands rather than inventing new infrastructure:

- focused Node scenario coverage under `tests/browser/`;
- a focused case in `tests/browser/real/visual-editing.spec.js` when the bug
  requires a browser;
- `VERE=~/piers/urbit tests/browser/run-real.sh` or the focused Playwright
  equivalent for Graph Viz;
- `~/gitrepos/urui/bin/hoon-parse.js` for every touched Hoon file;
- `bin/verify-sync.sh --strict` when shared urui files are involved;
- `git diff --check` and a review of the final diff;
- ship desk tests only when the local harness cannot prove the affected
  contract.

Do not require the complete test matrix for every one-line fix. State which
checks were run, which were not, and why.

## First forward-test case

After creating and validating the skill, use this report as its first realistic
forward test in a temporary or otherwise isolated diagnostic pass:

> On `master`, the Add node interaction works. On `dev`, clicking **Add node**
> does not reveal the node attributes pane. The render area instead shows
> **Node names must contain 1 to 80 characters**.

First establish the exact successful `master` interaction, including whether a
node name or a rendered-node selection is required. Then reproduce precisely
that interaction on `dev`. The acceptance criterion is behavioral parity with
`master`: the intended node-attribute UI becomes visible after the same valid
action, and the node-name validation message does not appear spuriously.

The forward test should evaluate whether the skill finds credible evidence and
proposes a minimal owning-layer fix. Do not make the application fix as part of
skill creation unless the user separately authorizes implementation.

## Deliverables

Create only the resources justified by the workflow:

- `.agents/skills/sail-branch-regression-debugger/SKILL.md`;
- `.agents/skills/sail-branch-regression-debugger/agents/openai.yaml` if the
  initializer creates it;
- focused references or scripts only if they provide reusable value that does
  not belong in `SKILL.md`.

Validate the finished skill with the bundled skill validator. Report the files
created, validation result, the forward-test finding at diagnosis level only,
and any checks that still require the user's environment. Do not commit.
