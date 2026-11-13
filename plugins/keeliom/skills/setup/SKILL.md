---
name: setup
description: Set up Keeliom in a new or existing project, or import existing features from code.
---

# Setup

## Input

- `mode=new` or `mode=existing`. Without a mode, use `new` when there is no
  `app.md` and `existing` when there is one.
- `import=<capability>`: import one capability that exists in code.

## Read first

1. `${CLAUDE_PLUGIN_ROOT}/rules/RULES.md`
2. `${CLAUDE_PLUGIN_ROOT}/templates/app.md`
3. `${CLAUDE_PLUGIN_ROOT}/templates/keeliom-block.md`
4. `${CLAUDE_PLUGIN_ROOT}/templates/feature/feature.md`,
   `${CLAUDE_PLUGIN_ROOT}/templates/feature/spec.md` and
   `${CLAUDE_PLUGIN_ROOT}/templates/feature/changes/0001-initial.md`
5. In existing mode, the code

## New project

1. Copy `templates/app.md` to `app.md`. Keep `Status: draft` and
   `Language: English` unless the owner gave another language.
2. Ask for the facts the template marks `TBD`: name, one line, users, scope,
   non-goals, glossary, invariants, stack, roles and data model. Ask only for
   the missing ones. Without an interactive session, keep the `TBD` markers
   and list the questions in the final message.
3. Create `features/` and `changes/`.
4. Write the Keeliom block (below).
5. Do not create `RULES.md`, `CHECK.md` or a version file. The plugin owns
   them.

## Existing project

1. Read the code and the existing docs.
2. Fill `app.md` from them, using the template shape. Add `Repositories` with
   one row per repository: path, role, language, test commands and notes.
3. Create `features/` and `changes/` when missing.
4. Write the Keeliom block.
5. Import a feature only on request, or when `import=` names a capability.
   One feature per capability. `feature.md` describes the current behavior in
   plain language. `spec.md` holds the rules with `R<n>` IDs.
   `changes/0001-initial.md` has the five fields with `Source: code:<path>`.
   Take the status from `RULES.md §Statuses`. Never mark imported code
   `ready`.

## Keeliom block

Write `templates/keeliom-block.md` into `CLAUDE.md` and `AGENTS.md`. Create a
file when it is missing.

- When the file has `<!-- keeliom:start -->` and `<!-- keeliom:end -->`,
  replace that range, including both markers, with the template.
- Otherwise append the template with one blank line before it.
- Leave every other line untouched.
- Never write the block twice.

## After

Run `keeliom:check` once the project has a feature. Report what you created
and what is still `TBD`.
