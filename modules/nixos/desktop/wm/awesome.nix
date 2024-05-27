# AwesomeWm config
{ config, lib, ... }:
let
  cfg = config.nixosConfig.desktop.awesome;
  enable = config.systemConfig.desktop.enable && cfg.enable;
in
{
  options = {
    nixosConfig.desktop.awesome.enable = lib.options.mkEnableOption "Awesome window manager";
  };
  config = lib.mkIf enable {
    services.xserver.windowManager.i3.enable = true;

    services.xserver.windowManager.awesome = {
      enable = true;
    };
  };
}
