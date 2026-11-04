# Check for LLM

You are validating a Keeliom project. Do not modify files unless explicitly
asked.

## Read order

1. `KEELIOM_VERSION`
2. `app.md`
3. `changes/*` if present
4. every `features/F*/feature.md`
5. every `features/F*/brief.md`
6. every `features/F*/changes/*`
7. `RULES.md`
8. `CHECK.md`

`KEELIOM_VERSION` names the project version. If it is older than the template
version, run the current checks and add `Upgrade required: run the upgrade
skill.`

## Mechanical pass

| ID | Check |
|---|---|
| M1 | `app.md` exists and has `Status` (`draft` or `ready`) and the sections `One-liner`, `Users`, `Jobs`, `Scope`, `Non-goals`, `Glossary`, `Invariants`, `Stack`, `Roles`, `Data model`, `API conventions`, `Repositories`. Every `Data model` row has exactly one owner feature; `TBD` is allowed while `Status: draft`. |
| M2 | Feature directories match `F<4 digits>-<slug>/` and are unique. |
| M3 | Every feature has `feature.md`. `brief.md` is non-empty if present. |
| M4 | `feature.md` has `Status` and the sections `Why`, `Who`, `Depends on`, `Reads`, `Related`, `In scope`, `Out of scope`, `Rules`, `Acceptance`, `Tasks`, `Decisions`, `Open questions`. `Release:` is absent, `None`, or a value. `Repositories:` is absent, `None`, or a comma-separated list. |
| M5 | `Status` is `draft`, `ready`, `in_progress`, `done` or `deprecated`. |
| M6 | No `TBD` in a non-draft feature or in `app.md` with `Status: ready`. No `TBD` in a change entry except inside a backtick quote in `Before` or `After`. An `Open:` line in `app.md` matches `Open: <item> — owner: <name or F00xx>, due: <YYYY-MM-DD>`. An owner feature ID must exist. |
| M7 | `Acceptance` and `Tasks` contain only checkboxes and at least one checkbox, unless `Status` is `draft`. |
| M8 | Optional sections are non-empty or `None`: `Locales` and `Accessibility` in `app.md`; `Data`, `API` and `Screens` in `feature.md`. |
| M9 | `Depends on` and `Reads` reference existing feature IDs or are `None`. |
| M10 | Every feature has `changes/0001-initial.md`. |
| M11 | Change files are sequential and contain `Date`, `Reason`, `Changed`, and a valid `Related`. For entries without `Keeliom:`, `Related` may contain code paths. Every feature has an entry with `Keeliom:`. Once a feature has an entry with `Keeliom:`, every later entry has `Keeliom:`. When an entry has `Keeliom: 0.2.0` or later, it also has `Decisions` and `Source`. |
| M12 | Relative Markdown links to `.md` files resolve. |
| M13 | In `feature.md`, every `F\d{4}` outside `Depends on` and `Reads` appears in `Depends on`, `Reads` or `Related`. |
| M14 | The `Depends on` graph is acyclic. `Reads` may be cyclic. When `Release:` is present and is not `None`, a feature depends only on the same or an earlier release. |
| M15 | `done` has all Acceptance and Tasks boxes checked. |
| M16 | When `Status` is `ready` or `done`, scan `Out of scope`, `Rules`, `Data`, `API` and `Tasks`. Each `later`, `decide with`, `as before`, `if needed` or `probably` carries an answer and a source, `Deferred to: F00xx`, or `Deferred: Not planned — <reason>`. The feature ID in `Deferred to:` must exist. |
| M17 | `Open questions` uses `Q<n>. <question>` followed by `Recommendation:`, `Owner:` and `Status: open` or `Status: answered (D<n>)`. `None` only at zero. `Recommendation: None` requires ` — <reason>`. |
| M18 | Every question with `Status: open` is open. Every `Status: answered (D<n>)` names an existing Decision. Every Decision has `ID`, `From` (`Q<n>`, `legacy §<section>`, or `None`), `Question`, `Answer`, `Source`, `Status` (`approved` or `assumed`) and `Date` (`YYYY-MM-DD`). `From: None` means the decision has no predecessor question; it says nothing about the feature's open questions. When `Status` is `ready` or `done`, no question has `Status: open` and every Decision is `approved`. |
| M20 | Every change entry has non-empty `Before` and `After`. For follow-up entries with `Keeliom: 0.3.0` or later, `After` contains a backtick quote. `0001-initial.md` is exempt. |
| M21 | `Related` values are feature IDs or `None`. Code paths appear only in `Source`. This applies to entries with `Keeliom:`; old entries may contain code paths. |
| M22 | `deprecated` has `Replaced by: F00xx`. The target exists and is not deprecated. |
| M23 | A feature's first change entry with `Keeliom: 0.2.0` or later has `Source`. If `brief.md` exists, `Source` includes `brief.md`. |
| M24 | Every path in a feature's `Repositories:` matches a row in `app.md` `Repositories`. The line is absent when `app.md` has one row and required when it has more than one. Every `Repositories` row has a non-empty `Test commands` value. `None — <reason>` is a warning. |
| M25 | Project-level `changes/` entries are sequential and contain `Keeliom`, `Date`, `Reason`, `Changed`, `Before`, `After`, `Related`, `Corrects`, `Decisions` and `Source`. |

M19 is retired. M1 and M4 now require the current sections for every project,
and `upgrade` handles the migration. M20–M25 keep their numbers.

## Semantic pass

The semantic pass is required. A runner may not skip it because the text looks
plausible. Every finding quotes the text it refers to.

Do not invent content. Report contradictions with quoted evidence.

| ID | Check |
|---|---|
| S1 | Contradictions: `In scope` vs `Out of scope`; `Rules` vs `Out of scope`; `In scope` vs `API`; `Data` vs `API`; `Acceptance` vs `Rules`; `Who` vs `Users`. Error tables have `Code`, `Status`, `When`. API responses cover generated and returned `Data` fields. Every `API` response follows the `API conventions` single-resource or collection shape. Every search endpoint follows the `Search` rule. |
| S2 | Scope coverage: every `In scope` bullet has a Task, an Acceptance line, or `(F00xx)` delegation. |
| S3 | Terminology and naming: role values match `Roles`; entity names match `Data model`; field names match the owning feature's `Data`; route names match the owning feature's `API`; a term used for the same concept is not mixed (for example, a game status must not also be called state). |
| S4 | Acceptance measurability: each criterion names an observable output (a status code, an error code, a message, a field value, or a visible state), an action with an observable result, a threshold with a unit, or a test reference. Vague words such as `clear`, `fast` and `correct` need a concrete output. |
| S5 | Source coverage: every section of `brief.md` lands in a feature section. When `brief.md` is absent, every section of the document named in the first change entry's `Source` lands in a feature section. |
| S6 | Shared-rule drift: a rule attached to a shared entity in one feature appears in every feature that touches the entity, or references the owning feature. |
| S7 | Implicit dependency: an `In scope`, `Rules`, `API`, `Screens` or `Acceptance` line that names behavior owned by another feature must be in `Depends on`. A `Data` or `API` line that names an entity owned by another feature must be in `Reads`. |
| S8 | Change-entry accuracy: each entry's `Reason`, `Before` and `After` are consistent with the entry before it. For the newest follow-up entry with `Keeliom: 0.3.0` or later in each `changes/` directory, the `After` quote appears in the current `feature.md`; for a project-level entry, it appears in the current `app.md`. `Before` is not checked. An entry named in a later entry's `Corrects` field is treated as corrected. |
| S9 | Traceability: every Screen state and Acceptance criterion has a Rule. Every Rule has a matching Acceptance criterion, a named Screen state, or a `test:<name>` reference. A Task alone is not enough. |

S6 and S7 are project-level checks. CHECK runs them once for the project. A
finding names both features and counts against each named feature's result and
`Project OK`.

## Code pass

Run only when `Repositories` is filled. If the code cannot be read, report
`unverifiable`. Do not report it as verified.

| ID | Check |
|---|---|
| C1 | Every entity, field, route and method in `Data`, `API` or `Rules` exists in code or is named in a Task that says `add <field>`, `add <entity>`, `add <route>` or `add <method>`. A Task that only mentions the name is not an addition. Run C1 once for each repository in the feature's `Repositories:`. When the line is absent, run it for the single `app.md` row. A line marked `In <path>:` is checked against that repository only. An unmarked line is checked against every repository in the list. |
| C2 | Role values exist in code. |
| C3 | A capability that exists in code but has no feature is reported as `import-first` and recorded in `TODO.md` as `- import: <capability> — <path>`. |

C1 is per feature. C2 and C3 are project-level checks. CHECK runs them once for
the project. They affect `Project OK` only.

## Severity

| Level | Meaning |
|---|---|
| `error` | Blocks `ready` and `done`. |
| `warn` | Reported. Does not block. |
| `unverifiable` | The check could not run. Counted as a warning. |

Assignments:

- M1–M18 and M20–M25 are `error`.
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

## Output

Findings use:

    path §section [check-id] severity: message

Every message quotes the text it refers to. Sort findings by path, then section, then check ID. Do not print line numbers.

Results use:

    OK features/F0001-add-book
    OK features/F0002-list-books
    features/F0003-edit-book/feature.md §Rules [S3] warn: "status" is used for "state"
    OK features/F0003-edit-book
    OK features/F0004-delete-book
    0 errors, 1 warning, 0 unverifiable
    Project OK

- `error` blocks `ready` and `done`.
- `warn` reports only.
- `unverifiable` counts as a warning.
