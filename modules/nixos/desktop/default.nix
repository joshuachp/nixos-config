{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./qt.nix
    ./services.nix
    ./wayland.nix
    ./wm/gnome.nix
    ./wm/i3.nix
    ./wm/sway.nix
  ];
  config = {
    # Desktop service
    services.xserver = {
      enable = true;
      # Configure keymap in X11
      layout = "it";
      xkbOptions = "eurosign:e";
      xkbVariant = "basic";
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
