---
name: check
description: Run the Keeliom checks on a project or one feature and write STATUS.md.
---

# Check

Run the checks on the current project and write `STATUS.md`.

## Input

- No argument: check the whole project.
- `F00xx`: check that feature. `STATUS.md` still lists every feature.

## Read first

1. `${CLAUDE_PLUGIN_ROOT}/rules/RULES.md`
2. `${CLAUDE_PLUGIN_ROOT}/rules/CHECK.md`
3. The project's `app.md`

## Process

1. Check the version. Compare `app.md` `Keeliom:` with the plugin version in
   `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`, ignoring the patch, as
   `RULES.md §Version` says.
   - Project older: run the checks, then print
     `Migration required: run the migrate skill.` as the last line.
   - Project newer: print
     `Plugin is older than the project: update the keeliom plugin.` and stop.
2. Run the checks in `CHECK.md`. Read the files in its `Read order`. With a
   feature argument, still read `app.md` and the project-level `changes/` so
   the cross-feature checks can run.
3. Print the findings in the `CHECK.md §Output` format: the findings, the `OK`
   lines, the applied overrides, the totals and the last line.
4. Write `STATUS.md` in the project root, exactly as `CHECK.md §STATUS.md`
   says. One row per feature. With a feature argument, recompute the other
   rows from their current files without printing their findings.
5. Edit nothing else. Do not change `app.md`, `feature.md`, `spec.md`,
   `brief.md`, `plans/` or `changes/`.
