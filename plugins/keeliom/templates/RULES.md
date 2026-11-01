# Rules for LLM — generation

## Read order

1. `app.md`
2. `features/Fxxxx-<slug>/feature.md`
3. `features/Fxxxx-<slug>/brief.md` if present
4. `features/Fxxxx-<slug>/changes/*` if present
5. `RULES.md`
6. `CHECK.md`

## Writing specs

1. Use the `create-feature` skill when it is available. Otherwise follow
   `Creating a feature` below.
2. Use the `change-feature` skill when it is available. Otherwise follow
   `Changing a feature` below.
3. Do not invent decisions. If a required section is missing, empty, or says
   `TBD`, stop and ask.
4. Ask only about missing decisions. For each question, give a recommended
   default and alternatives.
5. If the owner does not answer, leave `TBD` and keep `Status: draft`.
6. Before changing `feature.md`, create a new change entry in
   `changes/NNNN-<slug>.md` with `Keeliom`, `Date`, `Reason`, `Changed`,
   `Before`, `After`, `Related`, `Corrects`, `Decisions`, and `Source`.
7. Any edit to `feature.md` other than ticking a Task checkbox or updating
   `Status` requires a change entry.
8. Never edit an existing change entry. History is append-only. To correct an
   entry, add a new entry with `Corrects: NNNN`.
9. `feature.md` is the current state. `changes/` is the history.
10. A decision is written only in `## Decisions`. An answered open question
    moves there. The change entry lists the Decision IDs.
11. `Source` is `path §section`, `code:path`, or `owner:<name>, <date>`.
12. Every new change entry has `Keeliom: <KEELIOM_VERSION>`.

### Creating a feature

1. If the input is an existing `features/Fxxxx-<slug>/brief.md`, use that
   directory and ID. Otherwise list `features/`, take the highest `F<4 digits>`
   number, add one, and zero-pad to four digits. IDs are never reused.
2. Derive the slug from the feature name: kebab-case, ASCII, no spaces.
3. Create `features/Fxxxx-<slug>/`.
4. Save a pasted ticket as `brief.md`.
5. Extract what is already known into the template.
6. List the missing decisions.
7. Ask only about the missing items: recommended default, 1–3 alternatives,
   one-line consequence.
8. If there is no answer, leave `TBD` and keep `Status: draft`.
9. Write `feature.md` and `changes/0001-initial.md` with `Keeliom`, `Decisions`,
   and `Source`.
10. Run `CHECK.md` and report the result.
11. Do not write code.

## Implementing tasks

1. Run the checks from `CHECK.md` first. If there are problems, stop and
   report them.
2. Implement tasks in order.
3. Run the test command for the feature's `Repository` row in `app.md`.
4. After each task, run the tests and update the task checkbox.
5. Update `Status` when the feature moves.
6. Do not change scope.
7. If code and spec disagree, stop and ask.
8. When done, run the checks from `CHECK.md` again.
9. Report the files changed and the tests run.

## Changing a feature

1. List `changes/`, take the highest `NNNN`, add one, and zero-pad to four
   digits. IDs are never reused.
2. A feature describes a capability, not a change.
3. If the same capability changes, edit `feature.md` and add the change entry.
4. If a new user goal is added, create a new feature.
5. If a capability is replaced, set the old feature's `Status` to `deprecated`
   and set `Replaced by`.
6. A bug fix edits the existing feature, its `Acceptance`/tests, and adds a
   change entry.
7. A cross-cutting change is a new platform feature or an `app.md` update.
8. IDs never change and are never reused.
9. If behavior changes, move `Status` with the table below.
10. Add `Depends on` only when the dependency is real.
11. If a change relates to a dependency, write it in `Related`.
12. When moving to `ready`, re-read the source, verify each claim, write
    Decisions with sources, and run the S and C passes.

## Status transitions

| From | To | Condition |
|---|---|---|
| `draft` | `ready` | All required sections filled. No TBD or placeholders. Every open question answered or dropped. Every Decision has a source. |
| `draft` | `draft` | The draft changed. Add a change entry. |
| `ready` | `in_progress` | Implementation started. |
| `in_progress` | `done` | All Acceptance and Tasks boxes checked. Tests pass when a test command exists. CHECK reports OK for the feature. |
| any | `deprecated` | The capability is replaced. `Replaced by:` points to the new feature. |
| `ready`, `in_progress` | `draft` | Scope or decisions changed. The spec needs a rewrite. |
| `done` | `draft` | Behavior changed and the spec needs a rewrite. |
| `done` | `ready` | Behavior changed and the spec is complete, but implementation has not started. |
| `ready` | `ready` | Behavior changed and the spec is complete. Add a change entry. Implementation has not started. |
| `in_progress` | `in_progress` | Behavior changed and the spec is complete. Add a change entry. Implementation continues. |
| `done`, `ready` | `in_progress` | Implementation resumes after a behavior change. |
| `done`, `in_progress`, `ready` | unchanged | Wording or non-behavioral change. Add a change entry. Keep the status. |

## Definition of ready

- `Status: ready`.
- All required sections filled.
- No TBD or placeholders.
- Every open question answered or dropped.
- Every Decision has a source.
- M and S checks pass for the feature.
- C checks pass, or are `unverifiable` with the gap recorded in `Decisions`.
  C checks are skipped only when `Repositories: None`.

## Definition of done

- All Acceptance and Tasks boxes checked.
- Tests pass when a test command exists. When `Repositories: None`, this item
  is skipped.
- The feature's CHECK result has zero errors, including S6 or S7 findings that
  name it.
- `Status: done`.

## Unattended mode

- No owner is available.
- No claim without a source.
- Missing decisions stay TBD.
- `Status` stays `draft`.
- The report lists every gap.
