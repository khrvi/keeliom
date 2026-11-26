---
name: feature
description: Create or change a Keeliom feature from a brief, ticket or plan, asking only for missing decisions.
---

# Feature

## Input

- A brief path or ticket text: create one new feature.
- An existing path under `plans/`: create or change the complete required
  feature set with `Plan input`.
- `F00xx` and a change description: change an existing feature.
- `unattended`: do not ask questions.

## Read first

1. `${CLAUDE_PLUGIN_ROOT}/rules/RULES.md`
2. `app.md`
3. For a change, the feature's `feature.md`, `spec.md` and `changes/`
4. The templates under `${CLAUDE_PLUGIN_ROOT}/templates/feature/`

## Version

Compare `app.md` `Keeliom:` with the plugin version in
`${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`, ignoring the patch, as
`RULES.md §Version` says.

- Project older: print `Migration required: run the migrate skill.` and stop.
- Project newer: print
  `Plugin is older than the project: update the keeliom plugin.` and stop.

## Order

`feature.md` first. `spec.md` follows it. Never derive `feature.md` from
`spec.md`.

## Plan input

Use this flow for an existing path under `plans/`. It replaces `New feature`
for the complete plan. Do not run that flow once per plan section.

1. Read the complete plan. Inventory its requirements, exclusions, milestones
   and unresolved choices in memory. Never write this inventory to a file.
2. Read every existing feature. Reuse features that already cover included
   work. Create every missing feature with sequential IDs. Name each slug for
   one feature's behavior, such as `list-books`; never reuse the plan filename
   as the feature slug. Existing feature edits follow `Change` steps 1–5 and
   never receive a new initial entry. Defer all checks until the final step.
3. Assign every inventory item to a feature `Description` and `spec.md`, a
   feature `Out of scope`, `app.md` `Non-goals`, or a declared `Q<n>`. Across
   the complete set, no item may remain unassigned.
4. Write new features in the ordinary order: `feature.md`, its derived
   `spec.md`, then `changes/0001-initial.md`. Each `Source` is exactly the
   input plan path, without a `§<section>` suffix. Derive a testable Rule for
   every behavior the plan assigns to a feature. A Rule that uses shared
   behavior names that capability exactly. `Depends on` and the Capabilities
   table never substitute for that Rule.
5. Populate `app.md` `Capabilities` for named shared behavior. Point each
   owner at the feature responsible for that behavior. A feature that uses
   another feature's entity or capability lists its owner in `Depends on`.
6. Change no `app.md` sections other than `Capabilities` and `Non-goals`.
   Update `Non-goals` for project-wide exclusions. Cover all Non-goals changes
   from this run in exactly one new project entry with the five fields and the
   exact plan path as `Source`. Capability metadata alone adds no project
   entry. Do not change `app.md` `Status`. Never edit an old entry.
7. In `unattended` mode, keep every unresolved plan choice as a declared `Q<n>`
   in its affected feature. Keep that feature `draft`. Never turn an
   unconfirmed plan choice into an approved or assumed Decision.
8. Re-read the complete output against the inventory. Correct every omission
   before `check`. Print any remaining unresolved assignment instead of
   claiming complete coverage.
9. Re-read every generated spec for internal consistency. Write complete
   state, outcome and error sets with `one of` or equivalent closed wording and
   named tokens. Give every generated outcome its declared counter, or an
   explicit exclusion from counting. Review dependencies across the full set.
10. Review all writes, then run `keeliom:check` once. Never edit the plan or
    create a coverage artifact.

## New feature

1. Allocate the next `F<4 digits>` and a free slug. Save a pasted brief as
   `features/F00xx-<slug>/brief.md` without editing it.
2. Write `feature.md` from the brief or ticket: `Overview`, `Description` by
   topic, `Out of scope`, `Decisions` and `Open questions`. `Source` points to
   the brief or ticket.
3. Ask only about decisions the input leaves open. Give a recommendation and
   one to three alternatives. In `unattended` mode, leave each open item as a
   `Q<n>` and keep `Status: draft`.
4. Derive `spec.md`: `Depends on`, `Rules` with `R<n>` IDs, and `Data`, `API`,
   `Screens` and `Tasks` only when needed. Every rule ends with `(§<heading>)`,
   `(D<n>)` or both.
5. Write `changes/0001-initial.md` with the five fields. The initial entry
   uses `Reason: Initial specification.` and lists the decisions.
6. Run `keeliom:check`.

## Change

1. Read the feature. When a requirement or a decision changes, add the
   Decision and the change entry before editing the rules.
2. Update `Description` when the user-facing behavior changes.
3. Add the decision as `D<n>` with `Status: approved` when the owner approved
   it, or `assumed` otherwise. When an old decision no longer holds, set its
   status to `replaced by D<n>` and keep its row.
4. Update `spec.md`. Keep every existing rule number. Add new rules with the
   next numbers. Never renumber a rule that stays.
5. Add `changes/NNNN-<slug>.md` only when a requirement or a decision changed.
   `Reason` records the answer, and `recommended: <x>` when the owner overrode
   the recommendation.
6. Run `keeliom:check`.

## Both

- An answered question leaves `feature.md`; the Decision and the entry keep
  the answer.
- Never write code.
- Never edit an old change entry.
- A wording-only fix needs no entry.
- In `unattended` mode, never invent an owner approval. For a brief, ticket or
  existing-feature change, an unconfirmed choice is `assumed` or stays a
  `Q<n>`. `Plan input` always keeps an unconfirmed plan choice as a `Q<n>`.
- When the owner confirms that every open question is answered and every
  condition in `RULES.md §Statuses` holds, set `Status: ready` in the same run.
