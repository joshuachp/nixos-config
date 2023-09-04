# Hyprland dynamic tiling window manager
{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib.options) mkEnableOption;
in
{
  options = {
    nixosConfig.desktop.hyprland.enable = mkEnableOption "Hyperland window manager";
    nixosConfig.desktop.hyprland.nvidia = mkEnableOption "Hyperland nvidia patched";
  };
  config =
    let
      cfg = config.nixosConfig.desktop.hyprland;
    in
    lib.mkIf cfg.enable {
      programs.hyprland = {
        enable = true;
        enableNvidiaPatches = cfg.nvidia;
      };
      environment.systemPackages = with pkgs; [
        # Notification daemon
        mako
        # Bar
        waybar
        # Application runner
        wofi
        # Background
        swaybg
        swaylock
      ];
    };
}
