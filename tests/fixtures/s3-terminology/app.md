# Fixture

## One-liner

A fixture.

## Users

- Reader: uses it.

## Jobs

- Do the job.

## Scope

- The job.

## Non-goals

- Nothing.

## Glossary

| Term | Meaning |
|---|---|
| Item | A thing. |
| Status | The state of an item. |

## Invariants

- An item has a name.

## Stack

- Language: Markdown
- Framework: none
- Database: none

## Roles

| Role | Can do |
|---|---|
| Reader | Uses the item. |

## Data model

| Table | Owner feature | Key columns | Notes |
|---|---|---|---|
| Item | F0001-demo | id, name | F0001 owns it. |

## API conventions

- Envelope: JSON object.
- Errors: `Code | Status | When`
- Pagination: none.
- Field naming: snake_case.
- Enums: none.
- Auth: none.
- CSRF: not applicable.
- Sign-in and sign-out: not applicable.
- Idempotency: `POST /items` is not idempotent.
- Response coverage: every generated and returned `Data` field appears in a response.

## Repositories

None
