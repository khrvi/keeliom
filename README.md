# Keeliom

- **Status:** v0.2.1
- **Version:** 0.2.1
- **Date:** 2026-11-01
- **Location:** standalone repository.
- **Name:** Keeliom — Keel (stability) + Axiom (foundational truths).

## Status

v0.2.1 was released on 2026-11-01. See [`CHANGELOG.md`](CHANGELOG.md) and
[`REVIEW-v0.2.md`](REVIEW-v0.2.md).

## Idea

Keeliom is a set of Markdown files, skills, and conventions. No CLI, Ruby, Node,
terminal, or env. An LLM or a human reads the files and works from them.

## Flow v0.2

1. Fill in `app.md`, including `Roles`, `Data model`, `API conventions` and
   `Repositories`.
2. The product owner writes `brief.md` or provides a ticket.
3. The LLM uses `create-feature` to fill `feature.md`, asking only about missing
   decisions. Answers go in `Decisions`; sources are recorded.
4. Create `changes/0001-initial.md` with `Keeliom` and `Source`.
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
- Each new change contains `Keeliom`, `Date`, `Reason`, `Changed`, `Before`,
  `After`, `Related`, `Corrects`, `Decisions`, `Source`.
- To correct an entry, add a new entry with `Corrects: NNNN`.
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

The plugin bundles six skills:

- `bootstrap` — create the project files.
- `create-feature` — create a feature from a brief/ticket.
- `change-feature` — change a feature and record the reason.
- `import-feature` — document an existing feature from code.
- `review-project` — run a project-wide second pass over the spec and code.
- `upgrade` — migrate an existing project to the 0.2.0 sections and checks.

Skills live in `plugins/keeliom/skills/`, templates in
`plugins/keeliom/templates/`. For local development, run these from the directory that contains `keeliom/`,
or pass the absolute path:

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

- v0.3: split a feature into `data.md`, `api.md`, `ui.md`.
- v0.4: Blueprint → Canon → Living Spec layers.
- v0.5: optional tooling, only if needed.

## Documents

1. [01 — Flow](docs/01-flow.md)
2. [02 — Conventions](docs/02-conventions.md)
3. [03 — Distribution](docs/03-distribution.md)
4. [Plugin skills](plugins/keeliom/skills/)
5. [Plugin templates](plugins/keeliom/templates/)
6. [CHANGELOG](CHANGELOG.md)
7. [Review v0.1](REVIEW-v0.1.md)

## Roadmap

- **v0.1** — first release.
- **v0.2** — system contracts in `app.md`, decisions and sources, 36 checks,
  fixtures, `review-project`. The `data.md`/`api.md`/`ui.md` split moves to
  v0.3.
- **v0.2.1** — `upgrade` skill for existing projects.
- **v0.3** — split a feature into `data.md`, `api.md`, `ui.md`.
- **v0.4** — Blueprint → Canon → Living Spec layers.
- **v0.5** — optional tooling, only if needed.

## License

MIT. See [`LICENSE`](LICENSE).

## Repository

Standalone git repository. Tag releases as `v<version>`, for example `v0.1.0`.
