# Keeliom checks

You are checking a Keeliom project. Do not modify any file.
`RULES.md` holds the formats. This file holds the checks and the result format.

## Read order

1. `app.md`
2. `changes/*` at the project root
3. `plans/*` only when a `Source` cites a plan
4. every `features/F*/feature.md`
5. the same feature's `spec.md`
6. the same feature's `changes/*`

A missing required file is a K1 finding.

## Version

Compare `app.md` `Keeliom:` with the installed plugin version as
`RULES.md §Version` says.

- Project older: run the checks, then print
  `Migration required: run the migrate skill.` as the last line.
- Project newer: print
  `Plugin is older than the project: update the keeliom plugin.` and stop.

## Checks

### K1 — Structure

- `app.md` exists. It has `Keeliom:`, `Status` (`draft` or `ready`), and the
  required sections from `RULES.md §app.md`.
- Each feature directory is `F<4 digits>-<slug>` and unique.
- Each feature has `feature.md` and `spec.md`. A present `brief.md` is
  non-empty.
- `feature.md` has `Status` and `Source`, and the required sections from
  `RULES.md §feature.md`. `Status` is `draft`, `ready`, `done` or
  `deprecated`.
- `deprecated` has `Replaced by: F00xx`. The target exists and is not
  deprecated.
- `spec.md` has `Depends on`. Every feature ID there exists. A cycle is not a
  finding.
- `Repositories` paths in `spec.md` match rows in `app.md`. The line is
  optional when `app.md` has at most one repository. It is required when
  `app.md` has more than one.
- When the project has code (`RULES.md §Project layout`), or a feature has
  `Source: code:<path>`, `app.md` has a `Repositories` section.
- A `ready` or `done` feature requires `app.md Status: ready`.
- An `app.md` `Capabilities` table has the exact `Capability | Owner | Notes`
  header. Capability names are unique, and every `Owner` names an existing
  feature. A missing section or `None` is valid.

### K2 — No pending work

- A `ready` or `done` feature contains no `TBD`.
- A `ready` or `done` feature has no open question in `Open questions`.
- A `ready` `app.md` contains no `TBD`.

### K3 — Decisions

- Each row has `ID`, `Decision`, `Source` and `Status`.
- `Status` is `approved`, `assumed`, or `replaced by D<n>`.
- A `ready` or `done` feature has no `assumed` decision.
- `replaced by D<n>` names a decision that exists in the same feature.
- No `Source` is the feature's own `spec.md`.

### K4 — Change history

- A feature's `changes/` files are sequential from `0001`. A gap or a reused
  number is a finding.
- Every entry has `Date`, `Reason`, `Changed`, `Decisions` and `Source`.
  `Decisions` may be `None`.
- Every Decision ID in `feature.md` appears in at least one entry's
  `Decisions`, or in the project-level migration entry.
- A migrated project is one with a project-level entry named
  `*-migrate-0.4.md` or `*-migrate-0.5.md`. In it, the five fields are required
  only in entries dated after the migration entry. An entry dated the same day counts as
  older. Older entries must only be sequential.
- Project-level `changes/` follows the same rules.

### K5 — Traceability and coverage

- Every rule ends with a reference to an existing `Description` subsection of
  the same feature (§<heading>), an existing Decision (D<n>), or both.
- Every `Description` subsection is referenced by at least one rule.
- Rule IDs are unique within a feature. Gaps are allowed: a retired number is
  not reused.
- Every `F00xx R<n>` citation names an existing feature and an existing rule
  in it.
- Cycle or not, `Depends on` is not a K5 subject.

### K6 — Contradictions

- `Description` against `Out of scope`.
- `spec.md` against `feature.md`.
- `spec.md` against `app.md` `Invariants` and `Conventions`.
- Rules against other Rules, and Rules against `Data`, `API` and `Screens` in
  the same spec. Compare any two explicit closed definitions in those sections.
- A definition is closed only with `one of`, `only`, `exactly`, `complete`, or
  an equivalent limit. Examples, illustrative responses, open-ended lists and
  unmarked field projections are open. A Data table may contain only the fields
  used by this feature.
- Named states, outcomes, fields and errors must agree with an explicit closed
  definition that excludes them.
- Separate counters for an operation's named outcomes cover every mutually
  exclusive outcome of that operation. A later outcome needs its own counter,
  or an explicit statement that excludes it from counting. This comparison needs
  no closed-list marker.
- Do not infer an unnamed state or outcome from a verb alone.
- Quote both sides of a contradiction.

### K7 — Testable rules

- A rule names an observable output: a status code, an error code, a message,
  a field value, or a visible state. A value with a unit or a `test:<name>` is
  also enough.
- A word such as `clear`, `fast`, `correct`, `properly` or `handled correctly`
  is not testable unless the rule also names the output.
- A reference such as `selected`, `chosen`, `configured`, `agreed`, or an
  owner's value needs a concrete definition in the same rule, another cited
  rule, the feature, or `app.md`. The reference is unresolved when no definition
  supplies that value or policy. A concrete approved or assumed Decision can
  supply the definition; K3 still decides whether an assumption blocks ready.
- These references are semantic, never substring findings. A defined configured
  preference or a selected collection used as a domain term is not unresolved.
- A matching `Q<n>` records an unresolved choice but does not make its rule
  testable. A `test:<name>` also does not resolve an undefined value or policy.

### K8 — Cross-feature

- A rule about a shared entity agrees across every feature that states it.
  Quote both rules.
- Behavior or data owned by another feature appears in `Depends on`. The owner
  comes from `app.md §Data model`.
- Semantic use of a capability owned by another feature also appears in
  `Depends on`. The owner comes from `app.md §Capabilities`. Declaring a
  capability creates no dependency, self-use needs no self-dependency, and a
  word substring alone does not prove use.
- Terms match `app.md §Glossary`, `§Roles` and `§Data model`. A term mismatch
  is `warn`.
- Cycles in `Depends on` are never a finding.

### K9 — Code

- Entities, fields, routes and roles named in `spec.md` exist in code, or a
  `Tasks` item says `add <x>`.
- A capability in code with no feature is `import-first`. It is `warn`.
- A `ready` feature whose rules are all implemented is flagged `set done`.
- Run per repository. `In <repo>:` restricts a line to that repository. An
  unmarked line is checked against every repository.
- Skip K9 when `app.md` has no `Repositories` section, or when the feature has
  `Repositories: None`.
- Report `unverifiable` when the code cannot be read.

Content language never causes a finding.

## Severity

| Level | Meaning |
|---|---|
| `error` | Blocks `ready` and `done`. |
| `warn` | Reported. Does not block. |
| `unverifiable` | The check could not run. Counted as a warning. |

- K1–K4 and K6 are `error`.
- K5 and K7 are `error` when the feature is `ready` or `done`. They are `warn`
  otherwise.
- K8 is `error` when either affected feature is `ready` or `done`, and `warn`
  otherwise. A term mismatch is always `warn`.
- K9 is `error` when the code is readable, `unverifiable` otherwise. Its
  `import-first` and `set done` findings are `warn`.

## Overrides

Read `app.md §Check overrides`. Each bullet names a check ID and the reason.
Apply the exception to that check for the named subject only.

Print every applied override after the findings, as:

    override: <the bullet text>

Never apply an override to a missing required file.

## OK

A feature is `OK` when its own checks have no errors. `app.md` passes when it
has no errors. `Project OK` requires every feature result and `app.md` to be
`OK`.

Print one line per feature that has no errors:

    OK features/F0001-add-book

A feature with an error gets no `OK` line. Its findings are its result.
Warnings are listed after the `OK` lines. A warning does not change `OK`.

## Output

Findings use:

    path §section [K<n>] severity: "quote" — message

Quote the text the finding refers to. Do not print line numbers. Sort findings
by path, then section, then check ID.

Example:

    features/F0001-add-book/spec.md §Rules [K2] error: "TBD" — the rule still has a placeholder.
    features/F0001-add-book/changes/0001-initial.md §Source [K4] error: "" — the entry has no Source.
    OK features/F0002-list-books
    2 errors, 0 warnings, 0 unverifiable
    Project has errors

The last line is `Project OK` when no errors remain, otherwise
`Project has errors`.

## STATUS.md

The `check` skill writes `STATUS.md`. `CHECK.md` itself writes no file.

The first line is:

    # Status — generated <YYYY-MM-DD> by keeliom:check

Then one table, sorted by feature ID:

    | Feature | Status | Open questions | Assumed decisions | Tasks | Errors | Warnings |
    |---|---|---|---|---|---|---|
    | F0001 Add book | done | 0 | 0 | 6/6 | 0 | 0 |
    | F0004 Delete book | draft | 2 | 1 | — | 0 | 1 |

- `Feature` is the ID, a space, and the title without the dash.
- `Open questions` and `Assumed decisions` are counts.
- `Tasks` is `<ticked>/<total>`, or `—` when the feature has no tasks.
- `Errors` is the number of error findings for the feature.
- `Warnings` is the number of `warn` and `unverifiable` findings for the
  feature.
