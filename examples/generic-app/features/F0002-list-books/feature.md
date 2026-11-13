# F0002 — List books

Status: ready
Source: CHANGELOG.md §0.2.0

## Overview

A reader sees the books they own after adding them.

## Description

### The book list

The reader sees a list of all books, newest first. Each row shows the title and
the author, and the ISBN when it is present.

### List states

While the list loads, a skeleton is shown. When there are no books, the list
shows "No books yet". When the request fails, the reader sees an error and a
retry action.

## Out of scope

- Search and filters.
- Pagination.
- Editing and deleting.
- Sorting options.

## Decisions

None

## Open questions

None
