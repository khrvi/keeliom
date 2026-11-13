# F0001 — Add note

Status: ready
Release: None
Repositories: None

## Why

A member needs a place to write a note.

## Who

The member.

## Depends on

None

## Reads

None

## Related

F0002

## In scope

- Add a note with a title.

## Out of scope

- Editing a note.

## Rules

- Saving a note without a title shows "Title is required".
- Saving a title longer than 60 characters shows "Title too long".
- Saving a valid note stores it.

## Data

- Note: id, title.

## API

- `POST /notes`

## Screens

None

## Acceptance

- [ ] Saving without a title shows "Title is required".
- [ ] The list is sorted newest first.

## Tasks

- [ ] Add the `notes` table.

## Decisions

| ID | From | Question | Answer | Source | Status | Date |
|---|---|---|---|---|---|---|
| D1 | Q1 | Should titles be trimmed? | Titles are trimmed. | owner:demo, 2026-10-01 | approved | 2026-10-01 |
| D2 | legacy §Rules | How long may a title be? | Titles are limited to 80 characters. | owner:demo, 2026-10-01 | approved | 2026-10-01 |
| D3 | legacy §Rules | How long may a title be, revised? | Titles are limited to 60 characters. | owner:demo, 2026-10-01 | approved | 2026-10-01 |
| D4 | legacy §Rules | Is D2 still valid? | No, see D3. | owner:demo, 2026-10-01 | approved | 2026-10-01 |

## Open questions

None
