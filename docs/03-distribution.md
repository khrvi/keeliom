# 03 — Distribution

- **Status:** draft
- **Date:** 2026-10-30
- **Related:** [`README.md`](../README.md), [`01-flow.md`](01-flow.md),
  [`02-conventions.md`](02-conventions.md)

## 1. Principle

Keeliom is distributed as a **Claude Code plugin**. Install it once; a project
receives only generated working files, not the framework.

This removes copy/vendor: a project does not store a copy of Keeliom and does not
drift from it by version.

## 2. Repository layout

```
keeliom/
  .claude-plugin/
    marketplace.json
  plugins/
    keeliom/
      .claude-plugin/
        plugin.json
      skills/
        bootstrap/SKILL.md
        create-feature/SKILL.md
        change-feature/SKILL.md
        import-feature/SKILL.md
      templates/
        app.md
        brief.md
        RULES.md
        CHECK.md
        KEELIOM_VERSION
        feature/feature.md
        feature/changes/0001-initial.md
  docs/
  examples/
```

The marketplace and the plugin are separate directories. The plugin is copied
into the Claude Code cache as a whole, so `templates/` must stay inside
`plugins/keeliom/`.

## 3. Install

```text
/plugin marketplace add khrvi/keeliom
/plugin install keeliom@keeliom
```

Shell equivalents:

```bash
claude plugin marketplace add khrvi/keeliom
claude plugin install keeliom@keeliom --scope user
```

Update:

```text
/plugin marketplace update keeliom
```

or:

```bash
claude plugin update keeliom@keeliom
```

The marketplace name is `keeliom`, the plugin name is `keeliom`, so the install
ID is `keeliom@keeliom`.

## 4. New project

1. Run the `bootstrap` skill in the project directory.
2. Fill in `app.md`, including `Roles`, `Data model`, `API conventions` and
   `Repositories`.
3. Create `brief.md` and `feature.md` with `create-feature`.
4. Run `CHECK.md`.
5. Implement.

## 5. Existing project

1. Run `bootstrap` with `mode: existing`. It asks before overwriting any file.
2. Fill in `app.md` **as-is**, including `Roles`, `Data model`,
   `API conventions` and `Repositories`.
3. Inventory: routes, controllers, models, screens, tests.
4. Import core/shared with `import-feature`.
5. Then use `create-feature` and `change-feature`.
6. Do not change code during import.
7. Imported features: `done`, `in_progress`, or `draft`; do not use `ready`.

## 6. What goes into the project

- `app.md`
- `RULES.md`
- `CHECK.md`
- `KEELIOM_VERSION`
- `features/`
- `src/`

Not copied:

- `skills/`;
- `templates/`;
- `docs/`;
- `examples/`;
- plugin manifests.

They live in the installed plugin.

## 7. Updating a project

1. Update the plugin.
2. Read `CHANGELOG.md`.
3. Run the `upgrade` skill in the project. It updates `RULES.md`, `CHECK.md`,
   `app.md` and each feature, then runs `CHECK.md`.
4. If the skill cannot run, follow [`upgrade.md`](upgrade.md) by hand.
5. Do not overwrite `app.md`, `features/`, or `src/`.

`KEELIOM_VERSION` shows which framework version the project uses.

## 8. Non-Claude Code

Keeliom is plain Markdown. You can:

- point the LLM at the Keeliom repository and ask it to follow the plugin's
  `skills/*/SKILL.md`;
- copy the plugin's `skills/` and `templates/` into the LLM environment;
- work only with the project's `RULES.md`/`CHECK.md`; they are self-contained.

## 9. Plugin notes

- The marketplace entry `name` and `plugin.json` `name` must match.
- Skills live at `plugins/keeliom/skills/<name>/SKILL.md`.
- Skills reference plugin files through `${CLAUDE_PLUGIN_ROOT}`.
- `templates/` must stay inside the plugin directory; paths above the plugin
  root are not copied into the cache.
- `version` in `plugin.json` controls releases. Bump it to publish an update.
  The marketplace entry has no `version`; `plugin.json` is the only copy.
- Validate with `claude plugin validate ./plugins/keeliom --strict` and
  `claude plugin validate . --strict`.

## 10. Why plugin by default

- One-command install and update.
- Versioning and marketplace updates.
- Skills and templates are bundled together.
- No copy/vendor into every project.

## 11. Release checklist

1. Bump `version` in `plugins/keeliom/.claude-plugin/plugin.json`.
2. Bump `plugins/keeliom/templates/KEELIOM_VERSION` to the same value.
3. Update `README.md` and `CHANGELOG.md`.
4. Diff `templates/RULES.md` and `templates/CHECK.md` against the example
   copies.
5. Run `CHECK.md` on `examples/generic-app`. Expect `Project OK`.
6. Run `CHECK.md` on each fixture. Compare with `expected-findings.md`.
7. Run `review-project` on the example.
8. Run `claude plugin validate ./plugins/keeliom --strict` and
   `claude plugin validate . --strict`.
9. Tag `v<version>`.

`plugin.json` is the source of the plugin version. `templates/KEELIOM_VERSION`
carries the same number into new projects.
