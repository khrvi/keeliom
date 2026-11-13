# F0003 — Edit book

Status: ready
Source: CHANGELOG.md §0.2.0

## Overview

A reader corrects a book they already added.

## Description

### Opening the edit screen

The reader opens a book from the book list. While the book loads, a skeleton is
shown. The form is pre-filled with the current values.

### Editing and saving

The reader edits the title, the author and the ISBN, then saves. Title and
author are required and must be 1–120 characters. Leading and trailing spaces
are removed from title and author before validation and saving.

The ISBN is optional. When present, spaces and hyphens are removed, and the
result must be 10 or 13 characters: digits, with `X` allowed as the last
character of an ISBN-10. The ISBN must be unique among other books.
Normalization runs before the uniqueness check. Clearing the ISBN removes it
from the book.

While submitting, the button is disabled. On success, the reader returns to the
list and sees "Book updated". On a validation error, the form keeps the entered
values.

### Cancel and missing books

Cancel returns to the list without saving. If the book does not exist, the
reader sees "Book not found".

## Out of scope

- Editing `created_at`.
- Bulk editing.
- Deleting a book.
- Editing from anywhere except the book list.

## Decisions

None

## Open questions

None
