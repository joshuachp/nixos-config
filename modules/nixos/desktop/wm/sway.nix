{ config
, pkgs
, lib
, ...
}: {
  options = {
    nixosConfig.desktop.sway.enable = lib.options.mkOption {
      default = false;
      defaultText = "Enable sway as a window manager";
      description = "Flag to enable sway as a Wayland window manager";
      type = lib.types.bool;
    };
    nixosConfig.desktop.sway.nvidia = lib.options.mkOption {
      default = false;
      defaultText = "Launch sway with nvidia";
      description = "Flag to launch sway with the nvidia drivers enabled";
      type = lib.types.bool;
    };
  };
  config =
    let
      inherit (config.nixosConfig.desktop.sway) enable nvidia;
    in
    lib.mkIf enable {
      assertions = [
        {
          assertion = config.systemConfig.desktop.enable;
          message = "Enable the destkop environment with systemConfig.desktop.enable = true`";
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
        extraPackages = import ../../../../pkgs/wm/sway.nix pkgs;
        extraOptions = lib.mkIf nvidia [
          "--unsupported-gpu"
        ];
        extraSessionCommands = ''
          export WLR_DRM_NO_MODIFIERS=1
          export XDG_CURRENT_DESKTOP=sway
        '';
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
