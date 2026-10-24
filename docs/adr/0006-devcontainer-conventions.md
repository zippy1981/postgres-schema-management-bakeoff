# 0006 Devcontainer conventions

Status: Accepted

## Context

The bake-off runs inside a devcontainer so every candidate starts from the same environment. Each candidate has its own setup needs, such as installing tools and starting services. The devcontainer configuration must run all of them without each candidate editing shared configuration, and Python tooling must install the same way everywhere.

## Decision

- Python tools are managed with `uv`. Candidates and repository scripts use `uv` to install and run Python tooling rather than bare `pip` or system Python.
- Each candidate provides `candidates/<CANDIDATE_NAME>/bin/devcontainer_post_create.sh`, which performs that candidate's one-time setup.
- A single loop script runs every candidate's `bin/devcontainer_post_create.sh`. The devcontainer's `postCreateCommand` calls this loop script, so candidates are set up without changing `.devcontainer/` for each one.
- Candidate setup scripts must be idempotent, because the loop may run again after a container rebuild.

## Consequences

- Adding a candidate requires only its own folder and setup script; the devcontainer configuration does not change.
- A failing candidate setup should be visible in the post-create output and should not hide the results of other candidates. The loop script is responsible for reporting each failure.
- Python dependency versions are resolved through `uv`, so results are reproducible across machines.
