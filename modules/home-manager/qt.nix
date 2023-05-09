_: {
  imports = [
    ../common/desktop/qt.nix
  ];
  config = {
    qt.style.name = "adwaita-dark";
    home.sessionVariables.QT_QPA_PLATFORM = "wayland;xcb";
  };
}
