# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  flakeInputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  config = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    nixpkgs.overlays = [
      (self: super: {
        neovim-unwrapped =
          let
            unstablePkgs = import flakeInputs.nixpkgs-unstable { inherit (self) system; };
          in
          unstablePkgs.neovim-unwrapped;
      })
    ];

    # Enable desktop system
    systemConfig = {
      desktop.hidpi = true;
      develop.enable = true;
    };
    nixosConfig = {
      hardware = {
        bluetooth.enable = true;
        wifi.enable = true;
        opengl.gpu = [ "intel" ];
      };
      desktop = {
        sway.enable = true;
        hyprland.enable = true;
      };
      embedded.enable = true;
      virtualisation.enable = true;
    };

    # User homeManager configurations
    home-manager.users.joshuachp = {
      homeConfig.syncthing.enable = true;
      privateConfig = {
        syncthing.enable = true;
        kubeConfig = true;
      };
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
        "autostart/thunderbird.desktop".source = "${pkgs.thunderbird}/share/applications/thunderbird.desktop";
        "autostart/Mattermost.desktop".source = "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop";
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

    services = {
      # Enable btrfs scrubbing
      btrfs.autoScrub.enable = true;
      # Yubikey
      udev.packages = [ pkgs.yubikey-personalization ];

      # Reduce audio lag and stutter
      pipewire.extraConfig.pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            # This can be found with
            # grep -E 'Codec|Audio Output|rates' /proc/asound/card*/codec#*
            "default.clock.allowed-rates" = [
              44100
              48000
              96000
              192000
            ];
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 32;
          };

        };
      };
    };

    environment.systemPackages = with pkgs; [
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ];
  };
}
