{ config
, hostname
, lib
, ...
}: {
  options = {
    systemOption.desktopEnabled = lib.options.mkOption {
      default = false;
      defaultText = "Defaults to CLI system";
      description = "Whether to enable the desktop environment";
      type = lib.types.bool;
    };
  };
  config = {
    networking.hostName = hostname;

    system = {
      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      stateVersion = "22.11"; # Did you read the comment?

      # Auto-update
      autoUpgrade = {
        enable = false;
        allowReboot = false;
      };
    };
  };
}
