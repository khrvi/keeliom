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
3. `features/Fxxxx-<slug>/brief.md` if present
4. `features/Fxxxx-<slug>/changes/*`
5. `RULES.md`
6. `CHECK.md`

## Process

1. Allocate the next change number: list `changes/`, take the highest `NNNN`,
   add one, and zero-pad to four digits. The first follow-up is `0002`.
2. Decide: edit the existing feature or create a new one. Use the change rules
   in `RULES.md`.
3. If editing:
   - create `changes/NNNN-<slug>.md` with `Keeliom`, `Date`, `Reason`,
     `Changed`, `Before`, `After`, `Related`, `Corrects`, `Decisions`, and
     `Source`;
   - update `feature.md`;
   - update `Repositories:` when the set of repositories changes;
   - move `Status` with the table in `RULES.md`.
4. Never edit an existing change entry. To correct one, add a new entry with
   `Corrects: NNNN`.
5. Record a chat answer as `owner:<name>, <date>`.
6. When moving to `ready`: re-read the source, verify each claim, write
   Decisions with sources, and run the S and C passes from `CHECK.md`.
7. Every new change entry has `Keeliom: <KEELIOM_VERSION>`, Decision IDs and
   `Source`.
8. Run the checks from `CHECK.md`.
9. Do not implement code.

## Output

- new change entry
- updated `feature.md`
- `CHECK.md` result
