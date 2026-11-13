# 03 — Distribution

- **Status:** draft
- **Date:** 2026-11-13
- **Related:** [`README.md`](../README.md), [`01-flow.md`](01-flow.md),
  [`02-conventions.md`](02-conventions.md)

## 1. Principle

Keeliom is distributed as a Claude Code plugin. Install it once. A project
receives only generated working files, not the framework.

This removes copy and vendor. A project does not store a copy of the rules, so
it cannot drift from them.

## 2. Repository layout

```
keeliom/
  .claude-plugin/
    marketplace.json
  plugins/
    keeliom/
      .claude-plugin/
        plugin.json
      rules/
        RULES.md
        CHECK.md
      skills/
        setup/SKILL.md
        feature/SKILL.md
        check/SKILL.md
        migrate/SKILL.md
      templates/
        app.md
        brief.md
        keeliom-block.md
        feature/feature.md
        feature/spec.md
        feature/changes/0001-initial.md
  docs/
  examples/
  tests/
```

The plugin copies into the Claude Code cache as a whole, so `rules/` and
`templates/` stay inside `plugins/keeliom/`.

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

1. Run `setup mode=new` in the project directory.
2. It writes `app.md` from the template with `Status: draft` and
   `Language: English`.
3. It creates `features/` and `changes/`.
4. It writes the Keeliom block into `CLAUDE.md` and `AGENTS.md`.
5. Fill the `TBD` markers, then run `feature`.

## 5. Existing project

1. Run `setup mode=existing`. It reads the code and fills `app.md` as-is,
   including `Repositories`.
2. Inventory the routes, models, screens and tests.
3. Import the core capabilities with `setup import=<capability>`.
4. Then use `feature` for new work.
5. Do not change code during import.

## 6. What goes into the project

- `app.md`
- `STATUS.md`
- `CLAUDE.md` and `AGENTS.md`
- `features/`
- `changes/` for `app.md` changes
- `plans/` when the owner wants it

Not copied: the plugin's `rules/`, `skills/` and `templates/`, the docs and the
examples. They live in the installed plugin.

## 7. The Keeliom block

`setup` and `migrate` write one block into `CLAUDE.md` and `AGENTS.md`, between
`<!-- keeliom:start -->` and `<!-- keeliom:end -->`. The block points at
`app.md`, the feature files and the rules, and it states the working rules.

A file without the markers gets the block appended. A file with the markers has
only that range replaced. Everything outside the markers belongs to the
project.

## 8. Updating a project

1. Update the plugin.
2. Read `CHANGELOG.md`.
3. Run `migrate` in `report` mode. It prints every planned change and writes
   nothing.
4. Run `migrate` in `apply` mode. It needs a clean git working tree.
5. Do not edit an old change entry.

A project records its version as `Keeliom:` in `app.md`. A skill compares the
major and minor parts with the plugin version.

## 9. Non-Claude Code

Keeliom is plain Markdown. You can:

- point the LLM at this repository and ask it to follow `rules/` and
  `skills/<name>/SKILL.md`;
- copy the plugin's `rules/`, `skills/` and `templates/` into the LLM
  environment;
- give the LLM the Keeliom block text and the rules URL from the block.

## 10. Plugin notes

- The marketplace entry `name` and `plugin.json` `name` must match.
- Skills live at `plugins/keeliom/skills/<name>/SKILL.md`.
- Skills reference plugin files through `${CLAUDE_PLUGIN_ROOT}`.
- `rules/` and `templates/` must stay inside the plugin directory. Paths above
  the plugin root are not copied into the cache.
- `version` in `plugin.json` controls releases. The marketplace entry has no
  version.
- Validate with `claude plugin validate ./plugins/keeliom` and
  `claude plugin validate .`.

## 11. Release checklist

1. Bump `version` in `plugins/keeliom/.claude-plugin/plugin.json`.
2. Update the rules URL in `templates/keeliom-block.md` to the new tag.
3. Update `README.md` and `CHANGELOG.md`.
4. Run `bash tests/lint.sh`.
5. Run `bash tests/run.sh`. Every fixture passes.
6. Run `bash tests/skills.sh` and `bash tests/migrate.sh`.
7. Run `check` on `examples/generic-app`. Expect `Project OK`.
8. Run `claude plugin validate ./plugins/keeliom` and
   `claude plugin validate .`.
9. Tag `v<version>`.

`plugin.json` is the single copy of the plugin version.
