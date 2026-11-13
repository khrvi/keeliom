#!/usr/bin/env bash
# Runs the plugin's CHECK.md against every fixture through the claude CLI.
# Usage: bash tests/run.sh [fixture]
set -uo pipefail

root="$(cd "$(dirname "$0")/.." && pwd -P)"
fail=0
outdir=$(mktemp -d)
trap 'rm -rf "$outdir"' EXIT

if [ $# -gt 1 ]; then
  echo "usage: bash tests/run.sh [fixture]" >&2
  exit 2
fi

fixtures=()
if [ $# -eq 1 ]; then
  if [ -d "$root/tests/fixtures/$1" ]; then
    fixtures=("$root/tests/fixtures/$1")
  else
    echo "no such fixture: $1" >&2
    exit 2
  fi
else
  for dir in "$root"/tests/fixtures/*/; do
    fixtures+=("${dir%/}")
  done
fi

for fixture in "${fixtures[@]}"; do
  name=$(basename "$fixture")
  expected="$fixture/expected-findings.md"
  [ -f "$expected" ] || continue

  echo "== $name =="
  actual="$outdir/$name.out"
  if ! claude -p "Read $root/plugins/keeliom/rules/RULES.md and $root/plugins/keeliom/rules/CHECK.md. The installed plugin version is 0.4.0. Run the checks on the project in $fixture. Use the Output format in CHECK.md. Do not create or modify any file, including STATUS.md." >"$actual" 2>&1; then
    echo "FAIL: claude exited nonzero"
    fail=1
  fi

  if grep -qx -- '- none' "$expected"; then
    if grep -qE '^[[:space:]*]*Project OK[[:space:]*]*$' "$actual" &&
      ! grep -qE '\[K[0-9]+\] (error|warn|unverifiable):' "$actual"; then
      echo "ok: none"
    else
      echo "FAIL: expected no findings"
      sed 's/^/    /' "$actual" | head -40
      fail=1
    fi
  else
    ids=$(grep -oE '\bK[0-9]+\b' "$expected" | sort -u)
    if [ -z "$ids" ] && [ -z "$(sed -n 's/^- line: //p' "$expected")" ]; then
      echo "FAIL: no expectation in $expected"
      fail=1
    fi
    while IFS= read -r id; do
      [ -n "$id" ] || continue
      if grep -qF "[$id]" "$actual"; then
        echo "ok: $id"
      else
        echo "FAIL: missing $id"
        sed 's/^/    /' "$actual" | head -40
        fail=1
      fi
    done <<<"$ids"
  fi

  while IFS= read -r line; do
    [ -n "$line" ] || continue
    if grep -qF -- "$line" "$actual"; then
      echo "ok: line present"
    else
      echo "FAIL: missing line: $line"
      sed 's/^/    /' "$actual" | head -40
      fail=1
    fi
  done < <(sed -n 's/^- line: //p' "$expected")
done

exit "$fail"
