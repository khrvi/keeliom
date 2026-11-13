# F0001 — Add book

Status: ready
Source: CHANGELOG.md §0.2.0

## Overview

A reader records a book they own so it appears in their library.

## Description

### Adding a book

The reader opens the Add book screen and enters a title, an author and,
optionally, an ISBN. The form starts empty. The reader submits the form to save
the book.

### Validation

Title and author are required and must be 1–120 characters. Leading and
trailing spaces are removed from title and author before validation and saving.

The ISBN is optional. When present, spaces and hyphens are removed, and the
result must be 10 or 13 characters: digits, with `X` allowed as the last
character of an ISBN-10. The ISBN must be unique. Normalization runs before the
uniqueness check.

### Saving and feedback

On success, the book is saved and the reader sees the confirmation "Book
added". The form is cleared. While the request is in flight, the submit button
is disabled and a spinner is shown.

On a validation error, the form keeps the entered values and shows the field
errors. A duplicate ISBN shows an error under the ISBN field.

## Out of scope

- Editing an existing book.
- Deleting a book.
- Importing from an external source.

## Decisions

| ID | Decision | Source | Status |
|---|---|---|---|
| D1 | Title and author are trimmed before validation and saving. | changes/0002-trim-title.md | approved |

## Open questions

None
