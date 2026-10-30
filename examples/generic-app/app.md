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
- If an ISBN is present, it is unique.

## Stack

- Language: TypeScript
- Framework: none (example)
- Database: SQLite
- Tests: node:test
