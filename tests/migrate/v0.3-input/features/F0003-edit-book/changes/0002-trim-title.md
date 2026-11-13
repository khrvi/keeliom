# 0002 — Trim title and author

- **Date:** 2026-10-30
- **Reason:** F0001 now trims title and author before saving; edit must behave the same to keep data consistent.
- **Changed:**
  - `Rules`: title and author are trimmed before validation and saving.
  - `Acceptance`: added a criterion for trimmed values.
- **Before:** values were saved exactly as entered.
- **After:** title and author are trimmed before validation and saving.
- **Related:** F0001
