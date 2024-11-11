{ flakeInputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./video-configuration.nix
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

    powerManagement.cpuFreqGovernor = "performance";

    programs.steam.enable = true;

    # Enable desktop system
    systemConfig = {
      develop.enable = true;
    };
    nixosConfig = {
      hardware = {
        bluetooth.enable = true;
        wifi.enable = true;
        opengl.gpu = [ "amd" ];
      };
      desktop = {
        hyprland.enable = true;
        sway = {
          enable = true;
          nvidia = true;
        };
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

    programs.gamescope.enable = true;

    services = {
      # Enable btrfs scrubbing
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [
          "/dev/Linux/root"
          "/dev/Linux/share"
        ];
      };

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
            ];
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 32;
          };

        };
      };
    };
  };
}
