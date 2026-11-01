# F0002 — List items

Status: ready
Release: None
Repositories: None

## Why

The reader needs to see the items.

## Who

Reader.

## Depends on

F0001

## Related

F0001

## In scope

- List items.

## Out of scope

None

## Rules

- Items are listed by name.

## Data

| Field | Type | Rules |
|---|---|---|
| `id` | integer | generated |
| `name` | string | required |

## API

```
GET /items
```

## Screens

Screen: Item list

| State | What the reader sees |
|---|---|
| `loaded` | The item list. |

## Acceptance

- [ ] The reader sees the item list.

## Tasks

- [ ] Add `GET /items`.

## Decisions

None

## Open questions

None
