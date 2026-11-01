# Check for LLM

You are validating a Keeliom project. Do not modify files unless explicitly
asked.

## Read order

1. `KEELIOM_VERSION`
2. `app.md`
3. every `features/F*/feature.md`
4. every `features/F*/brief.md`
5. every `features/F*/changes/*`
6. `RULES.md`
7. `CHECK.md`

## Mechanical pass

| ID | Check |
|---|---|
| M1 | `app.md` exists and has `One-liner`, `Users`, `Jobs`, `Scope`, `Non-goals`, `Glossary`, `Invariants`, `Stack`. For `KEELIOM_VERSION` 0.2 or later, also `Roles`, `Data model`, `API conventions`, `Repositories`. |
| M2 | Feature directories match `F<4 digits>-<slug>/` and are unique. |
| M3 | Every feature has `feature.md`. `brief.md` is non-empty if present. |
| M4 | `feature.md` has `Status` and the required sections. On 0.1.0: `Why`, `Who`, `In scope`, `Out of scope`, `Rules`, `Acceptance`, `Tasks`. On 0.2.0: also `Depends on`, `Related`, `Decisions`, `Open questions`. On 0.2.2: `Release:` is absent, `None`, or a value; `Repositories:` is absent, `None`, or a comma-separated list. |
| M5 | `Status` is `draft`, `ready`, `in_progress`, `done` or `deprecated`. |
| M6 | No `TBD` or `<...>` placeholders in a non-draft feature or in `app.md`. No `Keeliom: <version>` or `Date: YYYY-MM-DD` in a change entry. An `Open:` line in `app.md` matches `Open: <item> — owner: <name or F00xx>, due: <YYYY-MM-DD>`. An owner feature ID must exist. |
| M7 | `Acceptance` and `Tasks` contain only checkboxes and at least one checkbox, unless `Status` is `draft`. |
| M8 | Optional sections (`Depends on`, `Data`, `API`, `Screens`, `Open questions`) are non-empty or `None`. |
| M9 | `Depends on` references existing feature IDs or is `None`. |
| M10 | Every feature has `changes/0001-initial.md`. |
| M11 | Change files are sequential and contain `Date`, `Reason`, `Changed`, and a valid `Related`. For entries without `Keeliom:`, `Related` may contain code paths. On a 0.2.0 or later project, every feature has an entry with `Keeliom:`. Once a feature has an entry with `Keeliom:`, every later entry has `Keeliom:`. When an entry has `Keeliom: 0.2.0` or later, it also has `Decisions` and `Source`. |
| M12 | Relative Markdown links to `.md` files resolve. |
| M13 | Every `F\d{4}` outside `Depends on` appears in `Depends on` or `Related`. |
| M14 | The `Depends on` graph is acyclic. When `Release:` is present and is not `None`, a feature depends only on the same or an earlier release. |
| M15 | `done` has all Acceptance and Tasks boxes checked. |
| M16 | When `Status` is `ready` or `done`, scan `Out of scope`, `Rules`, `Data`, `API` and `Tasks`. Each `later`, `TBD`, `decide with`, `as before`, `if needed` or `probably` carries an answer and a source, `Deferred to: F00xx`, or `Deferred: Not planned — <reason>`. The feature ID in `Deferred to:` must exist. |
| M17 | `Open questions` uses `Q<n>. <question>` followed by `Recommendation:`, `Owner:` and `Status: open` or `Status: answered (D<n>)`. `None` only at zero. `Recommendation: None` requires ` — <reason>`. |
| M18 | Every question with `Status: open` is open. Every `Status: answered (D<n>)` names an existing Decision. Every Decision has `ID`, `From` (`Q<n>`, `legacy §<section>`, or `None`), `Question`, `Answer`, `Source` and `Date` (`YYYY-MM-DD`). `From: None` is allowed only when no question exists. When `Status` is `ready` or `done`, no question has `Status: open`. |
| M19 | Required sections depend on `KEELIOM_VERSION`. Older projects get warnings with a migration instruction. |
| M20 | Every change entry has non-empty `Before` and `After`. |
| M21 | `Related` values are feature IDs or `None`. Code paths appear only in `Source`. This applies to entries with `Keeliom:`; old entries may contain code paths. |
| M22 | `deprecated` has `Replaced by: F00xx`. The target exists and is not deprecated. |
| M23 | A feature's first change entry with `Keeliom: 0.2.0` or later has `Source`. If `brief.md` exists, `Source` includes `brief.md`. |
| M24 | Every path in a feature's `Repositories:` matches a row in `app.md` `Repositories`. The line is absent when `app.md` has one row and required when it has more than one. Every `Repositories` row has a non-empty `Test commands` value. `None — <reason>` is a warning. |
| M25 | Project-level `changes/` entries are sequential and contain `Keeliom`, `Date`, `Reason`, `Changed`, `Before`, `After`, `Related`, `Corrects`, `Decisions` and `Source`. |

## Semantic pass

The semantic pass is required. A runner may not skip it because the text looks
plausible. Every finding quotes the text it refers to.

Do not invent content. Report contradictions with quoted evidence.

| ID | Check |
|---|---|
| S1 | Contradictions: `In scope` vs `Out of scope`; `Rules` vs `Out of scope`; `In scope` vs `API`; `Data` vs `API`; `Acceptance` vs `Rules`; `Who` vs `Roles`. Error tables have `Code`, `Status`, `When`. API responses cover generated and returned `Data` fields. |
| S2 | Scope coverage: every `In scope` bullet has a Task, an Acceptance line, or `(F00xx)` delegation. |
| S3 | Terminology and naming: role values match `Roles`; table names match `Data model`; column names match the owning feature's `Data`; route names match the owning feature's `API`; a term used for the same concept is not mixed (for example, a game status must not also be called state). |
| S4 | Acceptance measurability: each criterion names an observable output (a status code, an error code, a message, a field value, or a visible state), an action with an observable result, a threshold with a unit, or a test reference. Vague words such as `clear`, `fast` and `correct` need a concrete output. |
| S5 | Source coverage: every brief section lands in a feature section. |
| S6 | Shared-rule drift: a rule attached to a shared entity in one feature appears in every feature that touches the entity, or references the owning feature. |
| S7 | Implicit dependency: an Acceptance criterion or Rule that names behavior owned by another feature must be in `Depends on`. |
| S8 | Change-entry accuracy: each entry's `Reason`, `Before` and `After` are consistent with the entry before it. An entry named in a later entry's `Corrects` field is treated as corrected. |
| S9 | Traceability: every Screen state and Acceptance criterion has a Rule. Every Rule has a matching Acceptance criterion or a named Screen state. A Task alone is not enough. |

S6 and S7 are project-level checks. CHECK runs them once for the project. A
finding names both features and counts against each named feature's result and
`Project OK`.

## Code pass

Run only when `Repositories` is filled. If the code cannot be read, report
`unverifiable`. Do not report it as verified.

| ID | Check |
|---|---|
| C1 | Every table, column, route and method in `Data`, `API` or `Rules` exists in code or is named in a Task as an addition. Run C1 once for each repository in the feature's `Repositories:`. When the line is absent, run it for the single `app.md` row. A line marked `In <path>:` is checked against that repository only. An unmarked line is checked against every repository in the list. |
| C2 | Role values exist in code. |
| C3 | A capability that exists in code but has no feature is reported as `import-first`. |

C1 is per feature. C2 and C3 are project-level checks. CHECK runs them once for
the project. They affect `Project OK` only.

## Severity

| Level | Meaning |
|---|---|
| `error` | Blocks `ready` and `done`. |
| `warn` | Reported. Does not block. |
| `unverifiable` | The check could not run. Counted as a warning. |

Assignments:

- M1–M25 are `error`.
- S1 is `error`.
- S2, S4, S5, S8 and S9 are `error` when `Status` is `ready` or `done`. They
  are `warn` otherwise.
- S6 and S7 are `error` when either affected feature is `ready` or `done`.
  They are `warn` otherwise. A finding blocks both named features.
- S3 is `warn`.
- C1–C3 are `error` when the code is readable. They are `unverifiable`
  otherwise.
- C2 and C3 are project-level. They affect `Project OK` only.

## OK

`CHECK.md` prints `Project OK`. A feature is `OK` when its own checks have zero
errors, including S6 or S7 findings that name it. A finding in one feature does
not change another feature's result. `Project OK` requires every feature result
to be OK and `app.md` to pass its checks. C2 and C3 affect `Project OK` only.
Warnings and unverifiable findings are listed after `OK`.

## Code pass without a repository

`Repositories: None` skips C1–C3. A Markdown-only project uses
`Repositories: None`.

## Version gate

For `KEELIOM_VERSION` 0.1.0:

- `error`: M2–M12, M14, S1.
- `warn`: M13, M15–M24, S2, S4–S9.
- `skipped`: S3, C1–C3. S3 needs `Roles` and `Data model`, which 0.1.0
  projects do not have.
- M1 keeps its current behavior and warns for the four new `app.md` sections.
- M4 on 0.1.0 requires only the old sections.
- M11 on 0.1.0 requires only the old fields.
- M24 is required only when `Repositories` has more than one row.
- On 0.1.0, S1's error-table, `Roles` and response-coverage clauses are `warn`;
  the contradiction clauses are `error`.
- M6 on 0.1.0 checks only that `ready` has no `TBD`. Placeholders and `app.md`
  are `warn`.

For `KEELIOM_VERSION` 0.2.0 and 0.2.1, the 0.2.2 header fields, the Decisions
`Date` column and the `Open questions` grammar are `warn` with a migration
instruction. For 0.2.2 and earlier, M25 and the `Open:` and deferral forms are
`warn`. For 0.2.3 and later, the severity table above applies.

## Output

Findings use:

    file: section: check-id: severity: problem

Results use:

    OK features/F0001-add-book
    OK features/F0002-list-books
    features/F0003-edit-book/feature.md: Rules: S3: warn: "status" is used for "state"
    OK features/F0003-edit-book
    OK features/F0004-delete-book
    0 errors, 1 warning, 0 unverifiable
    Project OK

- `error` blocks `ready` and `done`.
- `warn` reports only.
- Every finding quotes the text it refers to.
