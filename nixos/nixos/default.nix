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

    # Enable desktop system
    systemConfig = {
      develop.enable = true;
    };
    nixosConfig = {
      boot.plymouth.enable = true;
      hardware = {
        bluetooth.enable = true;
        wifi.enable = true;
        opengl.gpu = [ "amd" ];
      };
      desktop = {
        hyprland.enable = true;
      };
      develop.k8s = true;
      nix.index.enable = true;
      documentation.enable = true;
      embedded.enable = true;
      networking.privateDns = true;
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

    # Enable docker
    users.users.joshuachp.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      # Only for dev
      enableOnBoot = false;
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

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = false;

    services = {
      fwupd.enable = true;
      # Enable btrfs scrubbing
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [
          "/"
          "/nix"
          "/home"
          "/var"
          "/share"
        ];
      };
    };
  };
}
