# Shared QT configuration between NixOs and Home-Manager
_: {
  config = {
    qt = {
      enable = true;
      platformTheme = "gnome";
    };
  };
}
