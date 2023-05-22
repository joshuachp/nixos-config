{ config
, lib
, pkgs
, ...
}: {
  options = {
    nixosConfig.desktop.bluetooth.enable = lib.options.mkOption {
      default = false;
      defaultText = "Enables bluetooth";
      description = "Enable bluetooth hardware support and config";
      type = lib.types.bool;
    };
  };
  config =
    let
      cfg = config.nixosConfig.desktop.bluetooth;
    in
    lib.mkIf cfg.enable {
      hardware.bluetooth.enable = true;

      # To enable bluetooth experimental features, like the battery level
      hardware.bluetooth.package = pkgs.bluez5-experimental;

      hardware.bluetooth.settings = {
        General = {
          Experimental = true;
        };
      };
    };
}
