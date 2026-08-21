#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

cd "$ROOT"
exec ./node_modules/.bin/playwright test \
  --config tests/browser/real/playwright.config.js
