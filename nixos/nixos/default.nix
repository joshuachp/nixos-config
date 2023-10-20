{ pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./video-configuration.nix
  ];
  config = {
    security.tpm2.enable = true;

    # Enable desktop system
    systemConfig = {
      desktop = {
        enable = true;
        wayland = true;
        gnome.enable = true;
      };
    };
    nixosConfig = {
      boot.plymouth.enable = true;
      hardware.bluetooth.enable = true;
      desktop = {
        hyprland = {
          enable = true;
          nvidia = true;
        };
      };
      nix.index.enable = true;
      documentation.enable = true;
      develop.enable = true;
      embedded.enable = true;
      networking.privateDns = true;
      wireguard.client = true;
      virtualisation.enable = true;
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

    services = {
      fwupd.enable = true;
      # Enable btrfs scrubbing
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "/" "/nix" "/home" "/var" "/share" ];
      };
      # Yubikey
      udev.packages = [ pkgs.yubikey-personalization ];
    };

    # Sudo U2F
    security.pam.u2f = {
      enable = true;
      control = "sufficient";
      cue = true;
    };
  };
}