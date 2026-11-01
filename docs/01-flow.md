# 01 — Flow

- **Status:** draft
- **Date:** 2026-10-30
- **Related:** [`README.md`](../README.md),
  [`02-conventions.md`](02-conventions.md)

## 1. Principle

Start simple. In v0.2:

- one app — one `app.md`;
- one feature — one directory `features/F0001-name/`;
- input — `brief.md` or a ticket;
- current state — `feature.md`;
- history — `changes/0001-initial.md`, `0002-...md`;
- `RULES.md` — generation;
- `CHECK.md` — validation;
- Keeliom plugin skills — LLM instructions;
- no CLI, Ruby, Node, terminal, or env.

## 2. Flow

```
0. brief.md or ticket
1. app.md
2. create-feature -> feature.md
3. changes/0001-initial.md
4. CHECK.md
5. LLM/developer reads app.md + brief.md + feature.md + RULES.md
6. implements tasks in order
7. checks tasks, updates status
8. CHECK.md
9. next feature
```

### Intake

- The product owner provides a short description or a ticket.
- The LLM extracts what is already known into the template.
- The LLM asks **only** about missing decisions.
- For each question: recommended default, alternatives, one-line consequence.
- If there is no answer: `TBD` and `Status: draft`.
- The LLM fills `feature.md` and creates `changes/0001-initial.md`.
- The LLM runs `CHECK.md` and reports the result.

### Changing an existing feature

```
1. change-feature
2. changes/NNNN-<slug>.md with a reason
3. update feature.md
4. CHECK.md
```

## 3. Source of truth

- `feature.md` is the current state.
- `changes/` is append-only history.
- `brief.md` is the original intent, not the source of truth for behavior.
- `app.md` + `features/*/feature.md` is the spec.
- Code follows the spec.
- If code and spec disagree, stop and ask.
- If spec and reality disagree, fix the spec, not the code silently.

## 4. Who writes what

| Artifact | Who |
|---|---|
| `brief.md` | product owner |
| `app.md` | owner + LLM |
| `features/*/feature.md` | owner + LLM |
| `features/*/changes/*` | owner + LLM |
| `RULES.md` | framework |
| `CHECK.md` | framework |
| `skills/*` | framework |
| `src/` | developer + LLM |
| `tasks` | developer + LLM |

## 5. Rules

1. One directory per feature.
2. Fixed sections.
3. `Acceptance` uses checkboxes.
4. `Tasks` uses checkboxes.
5. No `TBD` in `ready`.
6. If a decision is missing, the LLM stops and asks.
7. If a section does not apply, write `None`; do not delete the section.
8. Any edit to `feature.md` other than a checkbox or `Status` requires a new
   change entry.
9. Old change entries are never edited.
10. The LLM asks only about missing decisions and offers a default.

## 6. Layers later

The long-term model is **Blueprint → Canon → Living Spec**.

In v0.1 they are merged into one feature file. Split them when there is a real
need:

- the feature file is longer than ~200 lines;
- several people work on the feature;
- separate API/data/UI contracts are needed;
- different views are needed for the owner, the LLM, and the developer.

Until then, layers only add noise.

## 7. Errors

| Error | Detected by |
|---|---|
| Missing required section | `CHECK.md` |
| `TBD` in `ready` | `CHECK.md` |
| Missing `Acceptance` | `CHECK.md` |
| Missing `Tasks` | `CHECK.md` |
| Missing `changes/0001-initial.md` | `CHECK.md` |
| Change without a change entry | review |
| Code without a spec | review |
| Spec without code | review |

## 8. Brownfield: the project already exists

If code already exists, import the existing capabilities first, then reference
and change them.

Order:

1. Inventory: routes, controllers, models, screens, tests.
2. Group by user goal, not by code structure.
3. Import core/shared first: entities, access, navigation.
4. For each capability, use `import-feature`.
5. Imported features: `done` if behavior is verified; `in_progress` if there
   are gaps; `draft` if documentation is incomplete.
6. Do not use `ready` for imported features.
7. Do not change code during import.
8. Only after the import, add new features and changes.

## 9. When to add complexity

- **v0.3** — split a feature into `data.md`, `api.md`, `ui.md`.
- **v0.4** — split Blueprint → Canon → Living Spec.
- **v0.5** — optional tooling.

The signal: people or LLMs start getting confused by the current simple version.
If they do not, do not add complexity.
