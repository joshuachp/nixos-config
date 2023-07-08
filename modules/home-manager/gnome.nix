{ config
, lib
, ...
}: {
  # TODO: this should check for gnome also
  config = lib.mkIf config.systemConfig.desktop.enable {
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
