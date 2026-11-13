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
  local dir=$1 input=$2 name
  for name in $(cd "$input/features" && ls -d */ | tr -d '/'); do
    assert_file "$dir/features/$name/feature.md"
    assert_file "$dir/features/$name/spec.md"
  done
  assert_old_entries_unchanged "$dir" "$input"
  assert_no_file "$dir/RULES.md"
  assert_no_file "$dir/CHECK.md"
  assert_no_file "$dir/KEELIOM_VERSION"
  assert_grep '^Keeliom: 0\.4\.0$' "$dir/app.md"
  assert_no_grep '^## Jobs$' "$dir/app.md"
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
}

case_apply_v03() {
  local dir out before after new name
  dir=$(prepare "$root/tests/migrate/v0.3-input")
  out="$tmp/apply_v03.out"
  apply "$dir" "$out"

  assert_applied "$dir" "$root/tests/migrate/v0.3-input"

  before=$(find "$root/tests/migrate/v0.3-input/changes" -type f | wc -l | tr -d ' ')
  after=$(find "$dir/changes" -type f | wc -l | tr -d ' ')
  new=$(find "$dir/changes" -name '*-migrate-0.4.md' | head -n 1)
  if [ "$after" -eq $((before + 1)) ] && [ -n "$new" ]; then
    pass "v0.3: exactly one new project entry"
    local fields
    fields=$(grep -cE '^- *\*{0,2}(Date|Reason|Changed|Decisions|Source)' "$new")
    if [ "$fields" -eq 5 ]; then
      pass "v0.3: migration entry has five fields"
    else
      fail "v0.3: migration entry has $fields field lines"
    fi
  else
    fail "v0.3: project changes/ went from $before to $after files"
  fi

  for name in $(cd "$root/tests/migrate/v0.3-input/features" && ls -d */ | tr -d '/'); do
    before=$(find "$root/tests/migrate/v0.3-input/features/$name/changes" -type f | wc -l | tr -d ' ')
    after=$(find "$dir/features/$name/changes" -type f | wc -l | tr -d ' ')
    if [ "$after" -eq "$before" ]; then
      pass "v0.3: $name gains no entry"
    else
      fail "v0.3: $name has $after entries, expected $before"
    fi
  done

  if grep -q '<!-- keeliom:start -->' "$dir/CLAUDE.md" 2>/dev/null; then
    pass "v0.3: CLAUDE.md has the block"
  else
    fail "v0.3: CLAUDE.md has no block"
  fi
}

case_apply_v023() {
  local dir out
  dir=$(prepare "$root/tests/migrate/v0.2.3-input")
  out="$tmp/apply_v023.out"
  apply "$dir" "$out"

  assert_applied "$dir" "$root/tests/migrate/v0.2.3-input"
  assert_no_grep '^Release:' "$dir/features"

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
  if grep -Eq '^\| D2 \|.*replaced by D3 \|' "$feature"; then
    pass "unnumbered: D2 marked replaced by D3"
  else
    fail "unnumbered: D2 not marked replaced by D3"
  fi
}

case_dirty_tree() {
  local dir out status
  dir=$(prepare "$root/tests/migrate/v0.3-input")
  printf '\nLocal uncommitted edit.\n' >>"$dir/app.md"
  out="$tmp/dirty_tree.out"
  apply "$dir" "$out"

  if grep -qi 'clean' "$out"; then
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
  if grep -q '^Keeliom: 0\.4\.0$' "$dir/app.md"; then
    fail "dirty tree: app.md was migrated"
  else
    pass "dirty tree: app.md was not migrated"
  fi
}

case_rerun() {
  local dir out
  dir=$(prepare "$root/tests/migrate/v0.3-input")
  apply "$dir" "$tmp/rerun-first.out"
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
