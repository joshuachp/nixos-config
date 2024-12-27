# Gnome desktop configuration
{ config, lib, ... }:
{
  config =
    let
      cfg = config.systemConfig.desktop.gnome;
    in
    lib.mkIf cfg.enable {
      dconf.settings = {
        # Terminal shortcut for Gnome
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Terminal";
          binding = "<Super>Return";
          command = "alacritty";
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        };
        "org/gnome/mutter" = {
          experimental-features = [ "scale-monitor-framebuffer" ];
        };
        "org/gnome/shell" = {
          enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
        };
        "org/gnome/desktop/interface" = {
          font-name = "Inter 11";
          document-font-name = "Atkinson Hyperlegible 12";
          monospace-font-name = "JetBrainsMono Nerd Font 11";
        };
      };
    };
}
