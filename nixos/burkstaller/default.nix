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
    boot.tmp.cleanOnBoot = true;

    users.users.joshuachp.extraGroups = [ "docker" ];
    environment.systemPackages = [ pkgs.astartectl ];

    # Enable desktop system
    systemConfig = {
      desktop = {
        enable = true;
        hidpi = true;
      };
      develop.enable = true;
    };
    nixosConfig = {
      boot.plymouth.enable = true;
      hardware = {
        bluetooth.enable = true;
        wifi.enable = true;
        opengl.gpu = [ "intel" ];
      };
      desktop = {
        sway.enable = true;
        hyprland.enable = true;
      };
      develop.k8s = true;
      nix.index.enable = true;
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
  };
}
