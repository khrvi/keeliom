---
name: feature
description: Create or change a Keeliom feature from a brief, ticket or plan, asking only for missing decisions.
---

# Feature

## Input

- A brief path, ticket text or plan path: create a new feature.
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

## New feature

1. Allocate the next `F<4 digits>` and a free slug. Save a pasted brief as
   `features/F00xx-<slug>/brief.md` without editing it.
2. Write `feature.md` from the brief or plan: `Overview`, `Description` by
   topic, `Out of scope`, `Decisions` and `Open questions`. `Source` points to
   the brief, the ticket or the plan.
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
- In `unattended` mode, never invent an owner approval. An unconfirmed choice
  is `assumed` or stays a `Q<n>`.
- When the owner confirms that every open question is answered and every
  condition in `RULES.md §Statuses` holds, set `Status: ready` in the same run.
