# Demo

Keeliom: 0.4.0
Status: ready
Language: Russian

## One-liner

A demo app where a member keeps a list of items.

## Users

| User | Description |
|---|---|
| Member | Creates and views items. |

## Scope

- Create an item.

## Non-goals

- Sharing items.

## Glossary

| Term | Meaning |
|---|---|
| Item | A named record a member creates. |

## Invariants

- An item name is unique.

## Stack

- Language: Markdown only

## Roles

| Role | Can do |
|---|---|
| member | create and view items |

## Data model

| Entity | Owner | Key fields | Notes |
|---|---|---|---|
| Item | F0001 | id, name | none |
