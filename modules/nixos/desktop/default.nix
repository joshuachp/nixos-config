{ self
, config
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
    ./browser.nix
    ./fonts.nix
    ./keyboard.nix
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

    environment.systemPackages = import "${self}/pkgs/desktop.nix" { inherit pkgs lib config; };
  };
}
