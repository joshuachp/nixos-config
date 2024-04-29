#!/usr/bin/env bash

set -exEuo pipefail

shell_cleanup() {
    echo "Exiting"
    exit 126
}
trap shell_cleanup SIGINT

cleanup_old() {
    local host="$1"

    ssh "root@$host.wg" -- nix-collect-garbage -d
    ssh "$USER@$host.wg" -- nix-collect-garbage -d
}

check_online() {
    local host="$1"
    while true; do
        if ! ping -c 5 -w 10 "$host.wg"; then
            continue
        else
            break
        fi
    done
}

deploy_host() {
    local host="$1"

    deploy -s ".#$host"

    cleanup_old "$host"

    ssh "root@$host.wg" -- free -h
    ssh "root@$host.wg" -- lsblk --fs

    ssh "root@$host.wg" -- reboot

    check_online "$host"
}

if [ "$1" = "all" ]; then
    for h in kuma nixos-cloud nixos-cloud-2 tabour; do
        deploy_host $h
    done
else
    deploy_host "$1"
fi
