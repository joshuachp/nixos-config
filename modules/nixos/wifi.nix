# Wifi configuration
{ config, lib, ... }:
let
  cfg = config.nixosConfig.hardware.wifi;
in
{
  options = {
    nixosConfig.hardware.wifi.enable = lib.options.mkEnableOption "Wifi";
  };
  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      wireless = {
        # Enables wireless support via wpa_supplicant.
        enable = false;
        iwd.enable = true;
      };
    };
  };
}
