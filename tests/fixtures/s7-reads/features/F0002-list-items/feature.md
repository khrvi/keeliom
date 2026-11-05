# F0002 — List items

Status: ready
Release: None
Repositories: None

## Why

The reader needs to see items.

## Who

Reader.

## Depends on

None

## Reads

None

## Related

F0001

## In scope

- List items.

## Out of scope

- Delete an item.

## Rules

- Show all items.

## Data

Reads `Item`:

| Field | Type | Used for |
|---|---|---|
| `id` | integer | row key |
| `name` | string | row |

## API

```
GET /items
```

Response `200`:

```json
[{ "id": 1, "name": "Thing" }]
```

## Screens

Screen: Item list

| State | What the reader sees |
|---|---|
| `list` | rows with the item name |

## Acceptance

- [ ] The reader sees all items.

## Tasks

- [ ] Add `GET /items`.

## Decisions

None

## Open questions

None
