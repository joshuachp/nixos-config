{ config
, pkgs
, lib
, ...
}:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Modules
      ../../modules/nixos/cache.nix
      ../../modules/nixos/cli.nix
      ../../modules/nixos/develop
      ../../modules/nixos/documentation.nix
      ../../modules/nixos/gnupg.nix
      ../../modules/nixos/localization.nix
      ../../modules/nixos/localtime.nix
      ../../modules/nixos/network.nix
      ../../modules/nixos/nix
      ../../modules/nixos/services.nix
      ../../modules/nixos/wireguard/client.nix
    ];

  config = {
    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Rome";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    networking.firewall.enable = false;

    # List services that you want to enable:
    security.polkit.enable = true;
    services.pcscd.enable = false;
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    # YubiKey attributes
    services.udev.extraRules = ''
      ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", OWNER="joshuachp" TAG+="uaccess"
    '';

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    # Docker
    virtualisation.docker = {
      enable = true;
      daemon.settings.hosts = [ "fd://" "tcp://0.0.0.0:2376" ];
    };


    # Virtualbox shared folders
    users.groups = {
      vboxusers = { };
      # Group to share access to the docker mounted binds
      dockershare = {
        gid = 1001;
      };
    };
    users.users.joshuachp.extraGroups = [ "vboxsf" "vboxusers" "docker" "dockershare" ];

    environment.systemPackages = with pkgs; [
      # Youbikey
      yubikey-personalization

      # Crypt
      cryptsetup
    ];

    networking.hosts."127.0.0.1" = [ "database" "memcached" ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?
  };
}
