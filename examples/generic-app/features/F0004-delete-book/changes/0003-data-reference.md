# 0003 — Reference the owning feature and the no-accounts constraint

- **Keeliom:** 0.2.0
- **Date:** 2026-11-01
- **Reason:** F0004 deletes `Book`; the Data section should point to F0001. The brief's no-accounts constraint belongs in Out of scope.
- **Changed:**
  - `Data`: added the F0001 reference.
  - `Out of scope`: added the no-accounts constraint.
- **Before:** the Data section did not reference the owning feature; the constraint was only in app.md.
- **After:** both are recorded.
- **Related:** F0001, F0002
- **Corrects:** None
- **Decisions:** None
- **Source:** CHANGELOG.md §0.2.0
