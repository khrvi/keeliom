# Check for LLM

You are validating a Keeliom project. Do not modify files unless explicitly
asked.

## Read order

1. `app.md`
2. every `features/F*/feature.md`
3. `RULES.md`
4. `CHECK.md`

## Checks

1. `app.md` exists and has these sections:
   `One-liner`, `Users`, `Jobs`, `Scope`, `Non-goals`, `Glossary`,
   `Invariants`, `Stack`.
2. Feature directories match `F<4 digits>-<slug>/` (`F0001`–`F9999`) and are
   unique.
3. Every feature directory has `feature.md`. `brief.md` is optional but must be
   non-empty if present.
4. Every `feature.md` has a `Status: <value>` line directly under the title and
   these sections: `Why`, `Who`, `In scope`, `Out of scope`, `Rules`,
   `Acceptance`, `Tasks`.
5. `Status` is one of: `draft`, `ready`, `in_progress`, `done`, `deprecated`.
6. If `Status` is `ready`, the file contains no `TBD`.
7. `Acceptance` and `Tasks` contain only checkboxes (`- [ ]` or `- [x]`) and at
   least one checkbox unless `Status` is `draft`.
8. Optional sections (`Depends on`, `Data`, `API`, `Screens`, `Open questions`),
   if present, are not empty. `None` is allowed.
9. `Depends on` references existing feature IDs or is `None`.
10. Every feature has `changes/0001-initial.md`.
11. Change files are numbered sequentially (`0001`, `0002`, ...), contain
    `Date`, `Reason`, and `Changed`, and `Related` references existing feature
    IDs or `None`.
12. Relative Markdown links to `.md` files resolve.

## Output

If all checks pass, output exactly:

    OK

Otherwise, output one line per problem:

    file: section: problem

Do not fix anything. Do not invent content. If a check cannot be performed,
say which check and why.
