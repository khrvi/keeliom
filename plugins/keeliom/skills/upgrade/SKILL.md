---
name: upgrade
description: Upgrade an existing Keeliom project to the current sections and checks.
---

# Upgrade

## When to use

- The project's `KEELIOM_VERSION` is older than
  `${CLAUDE_PLUGIN_ROOT}/templates/KEELIOM_VERSION`.
- The owner wants the current sections and checks without editing every file.

## Input

- target path (default: current directory)
- mode: `report` (default) or `apply`

## Read order

1. `KEELIOM_VERSION`
2. `app.md`
3. `changes/*` if present
4. every `features/F*/feature.md`
5. every `features/F*/brief.md`
6. every `features/F*/changes/*`
7. `RULES.md`
8. `CHECK.md`

## Process

1. Read `KEELIOM_VERSION`. If it is 0.3.0 or later, report "already current"
   and stop.
2. `mode` is `report` (default) or `apply`. In `report`, list every change and
   stop without writing. In `apply`, ask once for confirmation, then write.
   Back up `RULES.md`, `CHECK.md`, `KEELIOM_VERSION`, `app.md` and every
   `feature.md`.
3. Run `CHECK.md` before the migration. Keep the result as the baseline.
4. Replace `RULES.md` and `CHECK.md` from
   `${CLAUDE_PLUGIN_ROOT}/templates/`.
5. Update `app.md`:
   - add `Roles`, `Data model`, `API conventions` and `Repositories` from the
     code;
   - set `Status: ready` when no `TBD` remains; otherwise `draft`. When
     `app.md` is `draft`, keep every feature's status and list each remaining
     `TBD` in `app.md` as an owner action;
   - write `Users` as a `| User | Description |` table;
   - write `Data model` with `Entity | Owner | Key fields | Notes`;
   - remove `Readers` and copy it into each feature's `Reads`;
   - add `Locales: None` and `Accessibility: None` when missing;
   - remove `Tests` from `Stack`;
   - use the `Path | Role | Language | Test commands | Notes` table;
   - create `changes/` when missing and add a project-level entry for the
     `app.md` changes, quoting the changed text in backticks in `Before` and
     `After`;
   - keep the existing content.
6. For each feature:
   - add `Related` if missing;
   - add `Reads: None` when missing;
   - add the Decisions `Status` column and mark every existing decision
     `approved`;
   - write `None` in `Decisions` when there are no decisions; otherwise add the
     table header;
   - add `Release: None` when missing;
   - add `Repositories:` when missing and `app.md` has more than one row;
   - normalize `Open questions` to `Q<n>. <question>` with indented
     `Recommendation:`, `Owner:` and `Status: open` or `answered (D<n>)`;
     record an answered question in `Decisions` and mark it in place, keeping
     its number;
   - add `Replaced by` when the feature is deprecated;
   - do not edit old change entries;
   - add one migration change entry with `Keeliom` (the template version),
     `Date`, `Reason`, `Changed`, `Before`, `After`, `Related`,
     `Corrects: None`, `Decisions: None`, and `Source`
     (`owner:<name>, <date>` for the upgrade decision, plus `code:path` for
     each fact read from code). Quote the changed text in backticks in `After`.
   - list decisions whose `Source` is not `owner:` or `code:` in the migration
     report as "confirm approval". Do not move a feature to `draft` because of
     the migration.
7. Ask only about facts the code cannot answer. In unattended mode, leave `TBD`
   and keep the feature `draft`.
8. Set `KEELIOM_VERSION` to the value in
   `${CLAUDE_PLUGIN_ROOT}/templates/KEELIOM_VERSION`.
9. Run `CHECK.md` after the version bump.
10. If the new CHECK has errors: fix what the skill can from existing content;
    move features with missing owner decisions to `draft` and list the gap;
    record an accepted deviation in `Decisions` with a source; otherwise keep
    the backup and stop.
11. Report `Project OK` only when no owner action remains. Otherwise list each
    finding and the owner action. Run `review-project` when the project has
    more than one feature.
12. Do not implement code. Do not edit old change entries.

## Safety

- Do not delete content.
- Do not overwrite `features/` or `src/`.
- Keep the backup until every error has a fix, a `draft` status, or a recorded
  deviation.
- If a file cannot be read, report it and stop.

## Output

- Updated `RULES.md`, `CHECK.md`, `app.md`, `KEELIOM_VERSION`.
- One migration change entry per feature.
- A report of the warnings, the remaining findings, and every fact that needs
  an owner decision.
- In `report` mode, the same report and no file changes.
