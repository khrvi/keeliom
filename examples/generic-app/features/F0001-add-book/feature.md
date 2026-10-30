# F0001 — Add book

Status: ready

## Why

The reader needs to record a book they own.

## Who

Reader.

## Depends on

None

## In scope

- A form with title, author, and optional ISBN.
- Validation.
- Saving the book.
- Success and error states.

## Out of scope

- Editing an existing book.
- Deleting a book.
- Importing from an external source.

## Rules

- Title is required, 1–120 characters.
- Author is required, 1–120 characters.
- Title and author are trimmed before validation and saving.
- ISBN is optional; if present, it must be unique.
- ISBN is stored without spaces and hyphens.
- On success, the form is cleared and a confirmation is shown.
- On validation error, the form keeps the entered values.

## Data

Entity: Book

| Field | Type | Rules |
|---|---|---|
| `id` | integer | generated |
| `title` | string | required, max 120 |
| `author` | string | required, max 120 |
| `isbn` | string | optional, unique |
| `created_at` | timestamp | generated |

## API

```
POST /books
```

Request:

```json
{ "title": "Dune", "author": "Frank Herbert", "isbn": "9780441013593" }
```

Response `201`:

```json
{ "id": 1, "title": "Dune", "author": "Frank Herbert", "isbn": "9780441013593" }
```

Errors:

| Code | When |
|---|---|
| `title_required` | title is missing or blank |
| `author_required` | author is missing or blank |
| `isbn_taken` | ISBN already exists |

## Screens

Screen: Add book

| State | What the reader sees |
|---|---|
| `empty` | form with empty fields |
| `submitting` | button disabled, spinner |
| `success` | confirmation "Book added" |
| `error` | field errors, form values preserved |
| `duplicate_isbn` | error under the ISBN field |

## Acceptance

- [ ] A reader can add a book with title and author.
- [ ] Leading and trailing spaces in title and author are removed before saving.
- [ ] The book is saved and appears in the list.
- [ ] A book without a title is rejected with a clear error.
- [ ] A book without an author is rejected with a clear error.
- [ ] A duplicate ISBN is rejected with a clear error.
- [ ] The form keeps values after a validation error.
- [ ] The form is cleared after success.

## Tasks

- [ ] Create the `Book` entity and migration.
- [ ] Add `POST /books` with validation.
- [ ] Add the Add book screen.
- [ ] Add success and error states.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.

## Open questions

None
