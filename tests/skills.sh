#!/usr/bin/env bash
# Runs plugin skills against temporary projects.
# Usage: bash tests/skills.sh [scenario]
set -uo pipefail

here=$(cd "$(dirname "$0")" && pwd -P)
# shellcheck source=tests/lib.sh
. "$here/lib.sh"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

run_skill() {
  local dir=$1 prompt=$2
  (
    cd "$dir" &&
      claude -p "$prompt" --plugin-dir "$root/plugins/keeliom" \
        --add-dir "$root/plugins/keeliom" \
        --permission-mode acceptEdits \
        --allowedTools "Bash(git:*) Bash(ls:*) Bash(mkdir:*) Bash(mv:*) Bash(rm:*)"
  )
}

scenario_check_status() {
  local dir="$tmp/check_status"
  cp -R "$root/tests/fixtures/k3-assumed-ready" "$dir"
  run_skill "$dir" "/keeliom:check" >"$tmp/check_status.out" 2>&1

  if [ -f "$dir/STATUS.md" ]; then
    pass "check_status: STATUS.md exists"
  else
    fail "check_status: STATUS.md missing"
    sed 's/^/    /' "$tmp/check_status.out" | head -40
    return
  fi

  if head -n 1 "$dir/STATUS.md" |
    grep -Eq '^# Status — generated [0-9]{4}-[0-9]{2}-[0-9]{2} by keeliom:check$'; then
    pass "check_status: header line"
  else
    fail "check_status: header line is $(head -n 1 "$dir/STATUS.md")"
  fi

  if grep -Eq '^\| F0001 Create item \| ready \| 0 \| 1 \| — \| [1-9]' "$dir/STATUS.md"; then
    pass "check_status: feature row"
  else
    fail "check_status: no matching feature row"
    sed 's/^/    /' "$dir/STATUS.md" | head -20
  fi

  if diff -r -x STATUS.md "$root/tests/fixtures/k3-assumed-ready" "$dir" >"$tmp/check_status.diff" 2>&1; then
    pass "check_status: no other file changed"
  else
    fail "check_status: other files changed"
    sed 's/^/    /' "$tmp/check_status.diff" | head -40
  fi
}

if [ $# -gt 1 ]; then
  echo "usage: bash tests/skills.sh [scenario]" >&2
  exit 2
fi

if [ $# -eq 1 ]; then
  fn="scenario_$1"
  if ! declare -F "$fn" >/dev/null; then
    echo "no such scenario: $1" >&2
    exit 2
  fi
  "$fn"
  finish
fi

for fn in $(declare -F | awk '{print $3}' | grep '^scenario_'); do
  "$fn"
done
finish
