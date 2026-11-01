# Book Library

## One-liner

A small personal library where a reader can add books and see what they own.

## Users

- Reader: adds books and views the list.

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
- If an ISBN is present, it is 10 or 13 characters after normalization and unique.

## Stack

- Language: TypeScript
- Framework: none (example)
- Database: SQLite

## Roles

| Role | Can do |
|---|---|
| Reader | Adds books and views the list. |

## Data model

| Table | Owner feature | Key columns | Notes |
|---|---|---|---|
| Book | F0001-add-book | id, title, author, isbn, created_at | F0002 reads it; F0003 updates it; F0004 deletes it. |

## API conventions

- Envelope: JSON object; lists are JSON arrays.
- Errors: `Code | Status | When`
- Pagination: none.
- Field naming: snake_case.
- Enums: none.
- Auth: none.
- CSRF: not applicable.
- Sign-in and sign-out: not applicable.
- Idempotency: `POST /books` is not idempotent; `PATCH` and `DELETE` are idempotent by id.
- Response coverage: every generated and returned `Data` field appears in a response.

## Repositories

None
