{ config
, pkgs
, ...
}: {
  imports = [ ./hardware-configuration.nix ];
  config = {
    wsl = {
      enable = true;
      defaultUser = "joshuachp";
      startMenuLaunchers = true;
      docker-desktop.enable = true;

      wslConf = {
        automount.root = "/mnt";
      };
    };

    networking.hostName = "nixos-wsl";

    environment.systemPackages = with pkgs; [
      pinentry-curses
    ];

    security.sudo.wheelNeedsPassword = false;
  };
}
