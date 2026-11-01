# Rules for LLM — generation

1. If `brief.md` exists, read `app.md`, then `brief.md`, then `feature.md`,
   then `RULES.md`, then `CHECK.md`.
2. Use the `create-feature` skill when it is available. Otherwise follow
   `Creating a feature` below.
3. Use the `change-feature` skill when it is available. Otherwise follow
   `Changing a feature` below.
4. Run the checks from `CHECK.md` first. If there are problems, stop and report
   them.
5. Do not invent decisions. If a required section is missing, empty, or says
   `TBD`, stop and ask.
6. Ask only about missing decisions. For each question, give a recommended
   default and alternatives.
7. If the owner does not answer, leave `TBD` and keep `Status: draft`.
8. Before changing `feature.md`, create a new change entry in
   `changes/NNNN-<slug>.md` with `Date`, `Reason`, `Changed`, `Before`,
   `After`, and `Related`.
9. Never edit an existing change entry. History is append-only.
10. `feature.md` is the current state. `changes/` is the history.
11. Implement tasks in order.
12. After each task, run the tests with the command in `app.md` Stack.
13. Update the task checkboxes.
14. Update `Status` when the feature moves.
15. Do not change scope.
16. If code and spec disagree, stop and ask.
17. When done, run the checks from `CHECK.md` again.
18. Report the files changed and the tests run.

## Creating a feature

1. Allocate the ID: list `features/`, take the highest `F<4 digits>` number,
   add one, and zero-pad to four digits. The first feature is `F0001`. IDs are
   never reused.
2. Derive the slug from the feature name: kebab-case, ASCII, no spaces.
3. Create `features/Fxxxx-<slug>/`.
4. If the input is a pasted ticket, save it as `brief.md` with `Source`,
   `Raw description`, `Known constraints`, and `Acceptance ideas`.
5. Extract what is already known into the sections required by `CHECK.md`.
6. List the missing decisions.
7. Ask only about the missing items: recommended default, 1–3 alternatives,
   one-line consequence.
8. If there is no answer, leave `TBD` and keep `Status: draft`.
9. Write `feature.md` and `changes/0001-initial.md`.
10. Run `CHECK.md` and report the result.
11. Do not write code.

## Changing a feature

1. Allocate the next change number: list `changes/`, take the highest `NNNN`,
   add one, and zero-pad to four digits. The first follow-up is `0002`.
2. A feature describes a capability, not a change.
3. If the same capability changes, edit `feature.md` and add the change entry.
4. If a new user goal is added, create a new feature.
5. If a capability is replaced, set the old feature's `Status` to `deprecated`
   and link to the new feature.
6. A bug fix edits the existing feature, its `Acceptance`/tests, and adds a
   change entry.
7. A cross-cutting change is a new platform feature or an `app.md` update.
8. IDs never change and are never reused.
9. If behavior changes, move `Status` back to `draft`, `ready`, or
   `in_progress`.
10. Add `Depends on` only when the dependency is real.
11. If a change relates to a dependency, write it in `Related`.

## Definition of done

- All `Acceptance` checkboxes are checked.
- All `Tasks` checkboxes are checked.
- `Status` is `done`.
- Tests pass.
- `CHECK.md` reports `OK`.
