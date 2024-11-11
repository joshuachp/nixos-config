{
  self,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  cfg = config.nixosConfig.desktop.sway;
  enable = config.systemConfig.desktop.enable && cfg.enable;
in
{
  options = {
    nixosConfig.desktop.sway = {
      enable = mkEnableOption "Sway window manager";
      nvidia = mkEnableOption "Nvidia with Sway";
    };
  };
  config = lib.mkIf enable {
    assertions = [
      {
        assertion = config.systemConfig.desktop.enable;
        message = "Enable the desktop environment with systemConfig.desktop.enable = true`";
      }
      {
        assertion = config.systemConfig.desktop.wayland;
        message = "Enable `wayland` with systemConfig.desktop.wayland = true`";
      }
    ];
    programs.sway = {
      enable = true;
      # Required environment variables for GTK applications
      wrapperFeatures.gtk = true;
      extraPackages = import "${self}/pkgs/wm/sway.nix" pkgs;
      extraOptions = lib.mkIf cfg.nvidia [ "--unsupported-gpu" ];
    };

    # XDG desktop portal compatibility with `wlroots`
    xdg.portal = {
      wlr.enable = true;
      # NOTE: I believe this is needed if gnome is not present, but otherwise it will generate an
      #       error for a collision
      # extraPortals = with pkgs; [
      #   xdg-desktop-portal-gtk
      # ];
      config.sway = {
        "org.freedesktop.impl.portal.GlobalShortcuts" = "none";
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };
}
