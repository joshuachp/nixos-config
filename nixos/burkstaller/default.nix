# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  config = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    # Enable desktop system
    nixosConfig = {
      hardware = {
        bluetooth.enable = true;
        wifi.enable = true;
        graphics.gpu = [ "intel" ];
      };
      desktop = {
        sway.enable = true;
        hyprland.enable = true;
      };
      embedded.enable = true;
      virtualisation.enable = true;
    };

    virtualisation.podman.enable = true;

    # User homeManager configurations
    home-manager.users.joshuachp = {
      wayland.windowManager.hyprland.settings = {
        monitor = lib.mkForce [
          "DP-3,preferred,0x0,1"
          "DP-1,preferred,auto,1"
        ];
        xwayland = {
          force_zero_scaling = true;
        };
        exec-once = [
          "mattermost-desktop"
          "thunderbird"
        ];
      };

      xdg.configFile = {
        "autostart/thunderbird.desktop".source =
          "${pkgs.thunderbird}/share/applications/thunderbird.desktop";
        "autostart/Mattermost.desktop".source =
          "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop";
      };
    };

    # Enable btrfs scrubbing
    services.btrfs.autoScrub.enable = true;

    environment.systemPackages = with pkgs; [
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ];
  };
}
