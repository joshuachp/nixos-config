{ config
, pkgs
, ...
}: {
  imports = [ ./hardware-configuration.nix ];
  config = {
    wsl = {
      enable = true;
      automountPath = "/mnt";
      defaultUser = "joshuachp";
      startMenuLaunchers = true;
      docker-desktop.enable = true;
    };

    networking.hostName = "nixos-wsl";

    # Hostname
    environment.etc."wsl.conf".text = ''
      [network]
      hostname = nixos-wsl
    '';

    environment.systemPackages = with pkgs; [
      pinentry-curses
    ];

    security.sudo.wheelNeedsPassword = false;
  };
}
