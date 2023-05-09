_: {
  imports = [
    ../../common/desktop/qt.nix
  ];
  config = {
    qt = {
      style = "adwaita-dark";
    };
    environment.variables.QT_QPA_PLATFORM = "wayland;xcb";
  };
}
