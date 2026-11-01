# 0002 — Add the error status and list acceptance

- **Keeliom:** 0.2.0
- **Date:** 2026-11-01
- **Reason:** The error table had no HTTP status, and the list had no acceptance criterion for a book added through F0001.
- **Changed:**
  - `API`: added `503` for `books_unavailable`.
  - `Acceptance`: added the list criterion.
- **Before:** the error table had no status column.
- **After:** the error table has a status; the list covers the add flow.
- **Related:** None
- **Corrects:** None
- **Decisions:** None
- **Source:** docs/04-v0.2-plan.md §3.5
