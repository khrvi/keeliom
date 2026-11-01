# F0004 — Delete book

Status: ready
Release: None
Repository: None
Replaced by: None

## Why

The reader needs to remove a book they no longer own.

## Who

Reader.

## Depends on

F0001, F0002

## Related

None

## In scope

- Delete a book from the list.
- Confirmation before deleting.
- Success and error states.

## Out of scope

- Bulk delete.
- Undo.
- Restoring a deleted book.

## Rules

- Ask for confirmation before deleting.
- Delete the book by id.
- After success, remove the book from the list and show "Book deleted".
- If the book does not exist, show "Book not found".
- If the request fails, keep the book in the list and show an error.
- Cancel does not delete anything.

## Data

Deletes `Book` by `id`.

## API

```
DELETE /books/:id
```

Response `204` with no body.

Errors:

| Code | Status | When |
|---|---|---|
| `book_not_found` | 404 | the book does not exist |

## Screens

Screen: Delete book

| State | What the reader sees |
|---|---|
| `confirm` | confirmation dialog with Cancel and Delete |
| `deleting` | Delete disabled, spinner |
| `success` | book removed, "Book deleted" |
| `error` | error message, book remains |
| `not_found` | "Book not found" |

## Acceptance

- [ ] The reader can delete a book from the list.
- [ ] A confirmation is required before deleting.
- [ ] Cancel does not delete the book.
- [ ] The book disappears from the list after deletion.
- [ ] A missing book shows "Book not found".
- [ ] A failed request keeps the book in the list.

## Tasks

- [ ] Add `DELETE /books/:id`.
- [ ] Add the confirmation dialog.
- [ ] Remove the book from the list after success.
- [ ] Add error handling.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.

## Decisions

None

## Open questions

None
