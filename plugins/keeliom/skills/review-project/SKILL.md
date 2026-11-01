---
name: review-project
description: Run a project-wide Keeliom review as a second opinion over the spec and the code.
---

# Review project

## When to use

- A project has several features and the per-feature CHECK pass is not enough.
- You need a second opinion on cross-feature rules, dependencies and claims
  against code.

## Input

- The whole project.

## Read order

1. `app.md`
2. every `features/F*/feature.md`
3. every `features/F*/brief.md`
4. every `features/F*/changes/*`
5. `RULES.md`
6. `CHECK.md`
7. the relevant code

## Process

1. Run the project-level checks from `CHECK.md` as a second opinion:
   - S6 shared-rule drift;
   - S7 implicit dependency;
   - C2 role values in code;
   - C3 capability without a feature.
2. Run S3 terminology across features.
3. Run the full S pass with file and line evidence.
4. Name both features in an S6 or S7 finding.
5. Output severity-ranked findings. Do not print `Project OK`; CHECK is the
   gate.
6. Do not modify files.

## Output

- Severity-ranked findings with evidence quotes.
- A short list of checks that could not run.
