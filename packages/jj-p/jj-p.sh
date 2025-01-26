#!/usr/bin/env bash

set -exEuo pipefail

jj diff --from 'trunk()' --name-only |
    xargs --no-run-if-empty pre-commit run --files

jj git push "$@"
