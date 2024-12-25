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

    for _i in {0..3}; do
        if ! ping -c 5 -w 10 "$host.wg"; then
            echo "Retring to ping $host"
        else
            return 0
        fi
    done

    return 1
}

wait_online() {
    local host="$1"
    while ! ping -c 5 -w 10 "$host.wg"; do
        echo 'Retring to connect'
    done
}

deploy_host() {
    local host="$1"

    if ! check_online "$host"; then
        echo "Host $host is not online, skipping..."

        return
    fi

    nixos-rebuild boot --fast --flake ".#$host" \
        --use-substitutes \
        --target-host "root@$host.wg"

    ssh "root@$host.wg" -- free -h
    ssh "root@$host.wg" -- lsblk --fs

    # This prevent the script exiting if the ssh connection is terminated by the reboot
    ssh "root@$host.wg" 'reboot' || true

    wait_online "$host"

    cleanup_old "$host"

}

if [ "$1" = "all" ]; then
    for h in kuma nixos-cloud nixos-cloud-2 kani tabour; do
        deploy_host $h
    done
else
    deploy_host "$1"
fi
