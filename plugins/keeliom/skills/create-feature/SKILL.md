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

1. `app.md`, including `Roles`, `Data model`, `API conventions` and
   `Repositories`
2. `brief.md`
3. `${CLAUDE_PLUGIN_ROOT}/templates/feature/feature.md`
4. `RULES.md`
5. `CHECK.md`

## Process

1. If the input is an existing `features/Fxxxx-<slug>/brief.md`, use that
   directory and ID. Otherwise allocate the next `F<4 digits>` number.
2. Derive the slug from the feature name: kebab-case, ASCII, no spaces.
3. Create `features/Fxxxx-<slug>/`.
4. If the input is a document or ticket, save it as
   `features/Fxxxx-<slug>/brief.md` from
   `${CLAUDE_PLUGIN_ROOT}/templates/brief.md`.
5. Extract what is already known from the brief into the template.
6. List missing required sections or decisions.
7. Check every entity, column, route and method named in `Data`, `API` or
   `Rules` against the repository. Missing ones go to Tasks or Open questions.
   When `Repositories: None`, skip the check and add no open question.
8. Build a source coverage table: every brief section → the feature section
   where it landed.
9. If the code already implements the capability, use `import-feature` first
   and reference the result.
10. Ask the owner only about missing decisions. For each question:
    - give a recommended default;
    - give 1–3 alternatives;
    - explain the consequence in one line.
11. Do not invent. If the owner does not answer, leave `TBD` and keep
    `Status: draft`. In unattended mode, no claim without a source.
12. Fill `features/Fxxxx-<slug>/feature.md` with `Decisions`, `Related` and
    structured `Open questions`.
13. Create `changes/0001-initial.md` with:
    - `Keeliom: <KEELIOM_VERSION>`;
    - `Reason: Initial specification from the brief (<source>).`;
    - `Related: <feature IDs or None>`;
    - `Source: brief.md §section` when a brief exists; otherwise `code:path`
      or `owner:<name>, <date>`.
14. Record a chat answer as `owner:<name>, <date>`.
15. Run the checks from `CHECK.md`.
16. If a check fails, report it and ask; do not silently fix.
17. Do not implement code.

## Output

- `features/Fxxxx-<slug>/feature.md`
- `features/Fxxxx-<slug>/changes/0001-initial.md`
- A short report: assumptions, source coverage, open questions, `CHECK.md`
  result.
