# F0001 — Create item — spec

Depends on: None

## Rules

- R1. Saving without a name returns error `name_required` with status `422`. (§Creating an item)
- R2. Saving a name that already exists returns error `name_taken` with status `422`. (§Creating an item, D1)
- R3. Saving when storage is full returns error `storage_full` with status `507`. (§Creating an item)

## API

Errors:

The only save errors are `name_required` and `name_taken`.

| Code | Status |
|---|---|
| `name_required` | 422 |
| `name_taken` | 422 |
