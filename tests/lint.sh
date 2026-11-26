#!/usr/bin/env bash
# Deterministic checks on this repository. No network, no LLM.
# Every later section is appended under a `# --- <topic>` heading.
set -uo pipefail

here=$(cd "$(dirname "$0")" && pwd -P)
# shellcheck source=tests/lib.sh
. "$here/lib.sh"

# Every `../x/` written in the repo must resolve to a directory inside it.
# A path that escapes the repo is a reference to a private project.
assert_relative_paths_resolve() {
  local hit file rest line text ref target found=0
  while IFS= read -r hit; do
    file=${hit%%:*}
    rest=${hit#*:}
    line=${rest%%:*}
    text=${rest#*:}
    while IFS= read -r ref; do
      [ -n "$ref" ] || continue
      ref=${ref%/}
      target=$(cd "$(dirname "$file")" 2>/dev/null && cd "$(dirname "$ref")" 2>/dev/null &&
        printf '%s/%s\n' "$(pwd -P)" "$(basename "$ref")") || target=""
      case "$target" in
      "$root" | "$root"/*) ;;
      *)
        fail "relative path $ref in ${file#"$root"/}:$line does not resolve inside the repo"
        found=$((found + 1))
        ;;
      esac
    done < <(printf '%s\n' "$text" | grep -oE '\.\./[A-Za-z0-9._/-]+' || true)
  done < <(grep -rEn "${grep_excludes[@]}" '\.\./[a-z0-9_-]+/' "$@" 2>/dev/null || true)
  [ "$found" -eq 0 ] && pass "relative paths resolve inside the repo"
}

# --- privacy

assert_no_grep '/Users[/]' "$root/README.md" "$root/docs" "$root/plugins" "$root/examples" "$root/tests/fixtures"
assert_relative_paths_resolve "$root/plugins" "$root/examples" "$root/tests/fixtures"

# --- rules

rules="$root/plugins/keeliom/rules/RULES.md"
assert_file "$rules"
for heading in 'Project layout' 'Language' 'Plans' 'app\.md' 'feature\.md' 'spec\.md' \
  'Change entries' 'Statuses' 'Version' 'Project instructions'; do
  assert_grep "^## $heading\$" "$rules"
done
assert_grep '\| ID \| Decision \| Source \| Status \|' "$rules"
assert_grep '\| Capability \| Owner \| Notes \|' "$rules"
assert_grep 'replaced by D<n>' "$rules"

# The Version section is the one place allowed to name KEELIOM_VERSION.
rules_body=""
if [ -f "$rules" ]; then
  rules_body=$(awk '/^## Version$/{skip=1; next} /^## /{skip=0} !skip' "$rules")
else
  fail "missing RULES.md, cannot scan for removed fields"
fi
if printf '%s\n' "$rules_body" | grep -Eq 'in_progress|Before:|After:|Corrects|Release:|KEELIOM_VERSION'; then
  fail "RULES.md outside §Version names a removed field"
else
  pass "RULES.md outside §Version names no removed field"
fi

# --- templates

app_tpl="$root/plugins/keeliom/templates/app.md"
assert_file "$app_tpl"
assert_grep '^Keeliom: 0\.4\.0$' "$app_tpl"
assert_grep '^Status: draft$' "$app_tpl"
assert_grep '^Language: English$' "$app_tpl"
for heading in 'One-liner' 'Users' 'Scope' 'Non-goals' 'Glossary' 'Invariants' \
  'Stack' 'Roles' 'Data model' 'Capabilities'; do
  assert_grep "^## $heading\$" "$app_tpl"
done
assert_no_grep '^## Jobs$|^## API conventions$' "$app_tpl"

feature_tpl="$root/plugins/keeliom/templates/feature/feature.md"
assert_file "$feature_tpl"
assert_grep '^Status: draft$' "$feature_tpl"
assert_grep '^Source: TBD' "$feature_tpl"
for heading in 'Overview' 'Description' 'Out of scope' 'Decisions' 'Open questions'; do
  assert_grep "^## $heading\$" "$feature_tpl"
done
assert_no_grep '^## Why$|^## Acceptance$|^## Tasks$|^Release:' "$feature_tpl"

spec_tpl="$root/plugins/keeliom/templates/feature/spec.md"
assert_file "$spec_tpl"
assert_grep '^Depends on: None$' "$spec_tpl"
assert_grep '^## Rules$' "$spec_tpl"
assert_grep '^- R1\. TBD' "$spec_tpl"

entry_tpl="$root/plugins/keeliom/templates/feature/changes/0001-initial.md"
assert_file "$entry_tpl"
assert_no_grep 'Keeliom:' "$entry_tpl"
entry_fields=$(grep -cE '^- (Date|Reason|Changed|Decisions|Source):' "$entry_tpl")
entry_keys=$(grep -cE '^- [A-Za-z]+:' "$entry_tpl")
if [ "$entry_fields" -eq 5 ] && [ "$entry_keys" -eq 5 ]; then
  pass "initial entry has exactly the five fields"
else
  fail "initial entry has $entry_fields field lines and $entry_keys bullet keys; expected 5 and 5"
fi

block_tpl="$root/plugins/keeliom/templates/keeliom-block.md"
assert_file "$block_tpl"
if [ "$(head -n 1 "$block_tpl")" = '<!-- keeliom:start -->' ]; then
  pass "block starts with the start marker"
else
  fail "block does not start with <!-- keeliom:start -->"
fi
if [ "$(tail -n 1 "$block_tpl")" = '<!-- keeliom:end -->' ]; then
  pass "block ends with the end marker"
else
  fail "block does not end with <!-- keeliom:end -->"
fi
block_lines=$(wc -l <"$block_tpl" | tr -d ' ')
if [ "$block_lines" -le 15 ]; then
  pass "block is $block_lines lines"
else
  fail "block is $block_lines lines; expected at most 15"
fi
assert_grep 'https://github\.com/khrvi/keeliom/blob/v0\.4\.0/plugins/keeliom/rules/RULES\.md' "$block_tpl"

assert_no_file "$root/plugins/keeliom/templates/RULES.md"
assert_no_file "$root/plugins/keeliom/templates/CHECK.md"
assert_no_file "$root/plugins/keeliom/templates/KEELIOM_VERSION"

# --- skills

assert_file "$root/plugins/keeliom/skills/check/SKILL.md"
assert_file "$root/plugins/keeliom/skills/setup/SKILL.md"
assert_file "$root/plugins/keeliom/skills/feature/SKILL.md"
assert_grep '^## Plan input$' "$root/plugins/keeliom/skills/feature/SKILL.md"
assert_file "$root/plugins/keeliom/skills/migrate/SKILL.md"
assert_no_file "$root/plugins/keeliom/skills/review-project"
assert_no_file "$root/plugins/keeliom/skills/upgrade"
assert_no_file "$root/plugins/keeliom/skills/bootstrap"
assert_no_file "$root/plugins/keeliom/skills/import-feature"
assert_no_file "$root/plugins/keeliom/skills/create-feature"
assert_no_file "$root/plugins/keeliom/skills/change-feature"

# --- docs

# Every relative Markdown link in the top-level docs must resolve.
assert_links_resolve() {
  local file link target found=0
  for file in "$@"; do
    while IFS= read -r link; do
      case "$link" in
      http* | '#'* | mailto:*) continue ;;
      esac
      link=${link%%#*}
      [ -n "$link" ] || continue
      target=$(cd "$(dirname "$file")" 2>/dev/null && cd "$(dirname "$link")" 2>/dev/null &&
        printf '%s/%s\n' "$(pwd -P)" "$(basename "$link")") || target=""
      case "$target" in
      "$root"/*)
        if [ ! -e "$target" ]; then
          fail "link $link in ${file#"$root"/} does not exist"
          found=1
        fi
        ;;
      *)
        fail "link $link in ${file#"$root"/} escapes the repo"
        found=1
        ;;
      esac
    done < <(grep -oE '\]\([^)]+\)' "$file" | sed -E 's/^\]\(//; s/\)$//')
  done
  [ "$found" -eq 0 ] && pass "relative links resolve"
}

assert_no_grep 'bootstrap|create-feature|change-feature|import-feature|review-project|upgrade skill|KEELIOM_VERSION|in_progress' \
  "$root/README.md" "$root"/docs/*.md "$root/plugins/keeliom/README.md"
assert_links_resolve "$root/README.md" "$root"/docs/*.md

docs_skill_lines=$(grep -cE '^- `(setup|feature|check|migrate)`' "$root/README.md")
if [ "$docs_skill_lines" -eq 4 ]; then
  pass "README lists exactly the four skills"
else
  fail "README lists $docs_skill_lines skill bullets; expected 4"
fi

# --- version

assert_grep '"version": "0\.4\.0"' "$root/plugins/keeliom/.claude-plugin/plugin.json"

finish
