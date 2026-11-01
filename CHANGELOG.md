# Changelog

## 0.2.2 — 2026-11-02

### Added

- `feature.md` `Release` and `Repositories` header lines.
- `Repositories` table `Test commands` and `Notes` columns.
- Decisions table `Date` column.
- `Status: answered (D<n>)` for answered questions.
- `legacy §<section>` in a Decision's `From`.

### Changed

- A feature may name more than one repository. C1 runs per repository.
- `Open questions` uses `Q<n>. <question>` with indented fields.
- `Source` has three forms. The upgrade guide is not a source.
- The `upgrade` skill defaults to `report` and has a failure path.

### Fixed

- The 0.2.0 entry listed `Release`, `Repository` and `Replaced by` as template
  fields. The template did not have them. 0.2.2 adds `Release` and
  `Repositories`; `Replaced by` is required by M22 only when a feature is
  deprecated.

## 0.2.1 — 2026-11-01

### Added

- `upgrade` skill: migrate an existing project to the 0.2.0 sections and
  checks.

## 0.2.0 — 2026-11-01

### Added

- `app.md` `Roles`, `Data model`, `API conventions`, `Repositories`.
- `feature.md` `Decisions` and `Related`. `Replaced by` is required by M22
  when a feature is deprecated.
- Change entries `Keeliom`, `Corrects`, `Decisions`, `Source`.
- `CHECK.md` with 36 checks: M1–M24, S1–S9, C1–C3.
- `review-project` skill.
- Fixtures for the new checks.
- `docs/upgrade.md`.

### Changed

- The test command lives in `Repositories`. `Tests` is removed from `Stack`.
- `Related` holds feature IDs. Code paths go in `Source`.
- Status transitions include back transitions.
- The `data.md`/`api.md`/`ui.md` split moves to v0.3.

### Fixed

- The example's F0001–F0004 specs and history.
- The append-only rule with `Corrects`.

## 0.1.0 — 2026-10-30

First release.

### Added

- `app.md` — app, users, jobs, scope, non-goals, glossary, invariants, stack.
- `brief.md` — a short input from the product owner or a ticket.
- `features/F0001-name/feature.md` — the current feature spec, with a
  `Status: <value>` line under the title.
- `features/F0001-name/changes/` — append-only history with reasons.
- `RULES.md` — generation protocol: read order, intake, change rules, task
  order, status updates. It is self-contained and works without the plugin.
- `CHECK.md` — 12 checks for an LLM or a human.
- Skills: `bootstrap`, `create-feature`, `change-feature`, `import-feature`.
- Claude Code plugin marketplace at `.claude-plugin/marketplace.json` and
  `plugins/keeliom/`.
- Book Library example: F0001–F0004, with history and intake.
- Four-digit IDs `F0001`–`F9999`.
- Statuses: `draft`, `ready`, `in_progress`, `done`, `deprecated`.
- `Depends on` for real dependencies and `Related` in change entries.
- `KEELIOM_VERSION` in the project.

### Notes

- `create-feature` allocates the next feature ID and saves a pasted ticket as
  `brief.md`.
- `change-feature` allocates the next change number.
- `app.md` Stack includes a `Tests` line.
- `plugin.json` is the single source of the plugin version.

### Limitations

- No automatic CLI: validation is done by an LLM or a human via `CHECK.md`.
- No real diffs in change entries; `Reason` and `Before/After` are used.
- No modules/areas; after `F9999`, use modules.
- No `data/api/ui` split; that is v0.2.
- No Blueprint → Canon → Living Spec layers; that is v0.3.
- No tooling; intentional.
