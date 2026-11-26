# F0001 — Create item — spec

Depends on: None

## Rules

- R1. Saving a batch returns separate `created` and `rejected` counters. (§Creating an item)
- R2. Saving a name that already exists shows the error "Name already exists" and creates no item. (§Creating an item, D1)
- R3. When the worker is busy, the save outcome for the item is `deferred`. (§Creating an item)
