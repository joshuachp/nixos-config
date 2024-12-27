# Enable options for embedded development
{ config, lib, ... }:
let
  cfg = config.nixosConfig.embedded;
in
{
  options = {
    nixosConfig.embedded.enable = lib.mkEnableOption "embedded options";
  };
  config = lib.mkIf cfg.enable {
    # Permission for the ESP32 device
    services.udev.extraRules = ''
      ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", TAG+="uaccess"
    '';

    users.users.joshuachp.extraGroups = [ "dialout" ];
  };
}
