{ config
, pkgs
, lib
, ...
}:
let
  inherit (config.systemConfig.desktop) wayland;
in
{
  imports = [
    ../../common/desktop/qt.nix
  ];
  config = {
    qt = {
      style = "adwaita-dark";
    };
    environment.variables.QT_QPA_PLATFORM = "wayland;xcb";
    environment.systemPackages = lib.mkIf wayland (with pkgs; [
      qt6.qtwayland
    ]);
  };
}
