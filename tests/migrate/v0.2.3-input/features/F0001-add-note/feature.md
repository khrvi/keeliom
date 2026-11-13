# F0001 — Add note

Status: ready
Release: None

## Why

A member needs a place to write a note.

## Who

The member.

## Depends on

None

## Related

None

## In scope

- Add a note with a title.

## Out of scope

- Editing a note.

## Rules

- Saving without a title shows "Title is required".
- The title is trimmed before saving.

## Data

- Note: id, title.

## API

- `POST /notes`

## Screens

None

## Acceptance

- [ ] Saving without a title shows "Title is required".
- [ ] The saved note has a trimmed title.

## Tasks

- [ ] Add the `notes` table.

## Decisions

| ID | From | Question | Answer | Source | Date |
|---|---|---|---|---|---|
| D1 | Q1 | Should titles be trimmed? | Yes, titles are trimmed. | owner:demo, 2026-10-01 | 2026-10-01 |

## Open questions

Q1. Should titles be trimmed?
- Recommendation: Yes.
- Owner: demo.
- Status: answered (D1)

Q2. Should empty notes be allowed?
- Recommendation: No.
- Owner: demo.
- Status: open
