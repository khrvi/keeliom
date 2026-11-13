# Notes

Status: ready

## One-liner

A small app where a member keeps private notes and tags.

## Users

| User | Description |
|---|---|
| Member | Writes notes and tags them. |

## Jobs

- Write a note.
- Tag a note.

## Scope

- Add a note with a title.
- Tag a note.

## Non-goals

- Sharing notes.

## Glossary

| Term | Meaning |
|---|---|
| Note | A titled record a member writes. |
| Tag | A label on a note. |

## Invariants

- A note always has a title.

## Stack

- Language: Markdown only
- Framework: none
- Database: none

## Roles

| Role | Can do |
|---|---|
| Member | Write and tag notes. |

## Data model

| Entity | Owner | Key fields | Notes |
|---|---|---|---|
| Note | F0001 | id, title | none |
| Tag | F0002 | id, name | none |

## API conventions

- Single resource: JSON object.
- Collection: JSON array.
- Errors: `Code | Status | When`

## Locales

None

## Accessibility

None

## Repositories

None
