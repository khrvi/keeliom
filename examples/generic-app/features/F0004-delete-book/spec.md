# F0004 — Delete book — spec

Depends on: F0001, F0002

## Rules

- R1. Ask for confirmation before deleting. (§Deleting a book)
- R2. While deleting, the Delete button is disabled. (§Deleting a book)
- R3. Delete the book by id. (§Deleting a book)
- R4. After success, remove the book from the list and show "Book deleted". (§After deleting)
- R5. If the book does not exist, show "Book not found". (§After deleting)
- R6. If the request fails, keep the book in the list and show an error. (§After deleting)
- R7. Cancel does not delete anything. (§Deleting a book)

## Data

Deletes `Book` by `id`. See F0001 for write rules.

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

## Tasks

- [ ] Add `DELETE /books/:id`.
- [ ] Add the confirmation dialog.
- [ ] Remove the book from the list after success.
- [ ] Add error handling.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.
