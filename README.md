# nixos-config

NixOS configuration

## Architecture

- `deploy`: deploy data and configuration
- `homes`: configurations to manage nix throw home-manager
- `lib`: library functions and helpers
- `modules`: nixos modules, divided for the functionalities
  - `common`: common modules which must work for both home-manager and nixos
  - `home-manager`: home-manager modules, configuration specific for the
    home-manager options.
  - `nixos`: nixos modules, configuration specific for the nixos options.
- `options`: contains system/configuration wide options, shared between nixos
  and home-manager. Some example are: nix system version, if its a desktop, ...
- `overlays`: overlays file and imported packages from flake inputs
- `patches`: patch files useful for the overlays
- `pkgs`: files containing various list of packages. This is to make the
  configuration sharable between nixos and home-manager. Since the options are
  not always the same we cannot always use the same modules, but usually the
  required packages are the same. This directory contains the lists of packages
  for the various modules, like development, desktop programs, ...
- `systems`: NixOS systems configurations, this contains the various hosts and
  machine specific configurations.
- `users`: user configurations, options regarding specific users, like name
  default shells and so on.
