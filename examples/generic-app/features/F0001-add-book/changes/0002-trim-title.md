# 0002 — Trim title and author

- **Date:** 2026-10-30
- **Reason:** Readers sometimes paste values with leading or trailing spaces, which creates duplicate-looking books and broken uniqueness checks.
- **Changed:**
  - `Rules`: title and author are trimmed before validation and saving.
  - `Acceptance`: added a criterion for trimmed values.
- **Before:** values were saved exactly as entered.
- **After:** title and author are trimmed before validation and saving.
- **Related:** None
