---
name: import-feature
description: Document an existing feature from code as a Keeliom feature spec without changing the code.
---

# Import feature from existing code

## When to use

- The project already has code but no Keeliom specs.
- You need to document existing capabilities before new features reference or
  change them.

## Input

- A feature name or user goal.
- Code paths, routes, screens, or a ticket.

## Read order

1. `app.md` (create or update it first if missing)
2. existing `features/*/feature.md`
3. the relevant code
4. `RULES.md`
5. `CHECK.md`

## Process

1. Inventory the capability: routes, controllers, models, views/components,
   tests.
2. Group by user goal, not by code structure.
3. Write `brief.md` describing the **current** behavior (as-is, not to-be).
4. Create `feature.md`:
   - `Why`/`Who` from the user goal;
   - `In scope`/`Out of scope` from current behavior;
   - `Rules` from validation and business logic;
   - `Data` from models/schema;
   - `API` from routes/controllers;
   - `Screens` from views/components;
   - `Acceptance` from existing tests or observable behavior;
   - `Tasks` as verification tasks, not implementation tasks.
5. Add `Depends on` for existing features or shared entities.
6. Create `changes/0001-initial.md`:
   - `Reason: Imported from existing code.`
   - `Changed: all sections: documented current behavior.`
   - `Related: code paths or feature IDs.`
7. Status:
   - `done` if the code implements it and acceptance is verified;
   - `in_progress` if there are gaps or unverified behavior;
   - `draft` if documentation is incomplete.
   - Do not use `ready` for imported code.
8. Run `CHECK.md`.
9. Do not change code.
10. Report: code paths, verified behavior, gaps.

## Output

- `features/Fxxxx-<slug>/brief.md`
- `features/Fxxxx-<slug>/feature.md`
- `features/Fxxxx-<slug>/changes/0001-initial.md`
- A report with gaps and assumptions.
