#!/usr/bin/env bash
#
# check.sh — offline reference validation + golden regeneration
# for the %graph-viz desk.  Lives outside the desk (dev tool).
#
# Usage:
#   ./check.sh verify   compare pipeline output against reference
#                       graphviz: ranks must match dot -Tplain
#                       exactly; within-rank pair order must agree
#                       >= ORDER_THRESHOLD %; coordinate spread
#                       reported as information
#   ./check.sh regen    regenerate desk/tests/svg/*.svg goldens
#                       and print the diag tuples for
#                       tests/lib/e2e.hoon
#
# Requirements: a vere binary (VERE env or default below), python3,
# and graphviz `dot` on PATH for verify.
#
# How it works: desk sources are compiled with `vere eval` by
# emulating ford imports (each /lib//sur file becomes an
# =+  ^=  face  binding; corpus files become ''' cords with tabs
# converted, which is whitespace-equivalent for DOT).
#
set -euo pipefail
cd "$(dirname "$0")"

VERE="${VERE:-$HOME/piers/vere-v4.5-linux-x86_64}"
DESK=desk
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

GOLDEN_FILES="hello unix cluster fsm unicode"
VERIFY_FILES="unix cluster fsm shells world"
ORDER_THRESHOLD=65

emit_dot() {
  echo "=+  ^=  $2"
  echo "'''"
  sed -e 's/\t/  /g' "$DESK/tests/dot/$1.dot"
  echo "'''"
}

mklibs() {
  echo '=+  ^=  ast';        cat $DESK/sur/ast.hoon
  echo '=+  ^=  print';      grep -v '^/-' $DESK/lib/print.hoon
  echo '=+  ^=  parse'; grep -v '^/[-+]' $DESK/lib/parse.hoon
  echo '=+  ^=  attr';  grep -v '^/[-+]' $DESK/lib/attr.hoon
  echo '=+  ^=  acyc';  grep -v '^/[-+]' $DESK/lib/acyc.hoon
  echo '=+  ^=  rank';  grep -v '^/[-+]' $DESK/lib/rank.hoon
  echo '=+  ^=  order'; grep -v '^/[-+]' $DESK/lib/order.hoon
  echo '=+  ^=  metrics'; cat $DESK/lib/metrics.hoon
  echo '=+  ^=  coord'; grep -v '^/[-+]' $DESK/lib/coord.hoon
  echo '=+  ^=  gg';         cat $DESK/sur/graph.hoon
  echo '=+  ^=  route'; grep -v '^/[-+]' $DESK/lib/route.hoon
  echo '=+  ^=  svg';   grep -v '^/[-+]' $DESK/lib/svg.hoon
  echo '=+  ^=  gviz';       grep -v '^/-' $DESK/sur/gviz.hoon
  echo '=+  ^=  lib';        grep -v '^/[-+]' $DESK/lib/gviz.hoon
}

render_one() {  # $1 = corpus base name; writes $WORK/$1.svg + $WORK/$1.diag
  { mklibs
    emit_dot "$1" src
    cat <<'EOF'
=/  r  (run:lib [%render 0v0 [%dot %svg ~ ~ %.n %.n %.y %.n] src])
?>  ?=(%svg -.r)
[diag.r svg.r]
EOF
  } > "$WORK/$1.hoon"
  "$VERE" eval < "$WORK/$1.hoon" 2>&1 \
    | grep -vE 'loom|lite|eval \(run\)|^$' > "$WORK/$1.out"
  python3 - "$WORK/$1.out" "$WORK/$1.svg" "$WORK/$1.diag" <<'PYEOF'
import re, sys
raw = re.sub(r'\x1b\[[0-9;]*m', '', open(sys.argv[1]).read()).strip()
d = re.search(r'nodes=([\d.]+) edges=([\d.]+) clusters=([\d.]+) '
              r'nrank=([\d.]+) virtuals=([\d.]+) crossings=([\d.]+)', raw)
assert d, raw[:200]
open(sys.argv[3], 'w').write(' '.join(x.replace('.', '') for x in d.groups()))
i, j = raw.find("'"), raw.rfind("'")
svg = raw[i+1:j].replace('\\0a', '\n').replace("\\'", "'").replace('\\\\', '\\')
assert svg.startswith('<?xml'), svg[:40]
open(sys.argv[2], 'w').write(svg)
PYEOF
}

do_regen() {
  mkdir -p "$DESK/tests/svg"
  for f in $GOLDEN_FILES; do
    echo "rendering $f..."
    render_one "$f"
    cp "$WORK/$f.svg" "$DESK/tests/svg/$f.svg"
  done
  echo
  echo "diag tuples for tests/lib/e2e.hoon:"
  for f in $GOLDEN_FILES $VERIFY_FILES; do
    [ -f "$WORK/$f.diag" ] || render_one "$f"
    echo "  $f: [$(cat "$WORK/$f.diag" | tr ' ' ' ')]"
  done
  echo
  echo "goldens written to $DESK/tests/svg/ — commit and re-run tests."
}

struct_one() {  # $1 = corpus base name; writes $WORK/$1.struct
  { mklibs
    emit_dot "$1" src
    cat <<'EOF'
=/  r  (parse:parse src)
?>  ?=(%& -.r)
=/  res  (resolve:attr p.r ~)
=/  g  (rank-graph:rank res)
=/  o  (order-graph:order res g)
%+  turn  (gulf 0 (dec (lent nodes.res)))
|=  i=@ud
[name:(snag i nodes.res) (~(got by ranks.g) i) (~(got by pos.o) i)]
EOF
  } > "$WORK/$1.shoon"
  "$VERE" eval < "$WORK/$1.shoon" 2>&1 \
    | grep -vE 'loom|lite|eval \(run\)|^$' > "$WORK/$1.struct"
}

do_verify() {
  command -v dot >/dev/null || { echo "graphviz dot not on PATH"; exit 1; }
  fail=0
  for f in $VERIFY_FILES; do
    echo "== $f"
    struct_one "$f"
    python3 - "$WORK/$f.struct" "$DESK/tests/dot/$f.dot" "$ORDER_THRESHOLD" <<'PYEOF2' || fail=1
import re, subprocess, sys
structfile, dotfile, threshold = sys.argv[1], sys.argv[2], int(sys.argv[3])

raw = re.sub(r'\x1b\[[0-9;]*m', '', open(structfile).read()).replace('\n', ' ')
ours = {}
for m in re.finditer(r"\['((?:[^'\\]|\\.)*)' ([\d.]+) ([\d.]+)\]", raw):
  name = m.group(1).replace("\\'", "'")
  ours[name] = (int(m.group(2).replace('.', '')),
                int(m.group(3).replace('.', '')))

out = subprocess.run(['dot', '-Tplain', dotfile],
                     capture_output=True, text=True).stdout
rankdir_lr = 'rankdir=LR' in open(dotfile).read()
ref = {}
for line in out.splitlines():
  if line.startswith('node '):
    p = re.findall(r'"[^"]*"|\S+', line)
    x, y = float(p[2]), float(p[3])
    ref[p[1].strip('"')] = (x, -y) if not rankdir_lr else (y, x)
# ref[name] = (within-coord, rank-coord ascending in rank order)

levels = sorted({r for _, r in ref.values()})
ref_rank = {n: levels.index(r) for n, (w, r) in ref.items()}

diffs = {n: (ours[n][0], ref_rank[n])
         for n in ref_rank if ours.get(n, (None,))[0] != ref_rank[n]}
if diffs:
  print(f'  RANK MISMATCH: {diffs}')
  sys.exit(1)
print(f'  ranks: exact match ({len(ref_rank)} nodes)')

total = agree = 0
for r in set(ref_rank.values()):
  row_our = sorted([n for n in ref_rank if ref_rank[n] == r],
                   key=lambda n: ours[n][1])
  row_ref = sorted([n for n in ref_rank if ref_rank[n] == r],
                   key=lambda n: ref[n][0])
  for i in range(len(row_our)):
    for j in range(i + 1, len(row_our)):
      total += 1
      if row_ref.index(row_our[i]) < row_ref.index(row_our[j]):
        agree += 1
pct = 100 * agree / total if total else 100
print(f'  order: {agree}/{total} pairs agree = {pct:.0f}%')
open(structfile + '.pairs', 'w').write(f'{agree} {total}')
PYEOF2
  done
  # aggregate within-rank order agreement (per-file counts are noisy
  # on small graphs where both layouts are equally optimal)
  agree=0; total=0
  for f in $VERIFY_FILES; do
    read a t < "$WORK/$f.struct.pairs" || true
    agree=$((agree + a)); total=$((total + t))
  done
  pct=$((100 * agree / total))
  echo "aggregate order agreement: $agree/$total = $pct% (threshold $ORDER_THRESHOLD%)"
  if [ $pct -lt $ORDER_THRESHOLD ]; then fail=1; fi
  [ $fail = 0 ] && echo "ALL CHECKS PASSED" || { echo "FAILURES"; exit 1; }
}

case "${1:-verify}" in
  regen)  do_regen ;;
  verify) do_verify ;;
  *) echo "usage: $0 [verify|regen]"; exit 1 ;;
esac
