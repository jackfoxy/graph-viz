#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
"$ROOT/bin/verify-sync.sh" --quiet || true
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
node "$ROOT/tests/browser/run-scenarios.js" "$APP_JS"
