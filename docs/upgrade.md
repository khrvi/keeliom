# Upgrade to 0.2.0

- **Status:** draft
- **Date:** 2026-11-01
- **Related:** [`04-v0.2-plan.md`](04-v0.2-plan.md),
  [`03-distribution.md`](03-distribution.md)

## Before you start

- Commit or back up the project.
- Read the 0.2.0 entry in `CHANGELOG.md`.
- Do not edit an existing change entry.

## Steps

1. Update `RULES.md` and `CHECK.md` from the plugin templates.
2. Set `KEELIOM_VERSION` to `0.2.0`.
3. Add `Roles`, `Data model`, `API conventions` and `Repositories` (or `None`)
   to `app.md`. Remove `Tests` from `Stack`.
4. Add `Decisions`, `Related` and structured `Open questions` to every feature.
   Add `Source` to new change entries.
5. Do not edit old change entries. Add one migration change entry per feature
   with `Keeliom: 0.2.0` that records the move. Its `Source` points to this
   guide or the change that required the move.
6. Move code paths from `Related` to the initial change entry's `Source`.
7. Add `Replaced by` to deprecated features.
8. New change entries carry `Keeliom: 0.2.0`, `Decisions` and `Source`.
9. Run `CHECK.md`.

## Version gate

A project on `KEELIOM_VERSION` 0.1.0 gets warnings for the new sections. It
gets errors for contradictions and broken references. Set `KEELIOM_VERSION`
only after the steps are complete.

## Rollback

Keep the old `RULES.md`, `CHECK.md` and `KEELIOM_VERSION` until `CHECK.md`
reports `Project OK`.
