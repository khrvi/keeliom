# 01 — Flow

- **Status:** draft
- **Date:** 2026-11-13
- **Related:** [`README.md`](../README.md),
  [`02-conventions.md`](02-conventions.md)

## 1. Principle

Each file has one reader:

- `feature.md` is for developers and product owners.
- `spec.md` is for agents and code.
- `changes/` records why a requirement or a decision changed.
- `STATUS.md` tells anyone the state of the project.

The plugin holds the rules. A project holds its specs.

## 2. Flow

```
0. brief.md, a ticket or a plan
1. setup: app.md and the Keeliom block
2. feature: feature.md first
3. feature: spec.md derived from it
4. changes/NNNN-<slug>.md when a requirement or decision changed
5. check: findings and STATUS.md
6. implement the spec.md rules
7. check passes, then Status: done
```

`feature.md` is agreed before `spec.md` is written. `spec.md` never drives
`feature.md`.

## 3. Intake

- The product owner provides a brief, a ticket or a plan.
- The skill extracts what is already known into `feature.md`.
- It asks only about decisions the input leaves open.
- For each question: a recommendation, one to three alternatives and the
  consequence.
- Without an answer, the item stays `Q<n>` and the feature stays `draft`.
- A pasted brief is saved as `brief.md` and never edited.

## 4. Changing a feature

```
1. feature: add the decision
2. feature: update Description and spec.md rules
3. changes/NNNN-<slug>.md with the reason
4. check
```

Existing rule numbers stay. A new rule gets the next number. A removed rule
retires its number.

## 5. Plans

`plans/` holds human documents that span features: a redesign, a release, a
phase. Keeliom prescribes no sections.

A plan is a proposal. Once its content lands in features, `feature.md` and
`spec.md` are the current truth. Plans are not kept in sync.

A decision or a change entry may cite `plans/<file>.md §<section>` as its
source.

## 6. Source of truth

- `feature.md` and `spec.md` are the current state.
- `changes/` is append-only history.
- `brief.md` is the original intent.
- Code follows `spec.md`. If code and spec disagree, stop and ask.
- If spec and reality disagree, fix the spec, not the code silently.

## 7. Who writes what

| Artifact | Who |
|---|---|
| `brief.md` | product owner |
| `app.md` | owner + agent |
| `feature.md` | owner + agent |
| `spec.md` | owner + agent |
| `changes/*` | owner + agent |
| `plans/*` | owner |
| `STATUS.md` | `check` |
| the plugin's rules and skills | framework |
| the code | developer + agent |

## 8. Brownfield: the project already exists

1. Run `setup mode=existing`. It fills `app.md` from the code, including
   `Repositories`.
2. Inventory the routes, models, screens and tests.
3. Group them by user goal, not by code structure.
4. Run `setup import=<capability>` for the core capabilities first: entities,
   access, navigation.
5. An imported feature gets `Source: code:<path>`. It is never `ready`.
6. Do not change code during import.
7. After the import, add new features and changes normally.

## 9. When to add complexity

The signal: people or agents start getting confused by the current simple
version. If they do not, do not add complexity.
