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
      ../../modules/cli.nix
      ../../modules/develop
      ../../modules/documentation.nix
      ../../modules/gnupg.nix
      ../../modules/localization.nix
      ../../modules/localtime.nix
      ../../modules/nix
      ../../modules/services.nix
      ../../modules/wireguard/client.nix
    ];

  nixpkgs.overlays = [
    (self: super: {
      phpStormRemote = super.jetbrains.phpstorm.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ../../patches/phpstorm.patch
        ];
        installPhase = (old.installPhase or "") + ''
          makeWrapper "$out/$pname/bin/remote-dev-server.sh" "$out/bin/phpstorm-remote-dev-server" \
            --prefix PATH : "$out/libexec/phpstorm:${lib.makeBinPath [ pkgs.jdk pkgs.coreutils pkgs.gnugrep pkgs.which pkgs.git ]}" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath ([
              # Some internals want libstdc++.so.6
              pkgs.stdenv.cc.cc.lib pkgs.libsecret pkgs.e2fsprogs
              pkgs.libnotify
            ])}" \
            --set-default JDK_HOME "$jdk" \
            --set-default ANDROID_JAVA_HOME "$jdk" \
            --set-default JAVA_HOME "$jdk" \
            --set PHPSTORM_JDK "$jdk" \
            --set PHPSTORM_VM_OPTIONS ${old.vmoptsFile}
        '';
      });
    })
  ];

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

  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", MODE="0660", TAG+="uaccess"
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Docker
  virtualisation.docker.enable = true;


  # Virtualbox shared folders
  users.groups = {
    vboxusers = { };
  };
  users.users.joshuachp.extraGroups = [ "vboxsf" "vboxusers" "docker" ];

  environment.systemPackages = with pkgs; [
    # Youbikey
    yubikey-personalization
    # Phpstorm
    phpStormRemote
  ];

  programs.java.package = pkgs.jetbrains.jdk;
  programs.java.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
