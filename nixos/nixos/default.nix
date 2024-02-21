{ pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./video-configuration.nix
  ];
  config = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    powerManagement.cpuFreqGovernor = "performance";

    boot.tmp.cleanOnBoot = true;

    security = {
      tpm2.enable = true;
      # Sudo impl
      sudo.enable = false;
      sudo-rs.enable = true;

      # Sudo U2F
      pam.u2f = {
        enable = true;
        control = "sufficient";
        cue = true;
      };
    };

    # Enable desktop system
    systemConfig = {
      desktop.enable = true;
      develop.enable = true;
    };
    nixosConfig = {
      # TODO: Failed to boot after update, check in a while
      boot.plymouth.enable = false;
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
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "/" "/nix" "/home" "/var" "/share" ];
      };
      # Yubikey
      udev.packages = [ pkgs.yubikey-personalization ];
    };
  };
}
