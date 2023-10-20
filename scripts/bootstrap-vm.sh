#!/usr/bin/env bash

set -exEuo pipefail

modprobe nbd max_part=8
qemu-nbd --connect=/dev/nbd0 nixos.qcow2
fdisk /dev/nbd0 -l
mount /dev/nbd0 /mnt

cp -r /var/lib/age /mnt/var/lib

umount /mnt
qemu-nbd --disconnect /dev/nbd0
rmmod nbd
