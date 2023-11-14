# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs
, ...
}: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  config = {
    security = {
      tpm2.enable = true;
      # Sudo impl
      sudo.enable = false;
      sudo-rs.enable = true;
    };

    users.users.joshuachp.extraGroups = [ "docker" ];
    environment.systemPackages = [ pkgs.astartectl ];

    # Enable desktop system
    systemConfig.desktop = {
      enable = true;
      wayland = true;
      gnome.enable = true;
    };
    nixosConfig = {
      boot.plymouth.enable = false;
      hardware = {
        bluetooth.enable = true;
        wifi.enable = true;
        opengl = {
          enable = true;
          intel = true;
        };
      };
      desktop = {
        sway.enable = true;
        hyprland.enable = true;
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

    boot.plymouth.enable = true;

    networking = {
      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      # Per-interface useDHCP will be mandatory in the future, so this generated config
      # replicates the default behaviour.
      useDHCP = false;
      #interfaces.eno1.useDHCP = true;
      #interfaces.wlo1.useDHCP = true;

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
      btrfs.autoScrub.enable = true;
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
