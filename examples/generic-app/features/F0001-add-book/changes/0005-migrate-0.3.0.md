# 0005 — Migrate to 0.3.0

- **Keeliom:** 0.3.0
- **Date:** 2026-11-04
- **Reason:** Adopt the 0.3.0 sections, relations and the rules the checks require.
- **Changed:**
  - `Reads`: added the section.
  - `Decisions`: added the `Status` column.
  - `Rules`: added the API success rule, the normalization order, length test references and the full ISBN invariant.
  - `Acceptance`: added the normalization criterion.
- **Before:** `| ID | From | Question | Answer | Source | Date |`
- **After:** `| ID | From | Question | Answer | Source | Status | Date |`
- **Related:** None
- **Corrects:** None
- **Decisions:** None
- **Source:** owner:maintainer, 2026-11-04
