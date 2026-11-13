# 0004 — Add the ISBN format error

- **Keeliom:** 0.2.0
- **Date:** 2026-11-01
- **Reason:** The ISBN invariant needs an error code and an acceptance line.
- **Changed:**
  - `API`: added `isbn_invalid`.
  - `Acceptance`: added the format criterion.
- **Before:** the format rule had no error code.
- **After:** the format rule has `isbn_invalid` and an acceptance line.
- **Related:** None
- **Corrects:** None
- **Decisions:** None
- **Source:** CHANGELOG.md §0.2.0
