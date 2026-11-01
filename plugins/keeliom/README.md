# Keeliom plugin

Keeliom spec framework plugin for Claude Code.

## Install

```text
/plugin marketplace add khrvi/keeliom
/plugin install keeliom@keeliom
```

## Skills

- `bootstrap` — create `app.md`, `RULES.md`, `CHECK.md`, `KEELIOM_VERSION`, and
  `features/` in a project.
- `create-feature` — create a feature spec from a brief or ticket.
- `change-feature` — change a feature and record the reason.
- `import-feature` — document an existing feature from code.
- `review-project` — run a project-wide second pass over the spec and code.
- `upgrade` — migrate an existing project to the current sections and checks.

## Templates

`templates/` contains:

- `app.md`
- `brief.md`
- `RULES.md`
- `CHECK.md`
- `KEELIOM_VERSION`
- `feature/feature.md`
- `feature/changes/0001-initial.md`

## Docs

The docs live in the Keeliom repository under `docs/`. The plugin does not
bundle them: files above the plugin directory are not copied into the Claude
Code cache.
