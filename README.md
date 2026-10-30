# Keeliom

- **Status:** v0.1.0
- **Version:** 0.1.0
- **Date:** 2026-10-30
- **Location:** standalone repository.
- **Name:** Keeliom — Keel (stability) + Axiom (foundational truths).

## Status

v0.1.0 was released on 2026-10-30. See [`CHANGELOG.md`](CHANGELOG.md) and
[`REVIEW-v0.1.md`](REVIEW-v0.1.md).

## Idea

Keeliom is a set of Markdown files, skills, and conventions. No CLI, Ruby, Node,
terminal, or env. An LLM or a human reads the files and works from them.

## Flow v0.1

1. Fill in `app.md`.
2. The product owner writes `brief.md` or provides a ticket.
3. The LLM uses `create-feature` to fill `feature.md`, asking only about missing
   decisions.
4. Create `changes/0001-initial.md`.
5. Run `CHECK.md`.
6. The LLM/developer reads `app.md`, `brief.md`, `feature.md`, and `RULES.md`,
   then implements the tasks.
7. Check the tasks and update the status.
8. Run `CHECK.md`.
9. Move to the next feature.

## Project structure

```
<project>/
  app.md
  RULES.md
  CHECK.md
  KEELIOM_VERSION
  features/
    F0001-games-list/
      brief.md
      feature.md
      changes/
        0001-initial.md
  src/
```

`brief.md` is optional, but if present it must not be empty. The project does not
copy the Keeliom repository; the plugin provides the skills and templates.

## Feature history

- `feature.md` is the current state.
- `changes/0001-initial.md`, `0002-...md` are append-only history.
- Each change contains `Date`, `Reason`, `Changed`, `Before`, `After`,
  `Related`.
- Old change entries are never edited.
- If a change relates to a dependency, record it in `Related`.

## Principles

1. **Brief first.** Start from a short description or ticket, not a blank
   template.
2. **Convention over configuration.** Fixed file names and sections.
3. **One directory per feature.**
4. **No TBD in ready.**
5. **The LLM does not invent.** It asks only about missing decisions.
6. **Simplicity over completeness.** Add complexity only when needed.
7. **Zero dependencies.** Markdown only.
8. **Append-only history.** The reason for a change lives next to the change.

## Plugin

Keeliom is a Claude Code plugin marketplace:

```text
/plugin marketplace add khrvi/keeliom
/plugin install keeliom@keeliom
```

The plugin bundles four skills:

- `bootstrap` — create the project files.
- `create-feature` — create a feature from a brief/ticket.
- `change-feature` — change a feature and record the reason.
- `import-feature` — document an existing feature from code.

Skills live in `plugins/keeliom/skills/`, templates in
`plugins/keeliom/templates/`. For local development, add the repository as a
local marketplace:

```bash
claude plugin marketplace add ./keeliom
claude plugin install keeliom@keeliom
```

## Distribution

The plugin is the default. The project receives only generated files. See
[03 — Distribution](docs/03-distribution.md).

For non-Claude Code environments, the repository is plain Markdown: point the LLM
at it or copy the plugin's `skills/` and `templates/`.

## What comes later

- Split a feature into `data.md`, `api.md`, `ui.md`.
- Blueprint → Canon → Living Spec layers.
- Optional tooling, only if needed.

## Documents

1. [01 — Flow](docs/01-flow.md)
2. [02 — Conventions](docs/02-conventions.md)
3. [03 — Distribution](docs/03-distribution.md)
4. [Plugin skills](plugins/keeliom/skills/)
5. [Plugin templates](plugins/keeliom/templates/)
6. [CHANGELOG](CHANGELOG.md)
7. [Review v0.1](REVIEW-v0.1.md)

## Roadmap

- **v0.1** — `app.md`, `brief.md`, `features/F0001-name/feature.md`,
  `changes/`, `RULES.md`, `CHECK.md`, skills, example, plugin distribution.
- **v0.2** — split a feature into `data.md`, `api.md`, `ui.md`.
- **v0.3** — Blueprint → Canon → Living Spec layers.
- **v0.4** — optional tooling, only if needed.

## License

MIT. See [`LICENSE`](LICENSE).

## Repository

Standalone git repository. Tag releases as `v<version>`, for example `v0.1.0`.
