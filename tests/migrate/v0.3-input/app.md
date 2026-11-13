# Book Library

Status: ready

## One-liner

A small personal library where a reader can add books and see what they own.

## Users

| User | Description |
|---|---|
| Reader | Adds books and views the list. |

## Jobs

- Add a book I own.
- See the books I own.

## Scope

- Add a book with title, author, and optional ISBN.
- List books.
- Edit and delete books.

## Non-goals

- Borrowing or lending.
- User accounts.
- External book search.
- Reading progress.

## Glossary

| Term | Meaning |
|---|---|
| Book | A single title owned by the reader. |
| ISBN | Optional unique identifier of a book. |

## Invariants

- A book always has a title.
- A book always has an author.
- If an ISBN is present, it is 10 or 13 characters after normalization: digits, with `X` allowed as the last character of an ISBN-10, and unique.

## Stack

- Language: TypeScript
- Framework: none (example)
- Database: SQLite

## Roles

| Role | Can do |
|---|---|
| Reader | Adds, views, edits and deletes books. |

## Data model

| Entity | Owner | Key fields | Notes |
|---|---|---|---|
| Book | F0001-add-book | id, title, author, isbn, created_at | SQLite table. |

## API conventions

- Single resource: JSON object.
- Collection: JSON array.
- Errors: `Code | Status | When`
- Search: none.
- Field naming: snake_case.
- Enums: none.
- Auth: none.
- CSRF: not applicable.
- Sign-in and sign-out: not applicable.
- Idempotency: `POST /books` is not idempotent; `PATCH` and `DELETE` are idempotent by id.
- Response coverage: every generated and returned `Data` field appears in a response.

## Locales

None

## Accessibility

None

## Repositories

None
