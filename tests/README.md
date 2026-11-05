# Tests

`fixtures/` holds small Keeliom projects. Each one has an
`expected-findings.md` that names the check the fixture must produce.

## Runner

`run.sh` asks the `claude` CLI to run each fixture's `CHECK.md` and fails when
an expected check ID is missing from the output.

```bash
bash tests/run.sh
```

The runner needs the `claude` CLI. It is optional; the framework itself has no
runtime.

`- none` in an `expected-findings.md` means the fixture must print exactly
`NO FINDINGS`.

`_base/` is a clean fixture. Its `expected-findings.md` says `- none`, so the
runner requires it to print `NO FINDINGS`. It is the starting point for new
fixtures and runs with the rest.
