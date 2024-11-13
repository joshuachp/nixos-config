# Enables the hardware configs for bluetooth and configures bluez service.
{ config, lib, ... }:
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
        powerOnBoot = false;

        # Enables the experimental features like battery status for the device.
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    };
}
