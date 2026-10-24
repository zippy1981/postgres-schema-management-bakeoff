# 0005 Candidate folder structure

Status: Accepted

## Context

Each candidate tool needs a predictable place for its scripts, its working files, and its test evidence. A fixed layout lets reviewers compare candidates directly and lets the test harness find results without special cases.

## Decision

Each candidate lives in `candidates/<CANDIDATE_NAME>/` with this structure:

```text
candidates/<CANDIDATE_NAME>/
├── bin/                         # scripts that run the candidate, including bin/devcontainer_post_create.sh (ADR 0006)
├── working_folder/              # the candidate's own working files (config, generated output, state)
└── test_results/
    ├── test_logs.log            # log output from the candidate's test run
    └── sql_dump.sql             # schema dump taken from the candidate's database after deployment
```

- `bin/` holds the candidate's executable scripts.
- `working_folder/` holds files the candidate needs while it works. It does not hold a copy of the schema (ADR 0004).
- `test_results/test_logs.log` and `test_results/sql_dump.sql` are required outputs of every test run. A run that does not produce both is incomplete.

## Consequences

- Every candidate can be checked against the same structure with a simple listing.
- The dump file gives an objective record of what each tool actually produced, which supports comparison.
- Candidates cannot add arbitrary top-level folders under `candidates/<NAME>/` without an ADR, to keep comparisons uniform. Extra files inside the existing folders are allowed.
