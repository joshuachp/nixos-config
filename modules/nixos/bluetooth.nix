# Enables the hardware configs for bluetooth and configures bluez service.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    nixosConfig.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth";
  };
  config =
    let
      cfg = config.nixosConfig.hardware.bluetooth;
    in
    lib.mkIf cfg.enable {
      hardware.bluetooth = {
        enable = true;

        # Enables the experimental features like battery status for the device.
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    };
}
