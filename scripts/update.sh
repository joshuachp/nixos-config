#!/usr/bin/env bash

set -exEuo pipefail

changed=''

has_changed() {
    if [[ -n "$(jj diff --name-only)" ]]; then
        return 0
    fi

    return 1
}

# Fetch remotes
jj git fetch --all-remotes

if [[ -n "$(jj bookmark list 'chore/update')" ]]; then
    echo "Bookmark chore/update already exists"
    exit 1
fi

jj new main

# Pre-commit
pre-commit autoupdate
if has_changed; then
    jj commit -m 'chore(pre-commit): update pre-commit-config.yaml'

    changed+=', pre-commit-config.yaml'
fi

# Nix flake
nix flake update
if has_changed; then
    jj commit -m 'chore(nix): update flake.lock'

    changed+=', flake.lock'
fi

changed="${changed#, }"
if [ -z "$changed" ]; then
    echo 'nothing changed'
    exit 0
fi

jj bookmark create chore/update -r '@-'
jj git push --bookmark chore/update --allow-new
