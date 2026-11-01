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

1. If the code already implements the capability, use `import-feature` first
   and stop.
2. If the input is an existing `features/Fxxxx-<slug>/brief.md`, use that
   directory and ID. Skip steps 3–5.
3. Otherwise allocate the next `F<4 digits>` number: list `features/`, take the
   highest, add one, and zero-pad to four digits. IDs are never reused.
4. Derive the slug from the feature name: kebab-case, ASCII, no spaces.
5. Create `features/Fxxxx-<slug>/`.
6. If the input is a pasted ticket or an external document outside the feature
   directory, save it as `features/Fxxxx-<slug>/brief.md` from
   `${CLAUDE_PLUGIN_ROOT}/templates/brief.md`.
7. Extract what is already known from the brief into the sections required by
   `CHECK.md` M4.
8. List missing required sections or decisions.
9. Check every entity, column, route and method named in `Data`, `API` or
   `Rules` against the repository named by `In <path>:`. Check an unmarked
   claim against every repository in the feature's list. Missing ones go to
   Tasks or Open questions. When `Repositories: None`, skip the check and add
   no open question.
10. Build a source coverage table: every brief section → the feature section
    where it landed.
11. Ask the owner only about missing decisions. For each question:
    - give a recommended default;
    - give 1–3 alternatives;
    - explain the consequence in one line.
12. Do not invent. If the owner does not answer, leave `TBD` and keep
    `Status: draft`. In unattended mode, no claim without a source.
13. Fill `features/Fxxxx-<slug>/feature.md` with `Decisions`, `Related` and
    structured `Open questions`. Decisions use
    `ID | From | Question | Answer | Source | Date`. Open questions use
    `Q<n>. <question>` with indented `Recommendation:`, `Owner:` and
    `Status: open`. Add `Release: None`. Add `Repositories:` when `app.md` has
    more than one row; list the paths this feature touches.
14. Create `changes/0001-initial.md` with:
    - `Keeliom: <KEELIOM_VERSION>`;
    - `Reason: Initial specification from the brief (<source>).`;
    - `Related: <feature IDs or None>`;
    - `Source: brief.md §section` when a brief exists; otherwise `code:path`
      or `owner:<name>, <date>`.
15. Record a chat answer as `owner:<name>, <date>`.
16. Run the checks from `CHECK.md`.
17. If a check fails, report it and ask; do not silently fix.
18. Do not implement code.

## Output

- `features/Fxxxx-<slug>/feature.md`
- `features/Fxxxx-<slug>/changes/0001-initial.md`
- A short report: assumptions, source coverage, open questions, `CHECK.md`
  result.
