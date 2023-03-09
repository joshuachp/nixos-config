{ config
, pkgs
, nixos-wsl
, lib
, ...
}: {
  imports = [
    # ./hardware-configuration.nix
    # Modules
    ../../modules/nixos/cli.nix
    ../../modules/nixos/develop
    ../../modules/nixos/documentation.nix
    ../../modules/nixos/gnupg.nix
    ../../modules/nixos/localization.nix
    ../../modules/nixos/localtime.nix
    ../../modules/nixos/nix
    ../../modules/nixos/services.nix
    # Wsl configuration
    nixos-wsl.nixosModules.wsl
  ];
  config = {
    wsl = {
      enable = true;
      defaultUser = "joshuachp";
      startMenuLaunchers = true;

      interop = {
        includePath = false;
      };

      wslConf = {
        interop.enabled = false;
        automount.root = "/mnt";
      };
    };

    environment.systemPackages = with pkgs; [
      pinentry-curses
    ];

    security.sudo.wheelNeedsPassword = false;
  };
}
