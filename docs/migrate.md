# Migrate to 0.4

- **Status:** draft
- **Date:** 2026-11-13
- **Related:** [`03-distribution.md`](03-distribution.md)

## Before you start

- Update the plugin.
- Commit or stash everything. `apply` needs a clean git working tree.
- Read the 0.4.0 entry in [`CHANGELOG.md`](../CHANGELOG.md).
- Old change entries are never edited, renamed or deleted.

## What migration does

1. Splits each `feature.md` into `feature.md` and `spec.md`.
2. Copies the rules and keeps their numbers. Number unnumbered rules in their
   existing order. An uncovered acceptance line becomes the next rule.
3. Moves decisions to `| ID | Decision | Source | Status |`. A 0.2.x decision
   becomes `approved`.
4. Turns a meta-decision that only supersedes another decision into
   `replaced by D<n>` on the old row, then removes the meta row.
5. Keeps open questions, with their numbers. Removes answered ones.
6. Copies `Depends on`, and folds the data and relation references into it.
7. Adds `Keeliom: 0.4.0` and `Language:` to `app.md`. Folds `Jobs` into the
   one-liner and the users. Renames `API conventions` to `Conventions`.
8. Moves root plan documents into `plans/` when the owner agrees.
9. Deletes `RULES.md`, `CHECK.md` and the version file, and writes the Keeliom
   block into `CLAUDE.md` and `AGENTS.md`.
10. Adds one project entry `changes/NNNN-migrate-0.4.md`. A feature gets no
    migration entry.
11. Runs `check` and writes `STATUS.md`.

Both 0.2.x and 0.3 projects are accepted directly. Anything older than 0.2.0 is
refused.

## Steps

1. Run `/keeliom:migrate mode=report`. It prints every planned change and the
   new prose, and writes nothing.
2. Read the proposed `feature.md` prose. Change what the report gets wrong
   before you apply it.
3. Run `/keeliom:migrate mode=apply owner=<your name> confirm=yes`.
4. Read each new `Description`. Fix a K5 or K7 finding in `feature.md` or
   `spec.md`. Add a change entry only when a requirement changes.
5. Run `keeliom:check`. Expect `Project OK`. A `set done` finding is the
   owner's call.
6. Commit. The migration entry is the only new history file.

To review in batches, run `migrate F00xx` for one feature at a time.

## What the checks accept afterwards

An entry older than the migration entry keeps its old shape. Only entries dated
after the migration entry carry the five fields. A decision listed in the
migration entry counts as recorded.

## Rollback

Git is the backup. Discard the working tree changes and run migration again
after you fix the cause.

## If the migration cannot run

Follow the section order above by hand. Keep the old entries untouched. Add the
same project entry at the end.
