{
  config,
  hostname,
  ...
}:
{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./cli.nix
    ./desktop
    ./develop
    ./documentation.nix
    ./embedded.nix
    ./gnupg.nix
    ./localization.nix
    ./localtime.nix
    ./networking
    ./nix
    ./opengl.nix
    ./plymouth.nix
    ./security.nix
    ./server
    ./services.nix
    ./virtualisation.nix
    ./wifi.nix
    ./wireguard
  ];

  config = {
    networking.hostName = hostname;

    system = {
      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      stateVersion = config.systemConfig.version; # Did you read the comment?

      # Auto-update
      autoUpgrade = {
        enable = false;
        allowReboot = false;
      };
    };
  };
}
