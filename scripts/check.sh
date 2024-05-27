#!/usr/bin/env bash

set -eEuxo pipefail

mkdir -p "${out?missing out variable}"

error=false

# Shell
shell_files=$(shfmt -d -i=4 .)
if [ -n "$shell_files" ]; then
    echo "Shell files need formatting"
    echo "$shell_files"
    error=true
fi
find . -type f -name '*.sh' -exec shellcheck {} + || error=true

# Nix
nixfmt --check ./**/*.nix || error=true
statix check . || error=true

# Check if any error occurred and create the out
if $error; then
    echo "failed" >>"$out/failed.txt"
    exit 1
else
    echo "success" >>"$out/success.txt"
fi
