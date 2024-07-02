# nixos-config

[![status-badge](https://ci.k.joshuachp.dev/api/badges/1/status.svg)](https://ci.k.joshuachp.dev/repos/1)

This repository contains the configuration files for managing NixOS systems.

## Architecture

- `homes`: configurations to manage nix throw home-manager
- `lib`: library functions and helpers
- `modules`: nixos modules, divided for the functionalities
  - `common`: common modules which must work for both home-manager and nixos
  - `home-manager`: home-manager modules, configuration specific for the home-manager options.
  - `nixos`: nixos modules, configuration specific for the nixos options.
- `options`: contains system/configuration wide options, shared between nixos and home-manager. Some
  example are: nix system version, if its a desktop, ...
- `overlays`: overlays file and imported packages from flake inputs
- `patches`: patch files useful for the overlays
- `pkgs`: files containing various list of packages. This is to make the configuration sharable
  between nixos and home-manager. Since the options are not always the same we cannot always use the
  same modules, but usually the required packages are the same. This directory contains the lists of
  packages for the various modules, like development, desktop programs, ...
- `systems`: NixOS systems configurations, this contains the various hosts and machine specific
  configurations.
- `users`: user configurations, options regarding specific users, like name default shells and so
  on.

## Options

The category of options are:

- `systemConfig`: system wide options, for both nixos and home-manager
- `nixosConfig`: nixos specific options
- `homeConfig`: home-manager specific options

The options can be set in the `options` directory, and at the top of each module, but there MUST not
be respectively a `nixosConfig` or `homeConfig` options in the home-manager or nixos module
directories.

The `systemConfig` options will be shared to the home-manager on nixos config in the
[`users/default.nix`] file.
