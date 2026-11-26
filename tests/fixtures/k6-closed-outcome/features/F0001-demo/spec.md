# F0001 — Create item — spec

Depends on: None

## Rules

- R1. The save outcome is one of `created` and `rejected`, and every response contains its `outcome`. (§Creating an item)
- R2. Saving a name that already exists shows the error "Name already exists" and creates no item. (§Creating an item, D1)
- R3. When the worker is busy, saving returns outcome `deferred`. (§Creating an item)
