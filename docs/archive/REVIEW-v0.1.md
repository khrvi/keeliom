# Review — v0.1

- **Date:** 2026-10-30
- **Version:** 0.1.0
- **Status:** frozen; superseded by 0.2.0

## What was checked

- File structure and links.
- Consistency between README, docs, templates, skills, and example.
- The example against `CHECK.md`.
- History of F0001, F0003, F0004.
- Intake of F0004 from `brief.md`.
- Four-digit IDs and dependencies.

## Findings

1. The structure is consistent: README, docs, templates, skills, example.
2. The example passes `CHECK.md`: F0001–F0004.
3. History works: F0001 and F0003 have follow-up changes with reasons.
4. Intake works: F0004 started from `brief.md`.
5. **Fixed:** `RULES.md` referenced skills by a path that breaks in a project
   without a local `skills/` folder. It now uses the skill name.
6. **Fixed:** skills referenced Keeliom paths that may not exist in a project.
   They now reference the skill by meaning.
7. **Fixed:** `CHECK.md` did not validate `Related` in change entries. It does
   now.
8. No blockers.

## Verdict

v0.1 is frozen. Further changes go through a new version and `CHANGELOG.md`.
