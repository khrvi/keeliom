# 02 — Conventions

- **Status:** draft
- **Date:** 2026-10-30
- **Related:** [`README.md`](../README.md), [`01-flow.md`](01-flow.md)

## 1. Project structure

```
<project>/
  app.md
  RULES.md
  CHECK.md
  KEELIOM_VERSION
  features/
    F0001-games-list/
      brief.md
      feature.md
      changes/
        0001-initial.md
    F0002-registration/
      brief.md
      feature.md
      changes/
        0001-initial.md
  src/
```

`brief.md` is optional, but if present it must not be empty.

## 2. `app.md`

Required sections:

1. `One-liner` — one sentence about the app.
2. `Users` — who the users are.
3. `Jobs` — what jobs they need to do.
4. `Scope` — what is in scope.
5. `Non-goals` — what is out of scope.
6. `Glossary` — terms.
7. `Invariants` — what is always true.
8. `Stack` — language, framework, database, tests.

## 3. Feature

### 3.1. `brief.md`

A short description from the product owner or a ticket. It does not have to
follow a template. Recommended sections:

- `Source` — ticket/link/author.
- `Raw description` — the original text.
- `Known constraints` — constraints.
- `Acceptance ideas` — acceptance ideas.

`brief.md` is the original intent. The source of truth for behavior is
`feature.md`.

### 3.2. `feature.md`

Every `feature.md` starts with a `Status: <value>` line directly under the
title.

Required sections:

1. `Why` — why the feature exists.
2. `Who` — who uses it.
3. `In scope` — what is included.
4. `Out of scope` — what is excluded.
5. `Rules` — behavior rules.
6. `Acceptance` — acceptance criteria as checkboxes.
7. `Tasks` — tasks as checkboxes.

Optional sections:

- `Depends on` — feature IDs this feature depends on.
- `Data` — entities and fields.
- `API` — endpoints.
- `Screens` — screens and states.
- `Open questions` — open questions.

Rule: if an optional section applies, it is required. If not, write `None`.

### 3.3. Intake

1. The LLM reads `app.md`, `brief.md`, the template, `RULES.md`, and `CHECK.md`.
2. It extracts what is already known into the template.
3. It lists the missing decisions.
4. It asks only about the missing items:
   - recommended default;
   - 1–3 alternatives;
   - one-line consequence.
5. If there is no answer: `TBD` and `Status: draft`.
6. It fills `feature.md`.
7. It creates `changes/0001-initial.md`.
8. It runs `CHECK.md`.
9. It does not write code.

## 4. History: `changes/`

Each feature has a `changes/` directory:

```
changes/
  0001-initial.md
  0002-trim-title.md
```

Rules:

- `0001-initial.md` is required.
- Following files are numbered `0002`, `0003`, ...
- Name: `NNNN-<short-reason>.md`.
- History is append-only: old files are never edited.
- `feature.md` is the current state; `changes/` is how it changed.

Change entry format:

```markdown
# 0002 — Trim title and author

- **Date:** 2026-10-30
- **Reason:** Readers sometimes paste values with spaces.
- **Changed:**
  - `Rules`: title and author are trimmed before saving.
  - `Acceptance`: added a criterion.
- **Before:** values were saved as entered.
- **After:** values are trimmed before saving.
- **Related:** None
```

`Reason` is required. A patch without a reason is not a change entry. A real
diff is optional in v0.1; add `## Diff` later if exactness is needed.

## 5. Naming

- Feature directory: `F0001-games-list/`.
- Spec: `feature.md`.
- Brief: `brief.md`.
- History: `changes/0001-initial.md`.
- kebab-case, ASCII, no spaces.
- IDs: `F0001`–`F9999`, always four digits. No hierarchy or prefixes in v0.1.
- Fixed width keeps lexicographic order.

## 6. Statuses

```
draft -> ready -> in_progress -> done -> deprecated
```

| Status | Meaning |
|---|---|
| `draft` | The feature is being written |
| `ready` | All sections are filled, no TBD |
| `in_progress` | Implementation is underway |
| `done` | Acceptance is met, tasks are closed |
| `deprecated` | The capability was replaced; the feature links to its replacement |

## 7. Changing a feature

- A feature describes a capability, not a change.
- If the same capability changes, edit the existing `feature.md` and add a
  change entry.
- If a new user goal is added, create a new feature.
- If a capability is replaced, mark the old one `deprecated` and link to the new
  one.
- A bug fix edits the existing feature, its `Acceptance`/tests, and adds a
  change entry.
- A cross-cutting change is a new platform feature or an `app.md` update.
- IDs never change and are never reused.
- If behavior changes, move the status back to
  `draft`/`ready`/`in_progress`.
- Add `Depends on` only when the dependency is real.
- If a change relates to a dependency, write it in `Related`.

These rules are copied into the project's `RULES.md`, so a project can change a
feature without the Keeliom repository.

## 8. `CHECK.md`

v0.1 checks:

1. `app.md` exists and has the required sections.
2. Feature directories match `F<4 digits>-<slug>/` (`F0001`–`F9999`) and are
   unique.
3. Every feature has `feature.md`; `brief.md` is optional but must not be empty
   if present.
4. `feature.md` has a `Status: <value>` line and the required sections.
5. `Status` is one of the allowed values.
6. `ready` has no `TBD`.
7. `Acceptance` and `Tasks` contain checkboxes.
8. Optional sections are not empty if present.
9. `Depends on` references existing features or `None`.
10. Every feature has `changes/0001-initial.md`.
11. Change entries are numbered sequentially, contain `Date`, `Reason`, and
    `Changed`, and `Related` references existing features or `None`.
12. Links are not broken.

`CHECK.md` is an instruction for an LLM or a human. No CLI or runtime.

## 9. `RULES.md`, `CHECK.md`, plugin skills

- `RULES.md` — how to generate: read order, intake, change rules, do not
  invent, task order, status updates, required change entry. It is
  self-contained.
- `CHECK.md` — how to validate: checks, output format, do not fix without a
  request.
- Keeliom plugin `bootstrap` — create the project files.
- Keeliom plugin `create-feature` — build a feature from a brief/ticket.
- Keeliom plugin `change-feature` — change a feature and record the reason.
- Keeliom plugin `import-feature` — document an existing feature from code.

All of it is plain Markdown.

## 10. Brownfield

If the project already exists:

- `brief.md` describes **current** behavior, not desired behavior.
- `feature.md` describes what already exists.
- `changes/0001-initial.md` contains `Reason: Imported from existing code.`
- `Related` may contain code paths or feature IDs.
- `Depends on` lists existing features and shared entities.
- Statuses:
  - `done` — the code implements it and acceptance is verified;
  - `in_progress` — there are gaps or unverified behavior;
  - `draft` — documentation is incomplete.
- Do not use `ready` for imported features.
- Do not change code during import.
- Import core/shared first, then the rest.

## 11. What comes next

- **v0.2** — `data.md`, `api.md`, `ui.md` inside a feature.
- **v0.3** — Blueprint → Canon → Living Spec layers.
- **v0.4** — optional tooling.

Do not add anything that the current flow does not need before v0.2.
