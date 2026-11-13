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

scenario_check_older() {
  local dir="$tmp/check_older"
  cp -R "$root/tests/fixtures/version-old" "$dir"
  run_skill "$dir" "/keeliom:check" >"$tmp/check_older.out" 2>&1

  if grep -q 'Migration required: run the migrate skill\.' "$tmp/check_older.out"; then
    pass "check_older: prints the migration message"
  else
    fail "check_older: no migration message"
    sed 's/^/    /' "$tmp/check_older.out" | head -20
  fi
  assert_file "$dir/STATUS.md"
}

scenario_setup_old_project() {
  local dir="$tmp/setup_old_project"
  cp -R "$root/tests/migrate/v0.3-input" "$dir"
  cp "$dir/app.md" "$tmp/setup_old_app.orig"
  run_skill "$dir" "/keeliom:setup mode=existing" >"$tmp/setup_old.out" 2>&1

  if cmp -s "$tmp/setup_old_app.orig" "$dir/app.md"; then
    pass "setup_old: app.md unchanged"
  else
    fail "setup_old: setup rewrote the old app.md"
    diff "$tmp/setup_old_app.orig" "$dir/app.md" | head -20
  fi
  if grep -q 'Migration required' "$tmp/setup_old.out"; then
    pass "setup_old: prints the migration message"
  else
    fail "setup_old: no migration message"
    sed 's/^/    /' "$tmp/setup_old.out" | head -20
  fi
}

scenario_setup_new() {
  local dir="$tmp/setup_new"
  mkdir -p "$dir"
  git -C "$dir" init -q
  run_skill "$dir" "/keeliom:setup mode=new" >"$tmp/setup_new.out" 2>&1

  assert_file "$dir/app.md"
  if [ -f "$dir/app.md" ]; then
    assert_grep '^Keeliom: 0\.4\.0$' "$dir/app.md"
    assert_grep '^Status: draft$' "$dir/app.md"
    assert_grep '^Language: English$' "$dir/app.md"
  fi
  local file
  for file in CLAUDE.md AGENTS.md; do
    if grep -q '<!-- keeliom:start -->' "$dir/$file" 2>/dev/null &&
      grep -q '<!-- keeliom:end -->' "$dir/$file"; then
      pass "setup_new: $file has the block"
    else
      fail "setup_new: $file has no block"
    fi
  done
  if [ -d "$dir/features" ] && [ -d "$dir/changes" ]; then
    pass "setup_new: features/ and changes/ exist"
  else
    fail "setup_new: features/ or changes/ missing"
  fi
  assert_no_file "$dir/RULES.md"
  assert_no_file "$dir/CHECK.md"
  assert_no_file "$dir/KEELIOM_VERSION"
}

scenario_setup_block_idempotent() {
  local dir="$tmp/setup_block_idempotent"
  mkdir -p "$dir"
  git -C "$dir" init -q
  cat >"$dir/CLAUDE.md" <<'EOF'
# Project notes

Keep this text.

<!-- keeliom:start -->
Old Keeliom block.
<!-- keeliom:end -->
EOF
  run_skill "$dir" "/keeliom:setup mode=existing" >"$tmp/setup_block.out" 2>&1

  if grep -q 'Keep this text\.' "$dir/CLAUDE.md"; then
    pass "setup_block: user text kept"
  else
    fail "setup_block: user text changed"
  fi
  local starts
  starts=$(grep -c '<!-- keeliom:start -->' "$dir/CLAUDE.md")
  if [ "$starts" -eq 1 ]; then
    pass "setup_block: exactly one block"
  else
    fail "setup_block: $starts blocks"
  fi
  if grep -q 'Old Keeliom block\.' "$dir/CLAUDE.md"; then
    fail "setup_block: old block kept"
  else
    pass "setup_block: old block replaced"
  fi
  if grep -q 'This project uses Keeliom\.' "$dir/CLAUDE.md"; then
    pass "setup_block: template text present"
  else
    fail "setup_block: template text missing"
  fi
}

scenario_feature_unattended() {
  local dir="$tmp/feature_unattended"
  cp -R "$root/tests/fixtures/_base" "$dir"
  mkdir -p "$dir/features/F0002-list-items"
  cat >"$dir/features/F0002-list-items/brief.md" <<'EOF'
Members see their items, newest first. Empty list shows 'No items yet'.
EOF
  cp "$dir/features/F0002-list-items/brief.md" "$tmp/brief.orig"

  run_skill "$dir" "/keeliom:feature features/F0002-list-items/brief.md unattended" \
    >"$tmp/feature_unattended.out" 2>&1

  local feature="$dir/features/F0002-list-items/feature.md"
  local spec="$dir/features/F0002-list-items/spec.md"
  local entry="$dir/features/F0002-list-items/changes/0001-initial.md"
  assert_file "$feature"
  assert_file "$spec"
  [ -f "$feature" ] && assert_grep '^Source: brief\.md' "$feature"
  [ -f "$spec" ] && assert_grep '^- R1\.' "$spec"
  if [ -f "$entry" ]; then
    local fields
    fields=$(grep -cE '^- *\*{0,2}(Date|Reason|Changed|Decisions|Source)' "$entry")
    if [ "$fields" -eq 5 ]; then
      pass "feature_unattended: entry has five fields"
    else
      fail "feature_unattended: entry has $fields field lines"
    fi
  else
    fail "feature_unattended: changes/0001-initial.md missing"
  fi
  if cmp -s "$tmp/brief.orig" "$dir/features/F0002-list-items/brief.md"; then
    pass "feature_unattended: brief unchanged"
  else
    fail "feature_unattended: brief changed"
  fi

  run_skill "$dir" "/keeliom:check" >"$tmp/feature_unattended.check.out" 2>&1
  if grep -qE '\[K[14]\]' "$tmp/feature_unattended.check.out"; then
    fail "feature_unattended: check reports K1 or K4"
    sed 's/^/    /' "$tmp/feature_unattended.check.out" | head -30
  else
    pass "feature_unattended: check reports no K1 or K4"
  fi
}

scenario_feature_change() {
  local dir="$tmp/feature_change"
  cp -R "$root/tests/fixtures/_base" "$dir"
  cp "$dir/features/F0001-demo/changes/0001-initial.md" "$tmp/entry.orig"
  grep -E '^- R[12]\.' "$dir/features/F0001-demo/spec.md" >"$tmp/rules.orig"

  run_skill "$dir" "/keeliom:feature F0001 change: names are limited to 40 characters. Owner approved. unattended" \
    >"$tmp/feature_change.out" 2>&1

  local entry
  entry=$(find "$dir/features/F0001-demo/changes" -name '0002-*.md' | head -n 1)
  if [ -n "$entry" ]; then
    pass "feature_change: new entry exists"
    assert_grep '^- Decisions: D2$' "$entry"
  else
    fail "feature_change: no 0002 entry"
  fi
  assert_grep '\| D2 \|' "$dir/features/F0001-demo/feature.md"
  if cmp -s "$tmp/entry.orig" "$dir/features/F0001-demo/changes/0001-initial.md"; then
    pass "feature_change: 0001 unchanged"
  else
    fail "feature_change: 0001 changed"
  fi
  assert_grep '^- R1\.' "$dir/features/F0001-demo/spec.md"
  assert_grep '^- R2\.' "$dir/features/F0001-demo/spec.md"
  assert_grep '^- R3\.' "$dir/features/F0001-demo/spec.md"
  grep -E '^- R[12]\.' "$dir/features/F0001-demo/spec.md" >"$tmp/rules.after"
  if cmp -s "$tmp/rules.orig" "$tmp/rules.after"; then
    pass "feature_change: R1 and R2 unchanged"
  else
    fail "feature_change: R1 or R2 changed"
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
