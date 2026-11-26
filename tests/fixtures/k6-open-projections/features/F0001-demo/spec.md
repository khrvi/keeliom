# F0001 — Create item — spec

Depends on: None

## Rules

- R1. Saving without a name shows the error "Name is required" and creates no item. (§Creating an item)
- R2. Saving a name that already exists shows the error "Name already exists" and creates no item. (§Creating an item, D1)
- R3. Saving returns `created_at` for the new item. (§Creating an item)
- R4. A storage outage returns status `503` with error `storage_unavailable`. (§Creating an item)

## Data

| Field | Used for |
|---|---|
| `id` | lookup |
| `name` | editing |

## API

An example response is:

```json
{ "id": 1, "name": "Demo" }
```
