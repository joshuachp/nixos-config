# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs
, nixos-hardware
, ...
}: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Modules
      ../../modules/nixos/cli.nix
      ../../modules/nixos/desktop
      ../../modules/nixos/develop
      ../../modules/nixos/documentation.nix
      ../../modules/nixos/embedded.nix
      ../../modules/nixos/gnupg.nix
      ../../modules/nixos/localization.nix
      ../../modules/nixos/localtime.nix
      ../../modules/nixos/network.nix
      ../../modules/nixos/nix
      ../../modules/nixos/services.nix
      #../../modules/nixos/wireguard/client.nix
      ../../modules/nixos/virtualisation.nix

      nixos-hardware.nixosModules.common-cpu-intel
      nixos-hardware.nixosModules.common-pc
      nixos-hardware.nixosModules.common-pc-ssd
    ];
  config = {
    security.tpm2.enable = true;

    # Enable desktop system
    systemConfig.desktop = {
      enable = true;
      wayland = true;
      gnome.enable = true;
    };
    nixosConfig = {
      boot.plymouth.enable = false;
      hardware.bluetooth.enable = true;
      desktop.sway.enable = true;
    };

    boot.plymouth.enable = true;

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
