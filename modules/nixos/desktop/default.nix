{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.systemConfig.desktop;
in
{
  imports = [
    ./audio.nix
    ./fonts.nix
    ./qt.nix
    ./services.nix
    ./wayland.nix
    ./wm/gnome.nix
    ./wm/hyprland.nix
    ./wm/i3.nix
    ./wm/sway.nix
  ];
  config = lib.mkIf cfg.enable {
    # Desktop service
    services.xserver = {
      enable = true;
      xkb.layout = "us";
      # Enable touchpad support (enabled default in most desktopManager).
      libinput = {
        enable = true;
        touchpad = { tapping = true; };
      };
      # Desktop environment
      displayManager.gdm.enable = true;
    };

    environment.systemPackages = import ../../../pkgs/desktop.nix { inherit pkgs lib config; };
  };
}
