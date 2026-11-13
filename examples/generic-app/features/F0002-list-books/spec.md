# F0002 — List books — spec

Depends on: F0001

## Rules

- R1. Show all books. (§The book list)
- R2. Sort by `created_at` descending. (§The book list)
- R3. Show title and author in every row. (§The book list)
- R4. Show ISBN only when it is present. (§The book list)
- R5. If there are no books, show "No books yet". (§List states)
- R6. If loading, show a skeleton. (§List states)
- R7. If the request fails, show an error and a retry action. (§List states)

## Data

Reads `Book` (see F0001 for write rules):

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

## Tasks

- [ ] Add `GET /books`.
- [ ] Add the book list screen.
- [ ] Add loading, empty, and error states.
- [ ] Add tests for the acceptance criteria.
- [ ] Update the feature status to `done`.
