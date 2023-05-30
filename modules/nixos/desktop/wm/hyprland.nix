# Hyprland dynamic tiling window manager
{ config
, lib
, pkgs
, ...
}: {
  options = {
    nixosConfig.desktop.hyprland.enable = lib.options.mkOption {
      default = false;
      defaultText = "Enable Hyprland as a window manager";
      description = "Flag to enable Hyprland as a Wayland dynamic tiling window manager";
      type = lib.types.bool;
    };
  };
  config =
    let
      cfg = config.nixosConfig.desktop.hyprland;
    in
    lib.mkIf cfg.enable {
      programs.hyprland = {
        enable = true;
        nvidiaPatches = true;
      };
      environment.systemPackages = with pkgs; [
        waybar
      ];
    };
}
