#!/usr/bin/env bash
# Runs the migrate skill on temporary copies of the migration inputs.
# Usage: bash tests/migrate.sh [case]
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

# Copy an input, make it a clean git repo, and print the temp path.
prepare() {
  local input=$1
  local dir
  dir="$tmp/$(basename "$input")-$RANDOM"
  cp -R "$input" "$dir"
  (
    cd "$dir" || exit 1
    git init -q
    git add -A
    git -c user.email=test@example.com -c user.name=test commit -qm init
  )
  printf '%s\n' "$dir"
}

apply() {
  local dir=$1 out=$2
  run_skill "$dir" "/keeliom:migrate mode=apply owner=maintainer confirm=yes" >"$out" 2>&1
}

# Every old entry in the input is byte-identical in the output.
assert_old_entries_unchanged() {
  local out=$1 input=$2 rel bad=0
  while IFS= read -r rel; do
    if [ ! -f "$out/$rel" ]; then
      fail "old entry missing: $rel"
      bad=1
    elif cmp -s "$input/$rel" "$out/$rel"; then
      pass "old entry unchanged: $rel"
    else
      fail "old entry changed: $rel"
      bad=1
    fi
  done < <(cd "$input" && find . -type f \( -path './features/*/changes/*' -o -path './changes/*' \) | sort)
  [ "$bad" -eq 0 ] && pass "every old entry unchanged"
}

assert_applied() {
  local dir=$1 input=$2 name before after new fields
  for name in $(cd "$input/features" && ls -d */ | tr -d '/'); do
    assert_file "$dir/features/$name/feature.md"
    assert_file "$dir/features/$name/spec.md"
    before=$(find "$input/features/$name/changes" -type f | wc -l | tr -d ' ')
    after=$(find "$dir/features/$name/changes" -type f | wc -l | tr -d ' ')
    if [ "$after" -eq "$before" ]; then
      pass "$name gains no entry"
    else
      fail "$name has $after entries, expected $before"
    fi
  done
  assert_old_entries_unchanged "$dir" "$input"
  assert_no_file "$dir/RULES.md"
  assert_no_file "$dir/CHECK.md"
  assert_no_file "$dir/KEELIOM_VERSION"
  assert_grep '^Keeliom: 0\.5\.0$' "$dir/app.md"
  assert_no_grep '^## Jobs$' "$dir/app.md"

  before=0
  [ -d "$input/changes" ] && before=$(find "$input/changes" -type f | wc -l | tr -d ' ')
  after=$(find "$dir/changes" -type f | wc -l | tr -d ' ')
  new=$(find "$dir/changes" -name '*-migrate-0.5.md' | head -n 1)
  if [ "$after" -eq $((before + 1)) ] && [ -n "$new" ]; then
    pass "exactly one new project entry"
    fields=$(grep -cE '^- *\*{0,2}(Date|Reason|Changed|Decisions|Source)' "$new")
    if [ "$fields" -eq 5 ]; then
      pass "migration entry has five fields"
    else
      fail "migration entry has $fields field lines"
    fi
  else
    fail "project changes/ went from $before to $after files"
  fi

  if grep -q '<!-- keeliom:start -->' "$dir/CLAUDE.md" 2>/dev/null; then
    pass "CLAUDE.md has the block"
  else
    fail "CLAUDE.md has no block"
  fi
}

case_report_writes_nothing() {
  local dir out
  dir=$(prepare "$root/tests/migrate/v0.3-input")
  out="$tmp/report.out"
  run_skill "$dir" "/keeliom:migrate mode=report" >"$out" 2>&1
  if [ -z "$(git -C "$dir" status --porcelain)" ]; then
    pass "report: no file changed"
  else
    fail "report: files changed"
    git -C "$dir" status --porcelain | sed 's/^/    /'
  fi
  if grep -q 'F0001' "$out"; then
    pass "report: names a feature"
  else
    fail "report: names no feature"
  fi
}

case_apply_v03() {
  local dir out
  dir=$(prepare "$root/tests/migrate/v0.3-input")
  out="$tmp/apply_v03.out"
  apply "$dir" "$out"
  assert_applied "$dir" "$root/tests/migrate/v0.3-input"
}

case_apply_v023() {
  local dir out
  dir=$(prepare "$root/tests/migrate/v0.2.3-input")
  out="$tmp/apply_v023.out"
  apply "$dir" "$out"

  assert_applied "$dir" "$root/tests/migrate/v0.2.3-input"
  assert_no_grep '^Release:' "$dir/features"
  assert_grep '^Status: ' "$dir/app.md"
  assert_grep '\| User \| Description \|' "$dir/app.md"
  assert_grep '\| Entity \| Owner \| Key fields \| Notes \|' "$dir/app.md"
  if grep -q 'plans/release' "$out"; then
    pass "v0.2.3: report offers a release plan"
  else
    fail "v0.2.3: no release plan offer"
  fi

  local feature="$dir/features/F0001-add-note/feature.md"
  if grep -qE '^(- )?Q2\.' "$feature"; then
    pass "v0.2.3: open question Q2 kept"
  else
    fail "v0.2.3: open question Q2 lost"
  fi
  if grep -qE '^(- )?Q1\.' "$feature"; then
    fail "v0.2.3: answered question Q1 kept"
  else
    pass "v0.2.3: answered question Q1 gone"
  fi
  if grep -Eq '^\| D1 \|.*\| approved \|' "$feature"; then
    pass "v0.2.3: D1 approved"
  else
    fail "v0.2.3: D1 not approved"
  fi
}

case_unnumbered() {
  local dir out
  dir=$(prepare "$root/tests/migrate/unnumbered-input")
  out="$tmp/unnumbered.out"
  apply "$dir" "$out"

  local spec="$dir/features/F0001-add-note/spec.md"
  assert_grep '^- R1\. Saving a note without a title shows "Title is required"' "$spec"
  assert_grep '^- R2\. Saving a title longer than 60 characters shows "Title too long"' "$spec"
  assert_grep '^- R3\. Saving a valid note stores it' "$spec"
  assert_grep '^- R4\. The list is sorted newest first' "$spec"
  assert_grep '^Depends on: .*F0002' "$spec"

  local feature="$dir/features/F0001-add-note/feature.md"
  if grep -q 'Is D2 still valid' "$feature"; then
    fail "unnumbered: meta-decision row kept"
  else
    pass "unnumbered: meta-decision row gone"
  fi
  if grep -qE '^\| D4 \|' "$feature"; then
    fail "unnumbered: D4 row kept"
  else
    pass "unnumbered: D4 row gone"
  fi
  if grep -Eq '^\| D2 \|.*replaced by D3 \|' "$feature"; then
    pass "unnumbered: D2 marked replaced by D3"
  else
    fail "unnumbered: D2 not marked replaced by D3"
  fi
}

case_per_feature() {
  local dir out
  dir=$(prepare "$root/tests/migrate/v0.2.3-input")
  out="$tmp/per_feature.out"
  run_skill "$dir" "/keeliom:migrate mode=apply owner=maintainer confirm=yes F0001" >"$out" 2>&1

  assert_file "$dir/features/F0001-add-note/spec.md"
  assert_no_file "$dir/features/F0002-list-notes/spec.md"
  if grep -q '^Keeliom: 0\.5\.0$' "$dir/app.md"; then
    fail "per-feature: app.md was migrated"
  else
    pass "per-feature: app.md untouched"
  fi
  if ls "$dir"/changes/*-migrate-0.5.md >/dev/null 2>&1; then
    fail "per-feature: project entry written"
  else
    pass "per-feature: no project entry"
  fi
  assert_file "$dir/KEELIOM_VERSION"

  git -C "$dir" add -A
  git -C "$dir" -c user.email=test@example.com -c user.name=test commit -qm partial

  run_skill "$dir" "/keeliom:migrate mode=apply owner=maintainer confirm=yes" >"$tmp/per_feature_rest.out" 2>&1
  assert_file "$dir/features/F0002-list-notes/spec.md"
  assert_grep '^Keeliom: 0\.5\.0$' "$dir/app.md"
  if ls "$dir"/changes/*-migrate-0.5.md >/dev/null 2>&1; then
    pass "per-feature: the full run writes the project entry"
  else
    fail "per-feature: the full run wrote no project entry"
  fi
}

case_dirty_tree() {
  local dir out status
  dir=$(prepare "$root/tests/migrate/v0.3-input")
  printf '\nLocal uncommitted edit.\n' >>"$dir/app.md"
  out="$tmp/dirty_tree.out"
  apply "$dir" "$out"

  if grep -qi 'not clean\|clean working tree' "$out"; then
    pass "dirty tree: output mentions a clean tree"
  else
    fail "dirty tree: output does not mention a clean tree"
  fi
  status=$(git -C "$dir" status --porcelain)
  if [ "$status" = ' M app.md' ]; then
    pass "dirty tree: only the original edit remains"
  else
    fail "dirty tree: unexpected changes"
    printf '%s\n' "$status" | sed 's/^/    /'
  fi
  if grep -q '^Keeliom: 0\.5\.0$' "$dir/app.md"; then
    fail "dirty tree: app.md was migrated"
  else
    pass "dirty tree: app.md was not migrated"
  fi
}

case_rerun() {
  local dir out
  dir=$(prepare "$root/tests/migrate/v0.3-input")
  apply "$dir" "$tmp/rerun-first.out"
  assert_grep '^Keeliom: 0\.5\.0$' "$dir/app.md"
  git -C "$dir" add -A
  git -C "$dir" -c user.email=test@example.com -c user.name=test commit -qm migrated
  out="$tmp/rerun.out"
  apply "$dir" "$out"

  if grep -q 'already current' "$out"; then
    pass "rerun: reports already current"
  else
    fail "rerun: no already current message"
  fi
  if [ -z "$(git -C "$dir" status --porcelain)" ]; then
    pass "rerun: no file changed"
  else
    fail "rerun: files changed"
    git -C "$dir" status --porcelain | sed 's/^/    /'
  fi
}

case_compatible_v04() {
  local dir out
  dir=$(prepare "$root/tests/fixtures/version-compatible")
  out="$tmp/compatible_v04.out"
  apply "$dir" "$out"

  if grep -q 'already current' "$out"; then
    pass "v0.4: reports already current"
  else
    fail "v0.4: no already current message"
    sed 's/^/    /' "$out" | head -30
  fi
  if [ -z "$(git -C "$dir" status --porcelain)" ]; then
    pass "v0.4: no file changed"
  else
    fail "v0.4: files changed"
    git -C "$dir" status --porcelain | sed 's/^/    /'
  fi
}

if [ $# -gt 1 ]; then
  echo "usage: bash tests/migrate.sh [case]" >&2
  exit 2
fi

if [ $# -eq 1 ]; then
  fn="case_$1"
  if ! declare -F "$fn" >/dev/null; then
    echo "no such case: $1" >&2
    exit 2
  fi
  "$fn"
  finish
fi

for fn in $(declare -F | awk '{print $3}' | grep '^case_'); do
  "$fn"
done
finish
