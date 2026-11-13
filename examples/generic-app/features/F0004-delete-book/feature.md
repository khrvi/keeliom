# F0004 — Delete book

Status: ready
Source: brief.md

## Overview

A reader removes a book they no longer own.

## Description

### Deleting a book

The reader deletes a book from the list. A confirmation is required before
deleting. While deleting, the Delete button is disabled. Cancel does not delete
anything.

### After deleting

After success, the book is removed from the list and "Book deleted" is shown.
If the book does not exist, "Book not found" is shown. If the request fails,
the book stays in the list and an error is shown.

## Out of scope

- Bulk delete.
- Undo.
- Restoring a deleted book.
- Per-user permissions; there are no accounts.

## Decisions

None

## Open questions

None
