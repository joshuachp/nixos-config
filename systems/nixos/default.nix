{ pkgs
, nixos-hardware
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./video-configuration.nix

    # Modules
    ../../modules/nixos/cli.nix
    ../../modules/nixos/desktop
    ../../modules/nixos/develop
    ../../modules/nixos/documentation.nix
    ../../modules/nixos/embedded.nix
    ../../modules/nixos/gnupg.nix
    ../../modules/nixos/hacking.nix
    ../../modules/nixos/localization.nix
    ../../modules/nixos/localtime.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/wireguard/client.nix
    ../../modules/nixos/virtualisation.nix

    # Hardware configuration
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-hdd
    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
  ];
  config = {
    security.tpm2.enable = true;
    services.fwupd.enable = true;

    # Enable desktop system
    systemConfig = {
      desktop = {
        enable = true;
        wayland = true;
        gnome.enable = true;
      };
      hyprland.enable = true;
    };
    nixosConfig = {
      boot.plymouth.enable = true;
      hardware.bluetooth.enable = true;
      desktop = {
        sway = {
          enable = true;
          nvidia = true;
        };
      };
      nix.index.enable = true;
    };

    # Enable docker
    virtualisation.docker = {
      enable = true;
      # Only for dev
      enableOnBoot = false;
    };

    networking = {
      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      # Per-interface useDHCP will be mandatory in the future, so this generated config
      # replicates the default behaviour.
      useDHCP = false;
      #interfaces.eno1.useDHCP = true;
      #interfaces.wlo1.useDHCP = true;

      # Use NetworkManager
      networkmanager.enable = true;
      wireless.enable = false; # Enables wireless support via wpa_supplicant.

      # Open ports in the firewall.
      # firewall.allowedTCPPorts = [ ... ];
      # firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # firewall.enable = false;

      # Syncthing local firewall
      # https://docs.syncthing.net/users/firewall.html#local-firewall
      firewall.allowedTCPPorts = [ 22000 ];
      firewall.allowedUDPPorts = [ 22000 21027 ];

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = false;

    # Enable btrfs scrubbing
    services.btrfs.autoScrub.enable = true;

    # Yubikey
    services.udev.packages = [ pkgs.yubikey-personalization ];

    # Sudo U2F
    security.pam.u2f = {
      enable = true;
      control = "sufficient";
      cue = true;
    };
  };
}
