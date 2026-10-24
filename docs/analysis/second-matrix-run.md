# Second matrix run: analysis

**Run:** Candidates workflow, run 40055699472, on `main` at `2abc04f`, after the round-2 fixes. This run includes the reference object check. It supersedes `docs/analysis/first-matrix-run.md` for the current state of each candidate.

## Summary

- **Valid results:** four candidates reached the alphabetical traps and failed there: naive-psql, migra, pg-schema-diff and apgdiff. One candidate, psqldef, reported success and was caught by the object check. Atlas stopped on a licence limit. pgquarrel stopped at install.
- **Reference:** ordered-psql passes, with 55 objects, the full object set.
- **Pipeline:** the object check works. It fails the candidate when the object list differs from the reference, even if the deploy exited 0.

## Results

| Candidate | Install | Deploy | Objects match | What happened |
| --- | --- | --- | --- | --- |
| ordered-psql | pass | pass | pass | Reference. 55 objects. |
| psqldef | pass | pass | fail | Exited 0, but left out `sales.set_order_status`. Its log shows a parser fallback on that procedure. |
| naive-psql | pass | fail | fail | `schema "sales" does not exist`. The sorted order hits the trap. |
| migra | pass | fail | fail | Its shadow load hits the same trap, so migra itself never ran. |
| pg-schema-diff | pass | fail | fail | Its planner hits `schema "sales" does not exist` on a foreign key. |
| apgdiff | pass | fail | fail | `Cannot find schema 'sales'` on the first foreign key. |
| atlas | pass | fail | fail | `atlas login` is required for procedures. Free CLI limit. |
| pgquarrel | fail | skipped | fail | apt dependency conflict between PostgreSQL 18 server-dev and the runner's client. |
| dummy-fail | pass | fail | fail | Fails on purpose. |

## What the results say

1. **psqldef's pass is a false pass.** The deploy exits 0 without creating one procedure. Only the object check catches it. This is the strongest argument for comparing the object list, not trusting the exit code.
2. **Four tools hit the alphabetical trap, and they fail for different reasons.** pg-schema-diff and apgdiff parse the desired state themselves and fail on order. migra's failure is in the loader this repo wrote, so it does not yet say anything about migra's own ordering.
3. **Atlas's free CLI cannot create procedures.** The schema in this repo has one, so Atlas cannot deploy it without a login. That is a licensing fact, and it is a finding.
4. **pgquarrel cannot be installed on the runner.** The build needs PostgreSQL's server headers, and apt cannot install a consistent set next to the runner's PostgreSQL client. Its deploy has not been tested.

## Pipeline status

- Fixed: executable bits, the `public` schema in the object list, the pg-schema-diff flags, the psqldef `--apply` flag, the apgdiff URL, Atlas's SSL setting, and the Atlas dev database name.
- Fixed in CI, not in a candidate: the object comparison now fails candidates that exit 0 with missing objects.
- Still open: pgquarrel's build dependencies.

## Proposed next steps (round 3)

These need decisions from you before they run.

1. **Atlas and procedures.** Options: (a) give CI an Atlas login token as a secret, which means a repo secret; (b) run Atlas on the tables and views only, and mark procedures as not supported; (c) drop Atlas. Recommendation: (b), and record it as a licence limit in the report.
2. **migra's loader.** The shadow load should use a loader that orders files, so migra's diff logic is what gets tested. That is a fairness change to how the candidate is run, so it should be an explicit decision.
3. **pgquarrel's build.** Build it inside a PostgreSQL 16 container job, so its headers match the server. That is a change to the matrix job shape, so it needs a decision.
4. **Version pins.** Every tool is unpinned. Pins are needed before results can be reproduced.
5. **Report.** Add the object-count difference against the reference to the report, so a candidate's gap is visible without opening the artifact.

## Suggested additional workflows

These lint the objects in the repo, beyond what sqlfluff checks today:

1. **One object per file.** Fail when a file under `database/` defines more than one `CREATE` statement, or when its name does not match the object it defines.
2. **Dependency order.** Parse `database/` and fail when an object references one that is not created earlier in the dependency order. This would catch the traps before any candidate runs.
3. **Required schema members.** Fail when `database/` lacks a schema, a view that depends on a view, or a procedure, as section 3 of `docs/plan.md` requires.
4. **Candidate contract.** Fail when a candidate folder lacks `bin/deploy.sh`, `bin/devcontainer_post_create.sh` or `README.md`.
5. **Procedure bodies.** Run `plpgsql_check` against a scratch database, so a procedure that references a missing table fails even if it was created.
