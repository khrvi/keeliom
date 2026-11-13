# Notes

Status: ready

## One-liner

A small app where a member keeps private notes.

## Users

| User | Description |
|---|---|
| Member | Writes and reads notes. |

## Jobs

- Write a note I can read later.
- See the notes I wrote.

## Scope

- Add a note with a title.
- List notes.

## Non-goals

- Sharing notes.

## Glossary

| Term | Meaning |
|---|---|
| Note | A titled record a member writes. |

## Invariants

- A note always has a title.

## Stack

- Language: Markdown only
- Framework: none
- Database: none

## Roles

| Role | Can do |
|---|---|
| Member | Write and read notes. |

## Data model

| Entity | Owner | Key fields | Notes |
|---|---|---|---|
| Note | F0001-add-note | id, title | none |

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
