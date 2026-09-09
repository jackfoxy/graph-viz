#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
if [[ -x "$ROOT/../urui/bin/verify-sync.sh" ]]; then
  "$ROOT/../urui/bin/verify-sync.sh" --dest "$ROOT" --quiet || true
else
  echo 'urui checkout not found at ../urui — clone it beside this repo to check sync status' >&2
fi
APP_JS="${1:-}"
WORK=""

if [[ -z "$APP_JS" ]]; then
  BASE_URL="${GVIZ_URL:-http://localhost:8080}"
  WORK="$(mktemp -d)"
  trap 'rm -rf "$WORK"' EXIT
  APP_JS="$WORK/app.js"
  curl --fail --silent --show-error \
    "$BASE_URL/apps/graph-viz/app.js" \
    --output "$APP_JS"
fi

node --check "$APP_JS"
node "$ROOT/tests/browser/gviz-web.test.js" "$APP_JS"
