# F0003 — Edit book — spec

Depends on: F0001, F0002

## Rules

- R1. Title is required, 1–120 characters. See `test:title_length`. (§Editing and saving)
- R2. Author is required, 1–120 characters. See `test:author_length`. (§Editing and saving)
- R3. Title and author are trimmed before validation and saving. (§Editing and saving)
- R4. ISBN is optional; if present, it must be unique among other books. (§Editing and saving)
- R5. ISBN is stored without spaces and hyphens before validation and saving. (§Editing and saving)
- R6. Normalization runs before the uniqueness check. (§Editing and saving)
- R7. Clearing the ISBN removes it from the book. (§Editing and saving)
- R8. ISBN follows the `app.md` invariant: 10 or 13 characters after normalization, digits with `X` allowed as the last character of an ISBN-10, and unique. (§Editing and saving)
- R9. While loading, show a skeleton. (§Opening the edit screen)
- R10. The form is pre-filled with the current values. (§Opening the edit screen)
- R11. The reader opens the edit screen from the book list. (§Opening the edit screen)
- R12. While submitting, the button is disabled. (§Editing and saving)
- R13. On success, return to the list and show "Book updated". (§Editing and saving)
- R14. On validation error, keep the entered values. (§Editing and saving)
- R15. If the book does not exist, show "Book not found". (§Cancel and missing books)
- R16. Cancel returns to the list without saving. (§Cancel and missing books)
- R17. Saving updates the book. (§Editing and saving)
- R18. A book without a title is rejected with `title_required` and status `422`. (§Editing and saving)
- R19. A book without an author is rejected with `author_required` and status `422`. (§Editing and saving)
- R20. An ISBN used by another book is rejected with `isbn_taken` and status `422`. (§Editing and saving)
- R21. An ISBN that is not 10 or 13 characters after normalization is rejected with `isbn_invalid` and status `422`. (§Editing and saving)

## Data

Reads and updates `Book` (see F0001 for the base write rules):

| Field | Type | Used for |
|---|---|---|
| `id` | integer | lookup |
| `title` | string | edit |
| `author` | string | edit |
| `isbn` | string | edit, if present |

## API

```
GET /books/:id
PATCH /books/:id
```

Response `200` for `GET /books/:id`:

```json
{ "id": 1, "title": "Dune", "author": "Frank Herbert", "isbn": "9780441013593" }
```

Request for `PATCH /books/:id`:

```json
{ "title": "Dune", "author": "Frank Herbert", "isbn": "9780441013593" }
```

Response `200` for `PATCH /books/:id`:

```json
{ "id": 1, "title": "Dune", "author": "Frank Herbert", "isbn": "9780441013593" }
```

Errors:

| Code | Status | When |
|---|---|---|
| `book_not_found` | 404 | the book does not exist |
| `title_required` | 422 | title is missing or blank |
| `author_required` | 422 | author is missing or blank |
| `isbn_taken` | 422 | ISBN belongs to another book |
| `isbn_invalid` | 422 | ISBN is not 10 or 13 valid characters after normalization |

## Screens

Screen: Edit book

| State | What the reader sees |
|---|---|
| `loading` | skeleton |
| `editing` | form pre-filled with current values |
| `submitting` | button disabled, spinner |
| `success` | returns to the list, "Book updated" |
| `error` | field errors, values preserved |
| `duplicate_isbn` | error under the ISBN field |
| `not_found` | "Book not found" |

## Tasks

- [ ] Add `PATCH /books/:id`.
- [ ] Add the edit screen.
- [ ] Pre-fill the form.
- [ ] Add validation and error states.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.
