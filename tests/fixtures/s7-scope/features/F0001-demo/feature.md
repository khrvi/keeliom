# F0001 — Demo

Status: ready
Release: None
Repositories: None

## Why

The reader needs the item.

## Who

Reader.

## Depends on

None

## Related

F0002

## In scope

- Create an item.
- Item list (F0002).

## Out of scope

- Delete an item.

## Rules

- The name is required.
- On success, return `201` with the item and show "Item created".

## Data

| Field | Type | Rules |
|---|---|---|
| `id` | integer | generated |
| `name` | string | required |

## API

```
POST /items
```

Response `201`:

```json
{ "id": 1, "name": "Thing" }
```

Errors:

| Code | Status | When |
|---|---|---|
| `name_required` | 422 | name is missing |

## Screens

Screen: Create item

| State | What the reader sees |
|---|---|
| `success` | "Item created" |

## Acceptance

- [ ] The reader can create an item and receives `201` with the item.
- [ ] A missing name is rejected with `name_required` and status `422`.

## Tasks

- [ ] Add `POST /items`.

## Decisions

None

## Open questions

None
