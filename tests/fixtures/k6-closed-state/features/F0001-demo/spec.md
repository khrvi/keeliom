# F0001 — Create item — spec

Depends on: None

## Rules

- R1. Item state is one of `draft` and `saved`, and the item response contains `state`. (§Creating an item)
- R2. Saving a name that already exists shows the error "Name already exists" and creates no item. (§Creating an item, D1)
- R3. Archiving an item sets its state to `archived`. (§Creating an item)
