{ config
, pkgs
, lib
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

    # Hardware configuration
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-hdd
    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
  ];
  config = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    boot.plymouth.enable = true;
    security.tpm2.enable = true;

    # Enable desktop system
    systemOption.desktopEnabled = true;

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

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = false;

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
