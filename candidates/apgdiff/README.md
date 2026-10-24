# apgdiff

Candidate: [apgdiff](https://www.apgdiff.com). A Java tool that compares two SQL dump files and prints the ALTER script between them.

## Tools installed

Downloaded by `bin/devcontainer_post_create.sh` into `~/.local/share/apgdiff`:

| Tool | Source | Why |
| --- | --- | --- |
| `apgdiff.jar` | `https://www.apgdiff.com/download/apgdiff-2.7.0.zip`, linked as `apgdiff.jar` | The candidate. |
| Java runtime | Must already be on `PATH` | Runs the jar. The hook fails without it. |
| `unzip`, `curl` | Already on the runner | Fetch and extract. |

## How it deploys

1. Compares an empty dump with `database/` in sorted path order.
2. Applies the resulting ALTER script to the target.

## Known limits

- The download URL and version are unverified. The first matrix run checks them.
- apgdiff does not parse per-object files. The input is the concatenated tree.
