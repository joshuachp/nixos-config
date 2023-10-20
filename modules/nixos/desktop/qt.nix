{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.systemConfig.desktop;
in
{
  config = lib.mkIf cfg.enable {
    qt = {
      style = "adwaita-dark";
    };
    environment.variables.QT_QPA_PLATFORM = "wayland;xcb";
    environment.systemPackages = lib.mkIf cfg.wayland (with pkgs; [
      qt6.qtwayland
    ]);
  };
}
