# Gnome config for NixOS
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.systemConfig.desktop.gnome;
  enable = config.systemConfig.desktop.enable && cfg.enable;
in
{
  config = lib.mkIf enable {
    services.xserver.desktopManager.gnome.enable = true;

    # List services that you want to enable:
    services = {
      gnome = {
        gnome-keyring.enable = true;
        evolution-data-server.enable = true;
        gnome-online-accounts.enable = true;
        gnome-remote-desktop.enable = true;
      };

      # Udev
      udev.packages = with pkgs; [ gnome-settings-daemon ];
    };

    environment.gnome.excludePackages = with pkgs; [ epiphany ];

    environment.systemPackages = with pkgs; [
      gnome-podcasts
      dconf-editor
      gnome-tweaks
      gnome-sound-recorder
      gnomeExtensions.appindicator
    ];
  };
}
