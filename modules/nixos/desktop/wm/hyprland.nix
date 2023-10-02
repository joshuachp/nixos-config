# Hyprland dynamic tiling window manager
{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib.options) mkEnableOption;
  cfg = config.nixosConfig.desktop.hyprland;
  enable = config.systemConfig.desktop.enable && cfg.enable;
in
{
  options = {
    nixosConfig.desktop.hyprland.enable = mkEnableOption "Hyperland window manager";
    nixosConfig.desktop.hyprland.nvidia = mkEnableOption "Hyperland nvidia patched";
  };
  config = lib.mkIf enable {
    programs.hyprland = {
      enable = true;
      enableNvidiaPatches = cfg.nvidia;
    };
    programs.light.enable = true;
    # Sway-lock
    security.pam.services.swaylock.text = ''
      # PAM configuration file for the swaylock screen locker. By default, it includes
      # the 'login' configuration file (see /etc/pam.d/login)
      auth include login
    '';
    environment.systemPackages = with pkgs; [
      # Notification daemon
      mako
      # Bar
      waybar
      # Application runner
      wofi
      # Music
      mpdris2
      # Background
      swaybg
      swaylock
      swayidle
      # Screenshot
      grim
      slurp
    ];
  };
}
