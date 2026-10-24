#!/usr/bin/env bash
# Control: uses the system psql. Nothing to install, but checks that psql is present.
set -euo pipefail
psql --version
