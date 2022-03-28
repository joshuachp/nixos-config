{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix ./video-configuration.nix];

  boot.plymouth.enable = true;

  networking = {
    hostName = "nixos";
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
  services.udev.packages = [pkgs.yubikey-personalization];

  # Sudo U2F
  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    cue = true;
  };
}
