{ pkgs
, ...
}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./qt.nix
    ./services.nix
    ./window_manager/gnome.nix
    ./window_manager/i3.nix
  ];

  config = {
    # Xorg
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


    environment.systemPackages = with pkgs; [
      # Terminal
      alacritty

      # Editor
      vscode
      godot

      # Browser
      firefox
      chromium
      brave

      # Apps
      element-desktop
      libreoffice
      signal-desktop
      spotify
      tdesktop
      thunderbird
      vlc
      xournalpp
      zathura

      # Other
      pinentry-gnome
      yubikey-touch-detector

      # Tools
      gnuplot
      xclip
      wl-clipboard

      mattermost-desktop
    ] ++ import ../../../pkgs/desktop.nix pkgs;
  };
}
