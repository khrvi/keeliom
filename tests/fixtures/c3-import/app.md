# Fixture

Status: ready

## One-liner

A fixture.

## Users

| User | Description |
|---|---|
| Reader | Uses it. |

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

| Entity | Owner | Key fields | Notes |
|---|---|---|---|
| Item | F0001-demo | id, name | F0001 owns it. |

## API conventions

- Single resource: a JSON object.
- Collection: a JSON array.
- Errors: `Code | Status | When`
- Search: none.
- Field naming: snake_case.
- Enums: none.
- Auth: none.
- CSRF: not applicable.
- Sign-in and sign-out: not applicable.
- Idempotency: `POST /items` is not idempotent.
- Response coverage: every generated and returned `Data` field appears in a response.

## Locales

None

## Accessibility

None

## Repositories

| Path | Role | Language | Test commands | Notes |
|---|---|---|---|---|
| src | backend | Markdown | none | |
