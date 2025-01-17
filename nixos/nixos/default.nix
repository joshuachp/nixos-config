{
  flakeInputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./video-configuration.nix
  ];
  config = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    # Enable desktop system
    nixosConfig = {
      hardware = {
        bluetooth.enable = true;
        wifi.enable = true;
        graphics.gpu = [ "amd" ];
      };
      desktop = {
        hyprland.enable = true;
        sway = {
          enable = true;
          nvidia = true;
        };
        games.enable = true;
      };
      embedded.enable = true;
      virtualisation.enable = true;
    };

    # User homeManager configurations
    home-manager.users.joshuachp = {
      privateConfig = {
        syncthing.enable = true;
        kubeConfig = true;
      };
    };

    # Syncthing local firewall
    # https://docs.syncthing.net/users/firewall.html#local-firewall
    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };

    powerManagement.cpuFreqGovernor = "performance";

    services = {
      # Enable btrfs scrubbing
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [
          "/dev/Linux/root"
          "/dev/Linux/share"
        ];
      };
    };
  };
}
