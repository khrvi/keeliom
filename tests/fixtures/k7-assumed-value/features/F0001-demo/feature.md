# F0001 — Create item

Status: draft
Source: owner:demo, 2026-11-13

## Overview

A member creates an item so it appears in their list.

## Description

### Creating an item

The member enters a name and saves. A name is required and must be unique. After
saving, verification checks the content digest using SHA-256.

## Out of scope

- Editing an item.

## Decisions

| ID | Decision | Source | Status |
|---|---|---|---|
| D1 | Item names are unique. | owner:demo, 2026-11-13 | approved |
| D2 | The verification digest is SHA-256. | owner:demo, 2026-11-13 | assumed |

## Open questions

None
