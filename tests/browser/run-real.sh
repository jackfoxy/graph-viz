#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
if [[ -x "$ROOT/../urui/bin/verify-sync.sh" ]]; then
  "$ROOT/../urui/bin/verify-sync.sh" --dest "$ROOT" --quiet || true
else
  echo 'urui checkout not found at ../urui — clone it beside this repo to check sync status' >&2
fi

cd "$ROOT"
exec ./node_modules/.bin/playwright test \
  --config tests/browser/real/playwright.config.js
