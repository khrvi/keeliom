---
name: bootstrap
description: Bootstrap Keeliom in a new or existing project by writing the minimal project files.
---

# Bootstrap

## When to use

- New project with no Keeliom files.
- Existing project that needs Keeliom files without changing code.

## Input

- target path (default: current directory)
- mode: `new` or `existing`

## Process

1. Check for existing `app.md`, `RULES.md`, `CHECK.md` or `KEELIOM_VERSION`.
   Ask before overwriting any of them.
2. Write these files from `${CLAUDE_PLUGIN_ROOT}/templates/`:
   - `app.md` from `${CLAUDE_PLUGIN_ROOT}/templates/app.md`
   - `RULES.md` from `${CLAUDE_PLUGIN_ROOT}/templates/RULES.md`
   - `CHECK.md` from `${CLAUDE_PLUGIN_ROOT}/templates/CHECK.md`
   - `KEELIOM_VERSION` from `${CLAUDE_PLUGIN_ROOT}/templates/KEELIOM_VERSION`
3. Create `features/`.
4. If mode is `existing`:
   - fill `app.md` from the code **as-is**, including `Roles`, `Data model`,
     `API conventions` and `Repositories`;
   - do not create features yet;
   - suggest `import-feature` for core and shared capabilities.
5. Do not write code.
6. Run the checks from `CHECK.md` when `app.md` is filled.
7. Report next steps.

## Output

- `app.md`
- `RULES.md`
- `CHECK.md`
- `KEELIOM_VERSION`
- `features/`

The project does not receive the Keeliom plugin, `docs/`, or `examples/`.
