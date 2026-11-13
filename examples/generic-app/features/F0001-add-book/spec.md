# F0001 — Add book — spec

Depends on: None

## Rules

- R1. Title is required, 1–120 characters. See `test:title_length`. (§Validation)
- R2. Author is required, 1–120 characters. See `test:author_length`. (§Validation)
- R3. Title and author are trimmed before validation and saving. (§Validation)
- R4. ISBN is optional; if present, it must be unique. (§Validation)
- R5. ISBN is stored without spaces and hyphens. (§Validation)
- R6. ISBN follows the `app.md` invariant: 10 or 13 characters after normalization, digits with `X` allowed as the last character of an ISBN-10, and unique. (§Validation)
- R7. Normalization runs before the uniqueness check. (§Validation)
- R8. On success, `POST /books` saves the book and returns `201` with the book. (§Saving and feedback)
- R9. The form starts empty. (§Adding a book)
- R10. While submitting, the button is disabled. (§Saving and feedback)
- R11. On success, the form is cleared and a confirmation is shown. (§Saving and feedback)
- R12. On validation error, the form keeps the entered values. (§Saving and feedback)
- R13. A book without a title is rejected with `title_required` and status `422`. (§Validation)
- R14. A book without an author is rejected with `author_required` and status `422`. (§Validation)
- R15. A duplicate ISBN is rejected with `isbn_taken` and status `422`. (§Validation)
- R16. An ISBN that is not 10 or 13 characters after normalization is rejected with `isbn_invalid` and status `422`. (§Validation)

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

## Tasks

- [ ] Create the `Book` entity and migration.
- [ ] Add `POST /books` with validation.
- [ ] Add the Add book screen.
- [ ] Add success and error states.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.
