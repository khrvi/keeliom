# Generic example — Book Library

This is a neutral example for Keeliom v0.3.0. It is not a real app and is not
tied to any project.

## Structure

```
generic-app/
  app.md
  RULES.md
  CHECK.md
  KEELIOM_VERSION
  changes/
    0001-data-model-readers.md
    0002-app-0.3.0.md
  features/
    F0001-add-book/
      feature.md
      changes/
        0001-initial.md
        0002-trim-title.md
        0003-correct-reason.md
        0004-isbn-invalid.md
        0005-migrate-0.3.0.md
    F0002-list-books/
      feature.md
      changes/
        0001-initial.md
        0002-error-status.md
        0003-data-reference.md
        0004-migrate-0.3.0.md
    F0003-edit-book/
      feature.md
      changes/
        0001-initial.md
        0002-trim-title.md
        0003-isbn-rules.md
        0004-data-reference.md
        0005-migrate-0.3.0.md
    F0004-delete-book/
      brief.md
      feature.md
      changes/
        0001-initial.md
        0002-success-and-failure.md
        0003-data-reference.md
        0004-migrate-0.3.0.md
```

The Keeliom plugin is installed separately (see
[`../../docs/03-distribution.md`](../../docs/03-distribution.md)); it is not
copied into the example.

## What to check

1. Is the flow clear: brief → `app.md` → feature → `RULES.md` → implementation.
2. Can an LLM implement a feature without inventing decisions.
3. Are all required sections present.
4. Are acceptance criteria observable.
5. Are the rules sufficient to avoid guessing.
6. Does history work: `F0001` and `F0003` have an initial and a follow-up change
   with a reason.
7. Does intake work: `F0004` started from `brief.md` and became `feature.md`.

## Validation

Ask the LLM to read `CHECK.md` and validate the project. Expected result:

    Project OK

If there are problems, the LLM returns lines like:

    features/F0001-add-book/feature.md §Screens [S3] warn: "status" is used for "state"

## Question

If you were an LLM, would you implement `F0001` from these files without
additional questions? If not, what is missing?
