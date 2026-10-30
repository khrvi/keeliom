# F0003 — Edit book

Status: ready

## Why

The reader needs to correct a book they already added.

## Who

Reader.

## Depends on

F0001, F0002

## In scope

- Open a book from the list.
- Edit title, author, and ISBN.
- Save changes.
- Cancel without changes.
- Validation and error states.

## Out of scope

- Editing `created_at`.
- Bulk editing.
- Deleting a book.
- Editing from anywhere except the book list.

## Rules

- Title is required, 1–120 characters.
- Author is required, 1–120 characters.
- Title and author are trimmed before validation and saving.
- ISBN is optional; if present, it must be unique among other books.
- The form is pre-filled with the current values.
- On success, return to the list and show "Book updated".
- On validation error, keep the entered values.
- If the book does not exist, show "Book not found".
- Cancel returns to the list without saving.

## Data

Reads and updates `Book`:

| Field | Type | Used for |
|---|---|---|
| `id` | integer | lookup |
| `title` | string | edit |
| `author` | string | edit |
| `isbn` | string | edit, if present |

## API

```
PATCH /books/:id
```

Request:

```json
{ "title": "Dune", "author": "Frank Herbert", "isbn": "9780441013593" }
```

Response `200`:

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

## Acceptance

- [ ] The reader can open a book from the list and edit it.
- [ ] The form is pre-filled with the current values.
- [ ] Saving updates the book.
- [ ] Leading and trailing spaces in title and author are removed before saving.
- [ ] A book without a title is rejected with a clear error.
- [ ] A book without an author is rejected with a clear error.
- [ ] An ISBN used by another book is rejected.
- [ ] The current book's own ISBN is accepted.
- [ ] Cancel returns to the list without changes.
- [ ] A missing book shows "Book not found".

## Tasks

- [ ] Add `PATCH /books/:id`.
- [ ] Add the edit screen.
- [ ] Pre-fill the form.
- [ ] Add validation and error states.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.

## Open questions

None
