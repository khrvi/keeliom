# F0001 — Create item — spec

Depends on: None
Repositories: src/api, src/web

## Rules

- R1. Saving without a name shows the error "Name is required" and creates no item. (§Creating an item)
- R2. In src/api: saving a name that already exists shows the error "Name already exists" and creates no item. (§Creating an item, D1)

## Data

- Item: id, name, color.
