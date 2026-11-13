---
name: migrate
description: Migrate a Keeliom 0.2.x or 0.3 project to 0.4 without editing old change entries.
---

# Migrate

## Input

- `mode=report` (default) or `mode=apply`.
- `F00xx`: migrate one feature. Without it, migrate every feature.
- `owner=<name>`: the person who owns the project.
- `confirm=yes`: the owner accepted the deletions, the block and the plan
  moves. Without it, ask once before writing.

## Principle

Old change entries are never edited, renamed or deleted. Old facts are not
rewritten to pass new checks. Migration adds content and one project-level
change entry.

## Read first

1. `${CLAUDE_PLUGIN_ROOT}/rules/RULES.md`
2. `${CLAUDE_PLUGIN_ROOT}/rules/CHECK.md`
3. The templates under `${CLAUDE_PLUGIN_ROOT}/templates/`
4. The project's `app.md`, `CHECK.md`, `RULES.md`, every `feature.md` and every
   cited `brief.md` or plan.

## Detect

- Current: `app.md` has `Keeliom: 0.4.x`. Print `Keeliom is already current.`
  and stop.
- Older: `KEELIOM_VERSION` exists and `app.md` has no `Keeliom:` header. Both
  0.2.3 and 0.3.0 are accepted.
- Older than 0.2.0: refuse and stop.
- Newer than 0.4: print
  `Plugin is older than the project: update the keeliom plugin.` and stop.

## Modes

- `report`: print every planned change and the new prose. Write nothing.
- `apply`: run `git status --porcelain`. When it is not empty, print
  `The working tree is not clean. Commit or stash your changes, then run migrate again.`
  and change no file. Ask once, then write. `confirm=yes` accepts.

## Per-feature steps

1. Split `feature.md`.
   - New `feature.md`: the title; `Status` (`in_progress` becomes `ready`,
     others copied); `Source` from `brief.md`, a cited plan, or the first
     change entry's `Source`; `## Overview` from `Why` and `Who`;
     `## Description` as new prose from `In scope`, `Rules`, `Screens`, the
     brief and cited plans, grouped by topic; `## Out of scope` copied;
     `## Decisions`; `## Open questions`.
   - New `spec.md`: `Depends on` as the union of `Depends on`, `Reads` and the
     feature IDs in `Related`; `## Rules`; `## Data`, `## API`, `## Screens`
     and `## Tasks` copied. Keep the checkbox state. Omit an empty section.
2. Rules. Keep every existing `R<n>`. Number unnumbered rules `R1…Rn` in their
   original order. Each `Acceptance` line that no rule covers becomes the next
   new rule. Copy the rule text; add the `(§<heading>)`, `(D<n>)` or
   `(§<heading>, D<n>)` reference at the end. Never renumber a rule.
3. Decisions. Use `| ID | Decision | Source | Status |`. The Decision is the
   v0.3 `Answer` as a statement. Copy `Source` and `Status`; a 0.2.x decision
   is `approved`. Drop `From` and `Date`.
   - A meta-decision that only says another decision is superseded (for
     example `Is D2 still valid? No, see D3.`) is removed. Set the old row's
     `Status` to `replaced by D3`. List this in the report.
4. Open questions. Keep open ones in the new format with their number:
   `- Q<n>. <question>` and indented `Recommendation: … Owner: …`. Remove
   answered ones; their Decision already exists.
5. `brief.md` stays byte-identical.
6. No per-feature change entry. The project entry covers it.

## Project steps

1. `app.md`: add `Keeliom: 0.4.0` under the title and `Language: English` (or
   the language the existing specs use). Fold `Jobs` into `One-liner` and
   `Users`. Rename `API conventions` to `Conventions` and keep its content.
   Move `CHECK.md §Project overrides` into `## Check overrides`, dropping
   overrides made unnecessary by allowing cycles.
2. Move root plan files, release docs and similar documents into `plans/` when
   the owner agrees, and update `Source` paths that cite them. Leave legacy
   plan folders the owner wants in place.
3. Delete `RULES.md`, `CHECK.md` and `KEELIOM_VERSION` after confirmation.
   Offer to retire `TODO.md`. Write the Keeliom block (see `setup`) into
   `CLAUDE.md` and `AGENTS.md`. Point out notes made unnecessary by the new
   rules.
4. Write one project entry `changes/NNNN-migrate-0.4.md` with the five fields.
   `Changed` lists every feature split. `Decisions` lists the carried IDs per
   feature, for example `F0007: D1–D12`. `Source` is
   `owner:<owner>, <YYYY-MM-DD>`.
5. Run `keeliom:check`.
6. Report: features migrated, the new prose to review, K5/K7 findings as owner
   actions, the replaced-decision cleanups and the `set done` candidates.

## Old entries

K4 checks the five fields only in entries dated after the project migration
entry. Older entries must only be sequential. A Decision ID listed in the
migration entry counts as recorded. This is the single legacy rule.
