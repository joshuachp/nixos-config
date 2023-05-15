{ config
, pkgs
, ...
}: {
  config = {
    assertions = [
      {
        assertion = config.systemConfig.desktop.wayland;
        message = "Enable `wayland` with systemConfig.desktop.wayland = true`";
      }
    ];
    programs.sway = {
      enable = true;
      # Required environment variables for GTK applications
      wrapperFeatures.gtk = true;
      extraPackages = import ../../../../pkgs/wm/sway.nix pkgs;
    };

    # XDG desktop portal compatibility with `wlroots`
    xdg.portal = {
      wlr.enable = true;
      # NOTE: I believe this is needed if gnome is not present, but otherwise it will generate an
      #       error for a collision
      # extraPortals = with pkgs; [
      #   xdg-desktop-portal-gtk
      # ];
    };
  };
}
