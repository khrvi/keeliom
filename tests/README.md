# Tests

Two scripts. `lint.sh` is deterministic. `run.sh` needs the `claude` CLI.

```bash
bash tests/lint.sh          # the repository itself
bash tests/run.sh           # every fixture
bash tests/run.sh _base     # one fixture
```

## Lint

`lint.sh` checks the repository: privacy, versions, rule files, templates and
docs. It reads no project outside this repo and calls no model.

## Fixtures

`fixtures/` holds small Keeliom projects. Each one has an
`expected-findings.md` that names what `CHECK.md` must report.

- `_base/` is clean and expects `- none`. Every other fixture is a copy with
  one defect.
- A fixture has `app.md`, `features/F0001-demo/feature.md`,
  `features/F0001-demo/spec.md` and `features/F0001-demo/changes/0001-initial.md`.
  It has no `RULES.md`, `CHECK.md` or `KEELIOM_VERSION`; the plugin owns the
  rules.
- A code fixture adds a `src/` folder of Markdown files that stand in for code.

## Expectations

- `- none` means the output contains `Project OK` and no finding line.
- `- K<n>` means the output contains `[K<n>]`.
- `- line: <text>` means the output contains that text verbatim.

`run.sh` prints the full output of a failing fixture.
