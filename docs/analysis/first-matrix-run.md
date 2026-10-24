# First matrix run: analysis

**Run:** Candidates workflow, run 40054469631, on `main` at `2a61ebf` (the first run with all nine candidate folders). The report is the `bakeoff-report` artifact of that run. Each candidate's evidence is the `candidate-<name>` artifact.

## Summary

Of the eight candidates, only `ordered-psql` gives a valid result, and it passed. The other seven failed, and none reached the alphabetical traps. Two failed at install. Four failed on a permission bug in this repo. One failed on wrong CLI flags. Most of the failures are bugs in this repo, not findings about the tools.

The pipeline itself works: the dummy candidate fails as intended, and its dump and object list are still published.

## Results

| Candidate | Install | Deploy | Valid result? | Reason |
| --- | --- | --- | --- | --- |
| ordered-psql | pass | pass | yes | Applied 17 files in hand-written order. 56 objects. |
| dummy-fail | pass | fail | yes | Fails on purpose after creating the schemas. |
| naive-psql | pass | fail | no | `scripts/ci/desired-state.sh: Permission denied`. The trap was not reached. |
| migra | pass | fail | no | `scripts/ci/create-db.sh: Permission denied`. |
| atlas | pass | fail | no | `scripts/ci/create-db.sh: Permission denied`. |
| psqldef | pass | fail | no | `scripts/ci/desired-state.sh: Permission denied`. Also missing `--apply`, so it would dry-run. |
| pg-schema-diff | pass | fail | no | `unknown flag: --dsn` and `--version`. The flags are wrong. |
| pgquarrel | fail | skipped | no | `make: no makefile found`. The project builds with CMake. |
| apgdiff | fail | skipped | no | `curl: 404`. The download URL is wrong. |

## Pipeline bugs

1. **Executable bits are missing.** Git stores `scripts/ci/*.sh` and `candidates/*/bin/*.sh` as `100644`. Any script that calls another script directly fails with `Permission denied`. Four candidates and the naive control are affected.
2. **The `public` schema is counted as an object.** Every candidate shows at least one object for it, so the object counts are inflated by one.
3. **The report depends on the artifact layout.** It works, but it has no check that a candidate's files are all present.

## Tool and usage errors

1. **pg-schema-diff** has no `--dsn` or `--version`. `apply` takes `--from-dsn` and `--to-dir`, as shown in its README.
2. **psqldef** dry-runs unless `--apply` is passed. The current command would report success without changing anything.
3. **pgquarrel** compares two databases (`--source-dbname`, `--target-dbname`), not two dump files. It also builds with CMake.
4. **apgdiff** is at `https://www.apgdiff.com/download/apgdiff-2.4-bin.zip`, which returns 200. The version in the script is wrong.

## What is not yet known

- None of the tools has been tested on the alphabetical traps. The trap is only confirmed for the naive control, and only once the permission bug is fixed.
- Versions are unpinned for every candidate. Results cannot be reproduced exactly until they are pinned.
- The service runs Postgres 16, which matches the runner's `pg_dump`. `docs/plan.md` section 8 still asks for a pin decision.

## Proposed next steps

Work is split into one parent branch and one child branch per fix. Each child merges into the parent. The parent then merges into `main`, and the matrix runs again.

1. `next/fix-matrix`: parent, from `main`.
2. `next/exec-bits`: restore the executable bits. Blocks the naive, migra, atlas and psqldef results.
3. `next/report-exclude-public`: stop counting the `public` schema.
4. `next/pg-schema-diff-flags`: use `--from-dsn` and `--to-dir`, and remove the `--version` check.
5. `next/psqldef-apply`: add `--apply` so the deploy actually changes the database.
6. `next/pgquarrel-cmake`: build with CMake, and compare two databases instead of two dumps.
7. `next/apgdiff-url`: use the 2.4 binary URL.

After the parent merges, the matrix on `main` gives the second run. That run is the one to compare against the reference.

## Suggested follow-ups

- Pin every tool version, and record the pins in each candidate's README.
- Add a workflow that checks each candidate folder has the three required files, so a missing file fails before the matrix does.
