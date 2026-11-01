---
name: upgrade
description: Upgrade an existing Keeliom project to the 0.2.0 sections and checks without editing every file by hand.
---

# Upgrade

## When to use

- The project has `KEELIOM_VERSION` 0.1.0 or older.
- The owner wants the 0.2.0 sections and checks without editing every file.

## Input

- target path (default: current directory)
- mode: `apply` (default) or `report`

## Read order

1. `KEELIOM_VERSION`
2. `app.md`
3. every `features/F*/feature.md`
4. every `features/F*/brief.md`
5. every `features/F*/changes/*`
6. `RULES.md`
7. `CHECK.md`

## Process

1. If `KEELIOM_VERSION` is 0.2.0 or later, report "already current" and stop.
2. Ask before overwriting any existing file. Keep a backup of `RULES.md`,
   `CHECK.md` and `KEELIOM_VERSION`.
3. Replace `RULES.md` and `CHECK.md` from
   `${CLAUDE_PLUGIN_ROOT}/templates/`.
4. Update `app.md`:
   - add `Roles`, `Data model`, `API conventions` and `Repositories` from the
     code;
   - remove `Tests` from `Stack`;
   - keep the existing content.
5. For each feature:
   - add `Related` if missing;
   - add `Decisions` if missing;
   - restructure `Open questions` to `Q<n>`, `Recommendation`, `Owner`,
     `Status: open`. Move answered questions into `Decisions`;
   - do not edit old change entries;
   - add one migration change entry with `Keeliom` (the template version),
     `Date`, `Reason`, `Changed`, `Before`, `After`, `Related`,
     `Corrects: None`, `Decisions: None`, and `Source`
     (`owner:<name>, <date>` for the upgrade decision, plus `code:path` for
     each fact read from code);
   - add `Repository: <path>` when `Repositories` has more than one row;
   - add `Replaced by` when the feature is deprecated.
6. Ask only about facts the code cannot answer. In unattended mode, leave `TBD`
   and keep the feature `draft`.
7. Run `CHECK.md` under the old version. Report the warnings.
8. Set `KEELIOM_VERSION` to the value in
   `${CLAUDE_PLUGIN_ROOT}/templates/KEELIOM_VERSION`.
9. Run `CHECK.md` again. Report `Project OK` or the remaining findings.
10. Do not implement code. Do not edit old change entries.

## Safety

- Do not delete content.
- Do not overwrite `features/` or `src/`.
- Keep the backup until `CHECK.md` reports `Project OK`.
- If a file cannot be read, report it and stop.

## Output

- Updated `RULES.md`, `CHECK.md`, `app.md`, `KEELIOM_VERSION`.
- One migration change entry per feature.
- A report of the warnings, the remaining findings, and every fact that needs
  an owner decision.
