{ config
, pkgs
, nixos-wsl
, lib
, ...
}: {
  imports = [
    # ./hardware-configuration.nix
    # Modules
    ../../modules/cli.nix
    ../../modules/develop
    ../../modules/documentation.nix
    ../../modules/gnupg.nix
    ../../modules/localization.nix
    ../../modules/localtime.nix
    ../../modules/nix
    ../../modules/services.nix
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
