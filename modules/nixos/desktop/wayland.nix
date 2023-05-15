{ config, lib, ... }: {
  config =
    let
      inherit (config.systemConfig.desktop) wayland;
    in
    lib.mkIf wayland {
      # Wayland
      xdg.portal.enable = true;
      # Enable xWayland by default if Wayland is enabled
      programs.xwayland.enable = true;
      environment.variables = {
        # Enable Wayland support in Firefox
        MOZ_ENABLE_WAYLAND = "1";
      };
    };
}
