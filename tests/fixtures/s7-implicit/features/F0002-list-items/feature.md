# F0002 — List items

Status: ready
Release: None
Repository: None
Replaced by: None

## Why

The reader needs to see items.

## Who

Reader.

## Depends on

None

## Related

None

## In scope

- List items.

## Out of scope

- Delete an item.

## Rules

- Show all items.
- Show the name of each item.

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
- [ ] An item created in F0001 appears in the list.

## Tasks

- [ ] Add `GET /items`.

## Decisions

None

## Open questions

None
