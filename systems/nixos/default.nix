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
    ../../modules/cli.nix
    ../../modules/desktop
    ../../modules/develop
    ../../modules/documentation.nix
    ../../modules/gnupg.nix
    ../../modules/hacking.nix
    ../../modules/localization.nix
    ../../modules/localtime.nix
    ../../modules/network.nix
    ../../modules/nix
    ../../modules/services.nix

    # Hardware configuration
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-hdd
    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
  ];
  config = {
    boot.plymouth.enable = true;
    security.tpm2.enable = true;

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
