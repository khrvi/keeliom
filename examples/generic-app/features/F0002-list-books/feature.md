# F0002 — List books

Status: ready
Release: None
Repository: None
Replaced by: None

## Why

The reader needs to see the books they own after adding them.

## Who

Reader.

## Depends on

F0001

## Related

None

## In scope

- A list of all books.
- Title, author, and ISBN (if present) in each row.
- Newest first.
- Empty, loading, and error states.

## Out of scope

- Search and filters.
- Pagination.
- Editing and deleting.
- Sorting options.

## Rules

- Show all books.
- Sort by `created_at` descending.
- Show title and author in every row.
- Show ISBN only when it is present.
- If there are no books, show "No books yet".
- If loading, show a skeleton.
- If the request fails, show an error and a retry action.

## Data

Reads `Book`:

| Field | Type | Used for |
|---|---|---|
| `id` | integer | row key |
| `title` | string | row |
| `author` | string | row |
| `isbn` | string | row, if present |
| `created_at` | timestamp | sorting |

## API

```
GET /books
```

Response `200`:

```json
[
  {
    "id": 1,
    "title": "Dune",
    "author": "Frank Herbert",
    "isbn": "9780441013593",
    "created_at": "2026-10-30T12:00:00Z"
  }
]
```

Errors:

| Code | Status | When |
|---|---|---|
| `books_unavailable` | 503 | the list cannot be loaded |

## Screens

Screen: Book list

| State | What the reader sees |
|---|---|
| `loading` | skeleton rows |
| `empty` | "No books yet" |
| `list` | rows with title, author, optional ISBN |
| `error` | error message and retry button |

## Acceptance

- [ ] The reader sees all books.
- [ ] A book added through F0001 appears in the list.
- [ ] Each row shows title and author.
- [ ] ISBN is shown only when present.
- [ ] Books are sorted newest first.
- [ ] An empty list shows "No books yet".
- [ ] A failed request shows an error and a retry action.

## Tasks

- [ ] Add `GET /books`.
- [ ] Add the book list screen.
- [ ] Add loading, empty, and error states.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.

## Decisions

None

## Open questions

None
