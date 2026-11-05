# Review v0.3.0

- **Status:** shipped
- **Date:** 2026-11-04
- **Related:** [`README.md`](README.md), [`CHANGELOG.md`](CHANGELOG.md)

This release answers 14 findings against v0.2.3.

| # | Finding | Resolution |
|---|---|---|
| 1 | No executable validator | **Declined.** A validator duplicates `CHECK.md` and adds a runtime. Findings now have a fixed order and a section anchor. A validator is a separate product. |
| 2 | Unstable line references | **Fixed.** Findings use `path §section [check-id] severity: message` and quote the text. `review-project` no longer asks for line numbers. |
| 3 | One relation covers two things | **Fixed.** `Depends on` is behavior only and acyclic. `Reads` is data only and may be cyclic. |
| 4 | Data model assumes tables | **Fixed.** The columns are `Entity \| Owner \| Key fields \| Notes`. The store type goes in `Stack` and `Notes`. |
| 5 | No approved or assumed decisions | **Fixed.** Decisions gain `Status: approved` or `assumed`. `ready` and `done` require `approved`. |
| 6 | Change entries cannot be checked | **Fixed in Markdown.** `Before` and `After` quote the changed text. S8 checks the newest 0.3.0 entry's `After` quote against the current file. |
| 7 | `ready` before code exists | **Declined.** `ready` already means spec complete and implementation not started. C checks use the `add <x>` Task route. |
| 8 | Templates contradict the placeholder rule | **Fixed.** `app.md` has `Status: draft` or `ready`. Templates use `TBD` markers. |
| 9 | Missing project `changes/` | **Fixed.** `bootstrap` creates `changes/`. `upgrade` creates it when missing. |
| 10 | `From: None` is ambiguous | **Fixed.** `From: None` means the decision has no predecessor question. |
| 11 | No locale or accessibility fields | **Fixed.** Optional `Locales` and `Accessibility` in `app.md`. |
| 12 | One role table for two jobs | **Fixed.** `Users` is a domain-user table. `Roles` is access roles. |
| 13 | Placeholder check too coarse | **Fixed.** M6 checks `TBD` only. HTML, JSX, ERB and route syntax no longer trigger it. |
| 14 | Multi-version rules are hard to apply | **Fixed.** M19 and the version gate are removed. One rule set. `upgrade` handles migration. |

## Verification

- [ ] `claude plugin validate plugins/keeliom`
- [ ] `claude plugin validate .`
- [ ] `CHECK.md` on `examples/generic-app` reports `Project OK`.
- [ ] `bash tests/run.sh` passes every fixture.
