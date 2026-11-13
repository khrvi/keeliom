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
`RULES.md §Version` says. Run the checks either way. Print a mismatch message
as the last line of the output.

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
- `Repositories` paths in `feature.md` match rows in `app.md`. The line is
  absent when `app.md` has one repository. It is required when `app.md` has
  more than one.
- A `ready` or `done` feature requires `app.md Status: ready`.

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
  `*-migrate-0.4.md`. In it, the five fields are required only in entries
  dated after the migration entry. Older entries must only be sequential.
- Project-level `changes/` follows the same rules.

## Severity

| Level | Meaning |
|---|---|
| `error` | Blocks `ready` and `done`. |
| `warn` | Reported. Does not block. |
| `unverifiable` | The check could not run. Counted as a warning. |

K1–K4 are `error`.

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

Print one line per feature:

    OK features/F0001-add-book

Warnings are listed after the `OK` lines. A warning does not change `OK`.

## Output

Findings use:

    path §section [K<n>] severity: "quote" — message

Quote the text the finding refers to. Do not print line numbers. Sort findings
by path, then section, then check ID.

Example:

    features/F0001-add-book/spec.md §Rules [K2] error: "TBD" — the rule still has a placeholder.
    features/F0001-add-book/changes/0001-initial.md §Source [K4] error: "" — the entry has no Source.
    OK features/F0001-add-book
    OK features/F0002-list-books
    1 error, 0 warnings, 0 unverifiable
    Project OK

The last line is `Project OK` when no errors remain, otherwise
`Project has errors`.

## STATUS.md

The `check` skill writes `STATUS.md`. `CHECK.md` itself writes no file.

The first line is:

    # Status — generated <YYYY-MM-DD> by keeliom:check

Then one table, sorted by feature ID:

    | Feature | Status | Open questions | Assumed decisions | Tasks | Errors |
    |---|---|---|---|---|---|
    | F0001 Add book | done | 0 | 0 | 6/6 | 0 |
    | F0004 Delete book | draft | 2 | 1 | — | 0 |

- `Feature` is the ID, a space, and the title without the dash.
- `Open questions` and `Assumed decisions` are counts.
- `Tasks` is `<ticked>/<total>`, or `—` when the feature has no tasks.
- `Errors` is the number of error findings for the feature.
