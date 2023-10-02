# Gnome desktop configuration
{ config
, lib
, ...
}: {
  # TODO: this should check for gnome also
  config =
    let
      cfg = config.systemConfig.desktop;
      cfgEnable = cfg.enable && cfg.gnome.enable;
    in
    lib.mkIf cfgEnable {
      dconf.settings = {
        # Terminal shortcut for Gnome
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Terminal";
          binding = "<Super>Return";
          command = "alacritty";
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
        };
        "org/gnome/mutter" = {
          experimental-features = [ "scale-monitor-framebuffer" ];
        };
        "org/gnome/shell" = {
          enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
        };
      };
    };
}
