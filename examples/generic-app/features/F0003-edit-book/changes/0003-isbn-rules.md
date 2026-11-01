# 0003 — Add the ISBN rules

- **Keeliom:** 0.2.0
- **Date:** 2026-11-01
- **Reason:** F0003 did not say how ISBN is normalized, whether it can be cleared, or whether its format is checked. F0001 already normalized ISBN.
- **Changed:**
  - `Rules`: added normalization, normalization order, clearing and format.
  - `API`: added `isbn_invalid`.
  - `Acceptance`: added the matching criteria.
- **Before:** ISBN was optional and unique, with no normalization or format rule.
- **After:** ISBN is normalized before validation and uniqueness, can be cleared, and is checked for length.
- **Related:** None
- **Corrects:** None
- **Decisions:** None
- **Source:** docs/04-v0.2-plan.md §3.5
