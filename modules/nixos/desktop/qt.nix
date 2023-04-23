_: {
  config = {
    qt5 = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
    environment.variables.QT_QPA_PLATFORM = "wayland;xcb";
  };
}
