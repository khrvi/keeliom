---
name: create-feature
description: Create a Keeliom feature spec from a brief or ticket, asking only for missing decisions.
---

# Create feature

## When to use

When a product owner provides a brief or ticket for a new feature.

## Input

- `features/Fxxxx-<slug>/brief.md`, or a pasted ticket.

## Read order

1. `app.md`
2. `brief.md`
3. `${CLAUDE_PLUGIN_ROOT}/templates/feature/feature.md`
4. `RULES.md`
5. `CHECK.md`

## Process

1. Allocate the ID: list `features/`, take the highest `F<4 digits>` number,
   add one, and zero-pad to four digits. The first feature is `F0001`. IDs are
   never reused.
2. Derive the slug from the feature name: kebab-case, ASCII, no spaces.
3. Create `features/Fxxxx-<slug>/`.
4. If the input is a pasted ticket, write it to
   `features/Fxxxx-<slug>/brief.md` from
   `${CLAUDE_PLUGIN_ROOT}/templates/brief.md`.
5. Extract what is already known from the brief into the template.
6. List missing required sections or decisions.
7. Ask the owner only about missing decisions. For each question:
   - give a recommended default;
   - give 1–3 alternatives;
   - explain the consequence in one line.
8. Do not invent. If the owner does not answer, leave `TBD` and keep
   `Status: draft`.
9. Fill `features/Fxxxx-<slug>/feature.md`.
10. Create `changes/0001-initial.md` with:
    - `Reason: Initial specification from the brief (<source>).`
    - `Related: <feature IDs or None>`.
11. Run the checks from `CHECK.md`.
12. If a check fails, report it and ask; do not silently fix.
13. Do not implement code.

## Output

- `features/Fxxxx-<slug>/feature.md`
- `features/Fxxxx-<slug>/changes/0001-initial.md`
- A short report: assumptions, open questions, `CHECK.md` result.
