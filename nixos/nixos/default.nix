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

    specialisation = {
      gaming.configuration = {
        system.nixos.tags = [ "gaming" ];

        boot = {
          kernelParams = [
            # Low latency kernel parameters
            "preempt=full"
            "threadirqs"
            "mitigations=off"
          ];
          kernel.sysctl = {
            "vm.max_map_count" = 2147483642;
          };
        };
      };
    };

    powerManagement.cpuFreqGovernor = "performance";
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        extest.enable = true;
        extraPackages = with pkgs; [
          gamescope
          gamemode
        ];
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
            softrealtime = "on";
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
    };
    users.users.joshuachp.extraGroups = [ "gamemode" ];

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
