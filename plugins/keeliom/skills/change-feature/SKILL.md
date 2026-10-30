---
name: change-feature
description: Change an existing Keeliom feature and record the reason in its history.
---

# Change feature

## When to use

When an existing feature needs a change.

## Input

- feature ID
- change description

## Read order

1. `app.md`
2. `features/Fxxxx-<slug>/feature.md`
3. `features/Fxxxx-<slug>/changes/*`
4. `RULES.md`
5. `CHECK.md`

## Process

1. Allocate the next change number: list `changes/`, take the highest `NNNN`,
   add one, and zero-pad to four digits. The first follow-up is `0002`.
2. Decide: edit the existing feature or create a new one. Use the change rules
   in `RULES.md`.
3. If editing:
   - create `changes/NNNN-<slug>.md` with `Date`, `Reason`, `Changed`,
     `Before`, `After`, `Related`;
   - update `feature.md`;
   - if behavior changed, move `Status` back to
     `draft`/`ready`/`in_progress`.
4. Never edit an existing change entry.
5. Run the checks from `CHECK.md`.
6. Do not implement code.

## Output

- new change entry
- updated `feature.md`
- `CHECK.md` result
