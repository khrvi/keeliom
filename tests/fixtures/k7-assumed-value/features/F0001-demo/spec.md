# F0001 — Create item — spec

Depends on: None

## Rules

- R1. Saving without a name shows the error "Name is required" and creates no item. (§Creating an item)
- R2. Saving a name that already exists shows the error "Name already exists" and creates no item. (§Creating an item, D1)
- R3. Verification uses the selected digest and returns `verification_failed` on mismatch. See `test:verify`. (§Creating an item, D2)
