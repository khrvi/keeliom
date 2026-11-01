# F0001 — Demo

Status: ready
Release: None
Repository: None
Replaced by: None

## Why

The reader needs the item.

## Who

Reader.

## Depends on

None

## Related

None

## In scope

- Create an item.

## Out of scope

- Delete an item.

## Rules

- The name is required.

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

Q1. Which name format?
Recommendation: free text.
Owner: reader
Status: open
