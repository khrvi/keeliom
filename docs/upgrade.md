# Upgrade to 0.2.2

- **Status:** draft
- **Date:** 2026-11-01
- **Related:** [`03-distribution.md`](03-distribution.md)

## Before you start

- Run the `upgrade` skill in the project. This page is the manual fallback.
- Commit or back up the project.
- Read the 0.2.2 entry in `CHANGELOG.md`.
- Do not edit an existing change entry.

## Steps

1. Update `RULES.md` and `CHECK.md` from the plugin templates.
2. Add `Roles`, `Data model`, `API conventions` and `Repositories` (or `None`)
   to `app.md`. Remove `Tests` from `Stack`.
3. Add `Decisions`, `Related` and structured `Open questions` to every feature.
4. Do not edit old change entries. Add one migration change entry per feature
   with `Keeliom: 0.2.2`. Its `Source` is `owner:<name>, <date>` for the
   upgrade decision and `code:path` for each fact read from code.
5. Add `Replaced by` to deprecated features.
6. New change entries carry `Keeliom: 0.2.2`, `Decisions` and `Source`.
7. Run `CHECK.md` under the 0.1.0 rules. Expect warnings for the new sections.
8. Set `KEELIOM_VERSION` to the value in the plugin's
   `templates/KEELIOM_VERSION` (0.2.2).
9. Run `CHECK.md` again under the 0.2.2 rules. `Project OK` is required only
   when no owner action remains. Otherwise list every finding and the owner
   action.

Old change entries may keep code paths in `Related`. M11 and M21 exempt entries
without `Keeliom:`.

## Version gate

A project on `KEELIOM_VERSION` 0.1.0 gets warnings for the new sections. It
gets errors for contradictions and broken references. Set `KEELIOM_VERSION`
only after the steps are complete.

## Rollback

Keep the backup until the new CHECK result is recorded and every error has
either a fix, a `draft` status, or a recorded deviation.
