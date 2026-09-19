#!/usr/bin/env bash
#  emit-assets.sh REVISION OUTDIR
#
#  Compile the served page, CSS and JavaScript of one git revision into
#  OUTDIR, without touching the checked-out branch or the working tree.
#
#  A detached worktree is created under a temp directory, that revision's
#  own tests/browser/real/serve-app.js is started there (it knows its own
#  ford bindings and needs only node builtins), the assets are fetched,
#  and the worktree is removed.  Writes page.html, style.css (the page's
#  <style> block) and app.js; ace-config.js when the revision serves one.
#
#  serve-app.js hardcodes 127.0.0.1:4173, so revisions must be emitted one
#  at a time.  Needs VERE pointing at a vere that supports `eval`.
set -euo pipefail

REVISION="${1:?usage: emit-assets.sh REVISION OUTDIR}"
OUTDIR="${2:?usage: emit-assets.sh REVISION OUTDIR}"
ROOT="$(git rev-parse --show-toplevel)"
BASE="http://127.0.0.1:4173/apps/graph-viz"

SHA="$(git -C "$ROOT" rev-parse --verify "${REVISION}^{commit}")"
mkdir -p "$OUTDIR"
TREE="$(mktemp -d)"
rmdir "$TREE"

cleanup() {
  [[ -n "${SERVER:-}" ]] && kill "$SERVER" 2>/dev/null || true
  git -C "$ROOT" worktree remove --force "$TREE" 2>/dev/null || true
  rm -rf "$TREE"
}
trap cleanup EXIT

git -C "$ROOT" worktree add --detach --quiet "$TREE" "$SHA"

( cd "$TREE/tests/browser/real" && exec node serve-app.js ) \
  >"$OUTDIR/serve-app.log" 2>&1 &
SERVER=$!

for _ in $(seq 1 180); do
  if curl --fail --silent --output /dev/null "$BASE/"; then break; fi
  kill -0 "$SERVER" 2>/dev/null || { cat "$OUTDIR/serve-app.log" >&2; exit 1; }
  sleep 1
done

curl --fail --silent --show-error "$BASE/"       -o "$OUTDIR/page.html"
curl --fail --silent --show-error "$BASE/app.js" -o "$OUTDIR/app.js"
curl --fail --silent --output "$OUTDIR/ace-config.js" \
  "$BASE/ace/graph-viz-config.js" || rm -f "$OUTDIR/ace-config.js"

#  the page embeds the stylesheet; split it out so CSS diffs read alone
node -e '
  const fs = require("node:fs");
  const [page, out] = process.argv.slice(1);
  const html = fs.readFileSync(page, "utf8");
  const match = html.match(/<style[^>]*>([\s\S]*?)<\/style>/);
  fs.writeFileSync(out, match ? match[1] : "");
' "$OUTDIR/page.html" "$OUTDIR/style.css"

printf '%s\t%s\n' "$SHA" "$REVISION" >"$OUTDIR/revision.txt"
wc -c "$OUTDIR"/page.html "$OUTDIR"/style.css "$OUTDIR"/app.js
