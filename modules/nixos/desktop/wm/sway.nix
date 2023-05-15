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
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
