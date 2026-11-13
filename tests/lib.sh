#!/usr/bin/env bash
# Shared assertions for the Keeliom test scripts.
# Source it from a script in tests/:  . "$(dirname "$0")/lib.sh"

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
failures=0

# Never linted: git metadata and the local plans and specs.
grep_excludes=(--exclude-dir=.git --exclude-dir=superpowers)

pass() {
  printf 'ok: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1"
  failures=$((failures + 1))
}

assert_file() {
  if [ -f "$1" ]; then
    pass "file exists: ${1#"$root"/}"
  else
    fail "missing file: ${1#"$root"/}"
  fi
}

assert_no_file() {
  if [ -e "$1" ]; then
    fail "unexpected file: ${1#"$root"/}"
  else
    pass "no file: ${1#"$root"/}"
  fi
}

# Extended regex, must match at least once.
assert_grep() {
  local pattern=$1 file=$2
  if grep -Eq -- "$pattern" "$file" 2>/dev/null; then
    pass "match: $pattern in ${file#"$root"/}"
  else
    fail "no match: $pattern in ${file#"$root"/}"
  fi
}

# Extended regex, must not match. Directories are searched recursively.
assert_no_grep() {
  local pattern=$1
  shift
  local hits line
  hits=$(grep -rEn "${grep_excludes[@]}" -- "$pattern" "$@" 2>/dev/null || true)
  if [ -z "$hits" ]; then
    pass "no match: $pattern"
    return
  fi
  while IFS= read -r line; do
    fail "match for $pattern: ${line#"$root"/}"
  done <<< "$hits"
}

finish() {
  if [ "$failures" -gt 0 ]; then
    printf '\n%d failure(s)\n' "$failures"
    exit 1
  fi
  printf '\nall checks passed\n'
  exit 0
}
