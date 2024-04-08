#!/usr/bin/env bash

set -exEuo pipefail

host="$1"

cleanup_old() {
    ssh "root@$host.wg" -- nix-collect-garbage -d
    ssh "$USER@$host.wg" -- nix-collect-garbage -d
}

deploy -s ".#$host"

cleanup_old

ssh "root@$host.wg" -- free -h
ssh "root@$host.wg" -- lsblk --fs

ssh "root@$host.wg" -- reboot

ping "$host.wg"
