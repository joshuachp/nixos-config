# i3 config
{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.nixosConfig.desktop.i3;
  enable = config.systemConfig.desktop.enable && cfg.enable;
in
{
  options = {
    nixosConfig.desktop.i3.enable = lib.options.mkEnableOption "i3 window manager";
  };
  config = lib.mkIf enable {
    services.xserver.windowManager.i3.enable = true;

    environment.systemPackages = with pkgs; [
      feh
      polybar
      rofi
    ];
  };
}
