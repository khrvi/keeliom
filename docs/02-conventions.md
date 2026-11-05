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
  changes/
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

`Status: draft` or `Status: ready`.

Required sections:

1. `One-liner` — one sentence about the app.
2. `Users` — a `| User | Description |` table of domain users.
3. `Jobs` — what jobs they need to do.
4. `Scope` — what is in scope.
5. `Non-goals` — what is out of scope.
6. `Glossary` — terms.
7. `Invariants` — what is always true.
8. `Stack` — language, framework, database. The test command lives in
   `Repositories`.
9. `Roles` — exact access-role values and what each can do.
10. `Data model` — `| Entity | Owner | Key fields | Notes |`. One entity has
    one owner feature. The store type goes in `Stack` and `Notes`.
11. `API conventions` — single-resource shape, collection shape, errors, search
    pagination, field naming, enums, auth, CSRF, sign-in and sign-out,
    idempotency, response coverage.
12. `Repositories` — path, role, language, exact test commands, notes. A
    command may be `None — <reason>`.

Optional sections: `Locales` and `Accessibility`. If not used, write `None`.

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

Every `feature.md` starts with these lines directly under the title:

- `Status: <value>`
- `Release: <value>` optional; `None` when no release is planned.
- `Repositories: <path>[, <path>]` optional; required when `Repositories` has
  more than one row.
- `Replaced by: <F00xx>` only when `Status: deprecated`.

Required sections:

1. `Why` — why the feature exists.
2. `Who` — who uses it.
3. `Depends on` — feature IDs whose behavior this feature calls, or `None`.
4. `Reads` — feature IDs whose data this feature reads or writes, or `None`.
5. `Related` — feature IDs referenced outside `Depends on` and `Reads`, or
   `None`.
6. `In scope` — what is included.
7. `Out of scope` — what is excluded.
8. `Rules` — behavior rules.
9. `Acceptance` — acceptance criteria as checkboxes.
10. `Tasks` — tasks as checkboxes.
11. `Decisions` — table
    `ID | From | Question | Answer | Source | Status | Date`. `From` is `Q<n>`,
    `legacy §<section>`, or `None`. `From: None` means the decision has no
    predecessor question. `Status` is `approved` or `assumed`.
12. `Open questions` — `Q<n>. <question>` followed by `Recommendation:`,
    `Owner:` and `Status: open` or `Status: answered (D<n>)`, or `None`.

Optional sections:

- `Data` — entities and fields.
- `API` — endpoints.
- `Screens` — screens and states.

Rule: if an optional section applies, it is required. If not, write `None`.

A `Data`, `API` or `Tasks` line may start with `In <path>:` when the claim
belongs to one repository. C1 checks that line against that repository.

### 3.3. Intake

1. The LLM reads `app.md`, `brief.md`, the template, `RULES.md`, and `CHECK.md`.
2. It extracts what is already known into the sections required by `CHECK.md`
   M4.
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
- To correct an earlier entry, add a new entry with `Corrects: NNNN`.
- `feature.md` is the current state; `changes/` is how it changed.
- New entries have `Keeliom`, `Decisions` and `Source`.
- `Before` and `After` quote the changed text in backticks.
- The project root has a `changes/` directory for `app.md` changes.

Change entry format:

```markdown
# 0002 — Trim title and author

- **Keeliom:** 0.3.0
- **Date:** 2026-10-30
- **Reason:** Readers sometimes paste values with spaces.
- **Changed:**
  - `Rules`: title and author are trimmed before saving.
  - `Acceptance`: added a criterion.
- **Before:** `values were saved as entered.`
- **After:** `values are trimmed before saving.`
- **Related:** None
- **Corrects:** None
- **Decisions:** D1
- **Source:** owner:product-owner, 2026-10-30
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

Back transitions:

- `ready`, `in_progress` or `done` -> `draft` when scope or decisions change.
- `done` -> `ready` when behavior changes and the spec is complete.
- `done` or `ready` -> `in_progress` when implementation resumes.
- `ready` -> `ready` and `in_progress` -> `in_progress` for a complete behavior
  change. Add a change entry.

| Status | Meaning |
|---|---|
| `draft` | The feature is being written |
| `ready` | The spec is complete and implementation has not started. Every Decision is `approved` |
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
- Add `Depends on` for behavior calls and `Reads` for shared data.
- If a change relates to a dependency or read, write it in `Related`.

These rules are copied into the project's `RULES.md`, so a project can change a
feature without the Keeliom repository.

## 8. `CHECK.md`

v0.3.0 checks:

`CHECK.md` runs three passes:

1. Mechanical (M1–M18 and M20–M25) — sections, IDs, links, fields, status,
   relations, decisions, source and project changes.
2. Semantic (S1–S9) — contradictions, scope coverage, terminology, acceptance
   measurability, source coverage, shared-rule drift, implicit dependency,
   change-entry accuracy and traceability.
3. Code (C1–C3) — entities, fields, routes and roles against the repository.

36 checks: 24 mechanical, 9 semantic, 3 code. One rule set applies to every
project. `KEELIOM_VERSION` only tells `upgrade` whether migration is needed.

`CHECK.md` reports a per-feature result and `Project OK`. See the template for
the exact checks.

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
- `Related` holds feature IDs or `None`. `Source` holds code paths.
- `Depends on` lists behavior calls. `Reads` lists shared data.
- Statuses:
  - `done` — the code implements it and acceptance is verified;
  - `in_progress` — there are gaps or unverified behavior;
  - `draft` — documentation is incomplete.
- Do not use `ready` for imported features.
- Do not change code during import.
- Import core/shared first, then the rest.

## 11. What comes next

- **v0.3.0** — simplification: one rule set, `Reads`, Decisions `Status`.
- **v0.4** — Blueprint → Canon → Living Spec layers.
- **v0.5** — optional tooling.

Do not add anything that the current flow does not need before v0.2.
