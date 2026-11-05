# Upgrade to 0.3.0

- **Status:** draft
- **Date:** 2026-11-04
- **Related:** [`03-distribution.md`](03-distribution.md)

## Before you start

- Run the `upgrade` skill in the project. This page is the manual fallback.
- Commit or back up the project.
- Read the 0.3.0 entry in `CHANGELOG.md`.
- Do not edit an existing change entry.
- One rule set applies at every step. `KEELIOM_VERSION` only tells `upgrade`
  whether migration is needed.

## From 0.2.x to 0.3.0

1. Update `RULES.md` and `CHECK.md` from the plugin templates.
2. In `app.md`:
   - add `Status: ready` when no `TBD` remains; otherwise `draft`;
   - convert `Users` bullets to a `| User | Description |` table;
   - rename `Data model` to `| Entity | Owner | Key fields | Notes |`;
   - remove `Readers` and copy it into each feature's `Reads`;
   - add `Locales: None` and `Accessibility: None` when missing.
3. In each feature:
   - add `Reads: None` when missing;
   - add the Decisions `Status` column and mark every existing decision
     `approved`;
   - list decisions whose `Source` is not `owner:` or `code:` as "confirm
     approval".
4. Add one migration change entry per feature with `Keeliom: 0.3.0`. Quote the
   changed text in `After`.
5. Add a project-level `changes/` entry for the `app.md` changes.
6. Set `KEELIOM_VERSION` to the value in the plugin's
   `templates/KEELIOM_VERSION` (0.3.0).
7. Run `CHECK.md`. `Project OK` is required only when no owner action remains.
   Otherwise list every finding and the owner action.

## From 0.1.0 to 0.2.3

1. Update `RULES.md` and `CHECK.md` from the plugin templates.
2. Add `Roles`, `Data model`, `API conventions` and `Repositories` (or `None`)
   to `app.md`. Remove `Tests` from `Stack`.
3. Add `Decisions`, `Related` and structured `Open questions` to every feature.
4. Do not edit old change entries. Add one migration change entry per feature
   with `Keeliom: 0.2.3`. Its `Source` is `owner:<name>, <date>` for the
   upgrade decision and `code:path` for each fact read from code.
5. Add `Replaced by` to deprecated features.
6. New change entries carry `Keeliom: 0.2.3`, `Decisions` and `Source`.
7. Run `CHECK.md` before the migration. Keep the result as the baseline.
8. Set `KEELIOM_VERSION` to the value in the plugin's
   `templates/KEELIOM_VERSION` (0.2.3).
9. Run `CHECK.md` after the version bump. `Project OK` is required only when no
   owner action remains. Otherwise list every finding and the owner action.

Old change entries may keep code paths in `Related`. M11 and M21 exempt entries
without `Keeliom:`.

## Rollback

Keep the backup until the new CHECK result is recorded and every error has
either a fix, a `draft` status, or a recorded deviation.
