# Keeliom plugin

Keeliom spec framework plugin for Claude Code.

## Install

```text
/plugin marketplace add khrvi/keeliom
/plugin install keeliom@keeliom
```

## Skills

- `setup` — set up a new or existing project, or import features from code.
- `feature` — create or change a feature from a brief, ticket or plan.
- `check` — run the checks and write `STATUS.md`.
- `migrate` — migrate a 0.2.x or 0.3 project to 0.4.

## Rules

`rules/` contains the formats and statuses (`RULES.md`) and the checks
(`CHECK.md`). Every other file cites them.

## Templates

`templates/` shows the shape of the project files:

- `app.md`
- `brief.md`
- `keeliom-block.md`
- `feature/feature.md`
- `feature/spec.md`
- `feature/changes/0001-initial.md`

## Docs

The docs live in the Keeliom repository under `docs/`. The plugin does not
bundle them: files above the plugin directory are not copied into the Claude
Code cache.
