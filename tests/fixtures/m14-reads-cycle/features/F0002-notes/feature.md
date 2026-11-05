# F0002 — Notes

Status: ready
Release: None
Repositories: None

## Why

The reader needs to keep notes.

## Who

Reader.

## Depends on

None

## Reads

F0001

## Related

None

## In scope

- Create a note.

## Out of scope

- Delete a note.

## Rules

- The body is required.
- On success, return `201` with the note and show "Note created".

## Data

| Field | Type | Rules |
|---|---|---|
| `id` | integer | generated |
| `body` | string | required |

## API

```
POST /notes
```

Response `201`:

```json
{ "id": 1, "body": "Text" }
```

Errors:

| Code | Status | When |
|---|---|---|
| `body_required` | 422 | body is missing |

## Screens

Screen: Create note

| State | What the reader sees |
|---|---|
| `success` | "Note created" |

## Acceptance

- [ ] The reader can create a note and receives `201` with the note.
- [ ] A missing body is rejected with `body_required` and status `422`.

## Tasks

- [ ] Add `POST /notes`.

## Decisions

None

## Open questions

None
