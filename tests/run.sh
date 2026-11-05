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
  claude -p "Read $fixture/CHECK.md and run it on the project in $fixture. Use the Output format in CHECK.md. Do not modify any file." > "$actual"

  if grep -q '^- none$' "$expected"; then
    if grep -qE '^[[:space:]*]*Project OK[[:space:]*]*$' "$actual" && ! grep -qE '\[[MSC][0-9]+\] (error|warn|unverifiable):' "$actual"; then
      echo "ok: none"
    else
      echo "unexpected finding"
      fail=1
    fi
    rm -f "$actual"
    continue
  fi

  ids="$(grep -oE '\b[MSC][0-9]+\b' "$expected" | sort -u)"
  if [ -z "$ids" ]; then
    echo "no check IDs in $expected"
    fail=1
    rm -f "$actual"
    continue
  fi

  while IFS= read -r id; do
    if grep -qF "[$id]" "$actual"; then
      echo "ok: $id"
    else
      echo "missing: $id"
      fail=1
    fi
  done <<< "$ids"

  if [ "$name" = "old-version" ]; then
    if grep -q 'Upgrade required' "$actual"; then
      echo "ok: upgrade"
    else
      echo "missing: upgrade"
      fail=1
    fi
  fi

  rm -f "$actual"
done

exit "$fail"
