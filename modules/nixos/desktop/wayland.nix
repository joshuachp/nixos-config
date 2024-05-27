# Wayland config
{ config, lib, ... }:
let
  cfg = config.systemConfig.desktop;
  enable = cfg.enable && cfg.wayland;
in
{
  config = lib.mkIf enable {
    # Wayland
    xdg.portal = {
      enable = true;
      # Collision with gnome
      # extraPortals = with pkgs; [
      #   xdg-desktop-portal-gtk
      # ];
    };
    # FIX: timeout with gnome portal
    systemd.user.services.xdg-desktop-portal = {
      overrideStrategy = "asDropin";
      serviceConfig = {
        TimeoutSec = 900;
      };
    };
    # Enable xWayland by default if Wayland is enabled
    programs.xwayland.enable = true;
    environment.variables = {
      # Enable Wayland support in Firefox
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
