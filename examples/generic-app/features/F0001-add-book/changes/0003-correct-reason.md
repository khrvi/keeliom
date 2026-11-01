# 0003 — Correct the reason and add the ISBN rule

- **Keeliom:** 0.2.0
- **Date:** 2026-11-01
- **Reason:** Readers paste values with leading or trailing spaces. Trimming prevents near-duplicate titles and authors. The 0002 reason also claimed broken uniqueness checks; only ISBN is unique.
- **Changed:**
  - `Rules`: added the ISBN invariant reference.
  - `API`: added `created_at` to the response and HTTP statuses to the error table.
  - `Acceptance`: named the error codes and added ISBN normalization.
  - `Decisions`: recorded D1.
- **Before:** 0002 described broken uniqueness checks for title and author.
- **After:** the reason names trimming and the ISBN rule; the spec matches.
- **Related:** None
- **Corrects:** 0002
- **Decisions:** D1
- **Source:** docs/04-v0.2-plan.md §3.5
