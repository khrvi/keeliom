#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

for fixture in "$root"/tests/fixtures/*/; do
  name="$(basename "$fixture")"
  expected="$fixture/expected-findings.md"
  [ -f "$expected" ] || continue

  actual="$(mktemp)"
  echo "== $name =="
  claude -p "Read $fixture/CHECK.md and run it on the project in $fixture. Output one line per finding in the form 'CHECK-ID: file: section: problem'. Do not modify any file." > "$actual"

  while IFS= read -r id; do
    if grep -q "$id" "$actual"; then
      echo "ok: $id"
    else
      echo "missing: $id"
      fail=1
    fi
  done < <(grep -oE '\b[MS][0-9]+\b' "$expected" | sort -u)

  rm -f "$actual"
done

exit "$fail"
