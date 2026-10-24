# Atlas

Candidate: [Atlas](https://atlasgo.io) from Ariga. Its declarative mode takes the SQL source as desired state and applies the difference.

## Tools installed

Downloaded by `bin/devcontainer_post_create.sh` into `~/.local/bin`:

| Tool | Source | Why |
|---|---|---|
| `atlas` | `https://release.ariga.io/atlas/atlas-linux-amd64-latest` | The candidate CLI. |

## How it deploys

1. Creates a dev database, which Atlas uses to normalise the SQL.
2. Passes `database/` in sorted path order as one SQL file (`scripts/ci/desired-state.sh`).
3. Runs `atlas schema apply --to file://...` against the target.

## Known limits

- The binary is `latest`, not pinned. The install log records the version.
- Atlas also has a migration-directory mode. The rules rule that out, so only the declarative mode is used.
