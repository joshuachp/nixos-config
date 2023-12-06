# Gnome desktop configuration
{ config
, lib
, ...
}: {
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
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
            "pop-shell@system76.com"
          ];
        };
        "org/gnome/shell/extensions/pop-shell" = {
          gap-inner = 1;
          gap-outer = 1;
          tile-by-default = 1;
          tile-enter = [ "<Super>r" ];
        };
      };
    };
}
