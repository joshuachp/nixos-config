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
    qt.platformTheme = "qt5ct";
    environment.variables.QT_QPA_PLATFORM = "wayland;xcb";
    environment.systemPackages = with pkgs; [
      libsForQt5.breeze-qt5
      libsForQt5.breeze-icons
    ] ++ (lib.optionals cfg.wayland (with pkgs; [
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
    ]));
  };
}
