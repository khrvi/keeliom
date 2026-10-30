# Generic example — Book Library

This is a neutral example for Keeliom v0.1. It is not a real app and is not tied
to any project.

## Structure

```
generic-app/
  app.md
  RULES.md
  CHECK.md
  KEELIOM_VERSION
  features/
    F0001-add-book/
      feature.md
      changes/
        0001-initial.md
        0002-trim-title.md
    F0002-list-books/
      feature.md
      changes/
        0001-initial.md
    F0003-edit-book/
      feature.md
      changes/
        0001-initial.md
        0002-trim-title.md
    F0004-delete-book/
      brief.md
      feature.md
      changes/
        0001-initial.md
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

    OK

If there are problems, the LLM returns lines like:

    features/F0001-add-book/feature.md: Rules: missing section

## Question

If you were an LLM, would you implement `F0001` from these files without
additional questions? If not, what is missing?
