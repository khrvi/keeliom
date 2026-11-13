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

assert_no_grep '/Users/' "$root/README.md" "$root/docs" "$root/plugins" "$root/examples" "$root/tests/fixtures"
assert_relative_paths_resolve "$root/plugins" "$root/examples" "$root/tests/fixtures"

# --- version

assert_grep '"version": "0\.4\.0"' "$root/plugins/keeliom/.claude-plugin/plugin.json"

finish
