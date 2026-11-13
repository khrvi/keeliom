# F0001 — Add book

Status: ready

## Why

The reader needs to record a book they own.

## Who

Reader.

## Depends on

None

## Reads

None

## Related

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

- Title is required, 1–120 characters. See `test:title_length`.
- Author is required, 1–120 characters. See `test:author_length`.
- Title and author are trimmed before validation and saving.
- ISBN is optional; if present, it must be unique.
- ISBN is stored without spaces and hyphens.
- ISBN follows the `app.md` invariant: 10 or 13 characters after normalization, digits with `X` allowed as the last character of an ISBN-10, and unique.
- Normalization runs before the uniqueness check.
- On success, `POST /books` saves the book and returns `201` with the book.
- The form starts empty.
- While submitting, the button is disabled.
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
{ "id": 1, "title": "Dune", "author": "Frank Herbert", "isbn": "9780441013593", "created_at": "2026-10-30T12:00:00Z" }
```

Errors:

| Code | Status | When |
|---|---|---|
| `title_required` | 422 | title is missing or blank |
| `author_required` | 422 | author is missing or blank |
| `isbn_taken` | 422 | ISBN already exists |
| `isbn_invalid` | 422 | ISBN is not 10 or 13 valid characters after normalization |

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

- [ ] A reader can add a book with title and author and receives `201` with the book.
- [ ] Leading and trailing spaces in title and author are removed before saving.
- [ ] ISBN spaces and hyphens are removed before saving.
- [ ] An ISBN is normalized before the uniqueness check. See `test:isbn_normalization`.
- [ ] The book is saved and returned by `POST /books`.
- [ ] A book without a title is rejected with `title_required` and status `422`.
- [ ] A book without an author is rejected with `author_required` and status `422`.
- [ ] A duplicate ISBN is rejected with `isbn_taken` and status `422`.
- [ ] An ISBN that is not 10 or 13 characters after normalization is rejected with `isbn_invalid` and status `422`.
- [ ] The form keeps values after a validation error.
- [ ] The form is cleared after success.

## Tasks

- [ ] Create the `Book` entity and migration.
- [ ] Add `POST /books` with validation.
- [ ] Add the Add book screen.
- [ ] Add success and error states.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.

## Decisions

| ID | From | Question | Answer | Source | Status | Date |
|---|---|---|---|---|---|---|
| D1 | None | Should title and author be trimmed? | Yes, before validation and saving. | changes/0002-trim-title.md | approved | 2026-10-30 |

## Open questions

None
