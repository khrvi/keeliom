# Generic example — Book Library

This is a neutral example for Keeliom v0.4.0. It is not a real app and is not
tied to any project.

## Structure

```
generic-app/
  app.md
  STATUS.md
  CLAUDE.md
  AGENTS.md
  changes/
    0001-data-model-readers.md
    0002-app-0.3.0.md
    0003-migrate-0.4.md
  features/
    F0001-add-book/
      feature.md
      spec.md
      changes/
        0001-initial.md
        0002-trim-title.md
        0003-correct-reason.md
        0004-isbn-invalid.md
        0005-migrate-0.3.0.md
    F0002-list-books/
      feature.md
      spec.md
      changes/
        0001-initial.md
        0002-error-status.md
        0003-data-reference.md
        0004-migrate-0.3.0.md
    F0003-edit-book/
      feature.md
      spec.md
      changes/
        0001-initial.md
        0002-trim-title.md
        0003-isbn-rules.md
        0004-data-reference.md
        0005-migrate-0.3.0.md
    F0004-delete-book/
      brief.md
      feature.md
      spec.md
      changes/
        0001-initial.md
        0002-success-and-failure.md
        0003-data-reference.md
        0004-migrate-0.3.0.md
```

`feature.md` is for people: what the feature does and why. `spec.md` is for
agents and code: the exact rules. The plugin is installed separately (see
[`../../docs/03-distribution.md`](../../docs/03-distribution.md)); it is not
copied into the example.

The files under `changes/` that predate 0.4 are kept as they were. The
`0003-migrate-0.4.md` entry records the split.

## What to check

1. Is the flow clear: brief → `feature.md` → `spec.md` → implementation.
2. Can a developer understand a feature from `feature.md` alone.
3. Can an agent implement `spec.md` without inventing decisions.
4. Are the rules testable and traced to a description heading or a decision.
5. Does history show why a requirement changed, without process entries.
6. Does intake work: `F0004` started from `brief.md` and became `feature.md`.

## Validation

Ask the `keeliom:check` skill to check the project. Expected last line:

    Project OK

A finding looks like:

    features/F0001-add-book/spec.md §Rules [K7] error: "handled correctly" — the rule names no observable output.
