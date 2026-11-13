# 02 — Conventions

- **Status:** draft
- **Date:** 2026-11-13
- **Related:** [`README.md`](../README.md), [`01-flow.md`](01-flow.md)

This page explains why the conventions exist. The formats themselves live in
[`RULES.md`](../plugins/keeliom/rules/RULES.md).

## 1. One home per fact

A rule is written once. `RULES.md` holds the formats, `CHECK.md` holds the
checks, a skill holds process steps, a template shows the shape. Other files
cite the home instead of restating it.

Why: v0.3 repeated the same grammar in four places. A rule change meant four
edits, and they drifted.

## 2. Two files per reader

[`feature.md`](../plugins/keeliom/rules/RULES.md#featuremd) is written for
developers and product owners. [`spec.md`](../plugins/keeliom/rules/RULES.md#specmd)
is written for agents and code.

Why: a human reading a feature does not need error codes and field types. An
agent implementing it does. Splitting by reader keeps both files short.

`feature.md` comes first. `spec.md` adds precision to it. If they repeat each
other, one of them is wrong.

## 3. Stable rule IDs

A rule is `R<n>`. Numbers are never reused and a removed rule retires its
number. Other features, plans and notes cite `F00xx R<n>`.

Why: code review comments, plans and tickets point at a rule by ID. Renumbering
breaks those references.

## 4. Decisions with sources

Every decision has a source: the owner, a brief, a plan or a code path. A
decision records what the owner chose, not what the agent suggested.

Why: the expensive part of a spec is the reasoning behind a choice. A source
lets a later reader check the choice against the original request.

An `assumed` decision marks a choice the owner has not confirmed. A `ready`
feature has none.

When a decision stops holding, its row stays and its status becomes
`replaced by D<n>`. Why: the history of the decision stays readable, and no one
mistakes the old choice for a current one.

## 5. Slim history

A change entry is written when a requirement or a decision changes. Review
fixes, wording and format migrations go in the commit message.

Why: v0.3 history was 40% process churn. A reader looking for why a requirement
changed had to filter out formatting noise.

## 6. Statuses

`draft`, `ready`, `done`, `deprecated`. Ticket systems track who works on what.

Why: a spec status answers one question: is this feature ready or shipped? The
old status for work in progress duplicated the ticket system and went stale.

## 7. Language

`app.md` sets `Language:`. The prose follows it. Headings, keys and IDs stay
English.

Why: an agent parses the headings and the keys. The prose is for the people who
work in that language.

## 8. Plans

A plan is a free-form document that spans features. It is a proposal and a
record of reasoning. Features are the current truth.

Why: release and redesign documents describe several features at once. A
feature file cannot hold them, and there is no useful section format for them.

## 9. Check overrides

A project can record an exception in `app.md §Check overrides`. The exception
names a check ID and a reason. `check` applies it and prints it.

Why: a real project has wording overlaps that a check cannot distinguish from a
defect. An override keeps the exception visible instead of loosening the check
for everyone.

## 10. Checks

The checks live in [`CHECK.md`](../plugins/keeliom/rules/CHECK.md). There are
nine, each catching a defect a person would otherwise miss. `check` prints the
findings and writes `STATUS.md`.
