{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./fonts.nix ./services.nix];

  # Xorg
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "it";
    xkbOptions = "eurosign:e";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
      touchpad = {tapping = true;};
    };
    # Desktop environment
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    windowManager.i3.enable = true;
  };

  # List services that you want to enable:
  services = {
    gnome = {
      gnome-keyring.enable = true;
      evolution-data-server.enable = true;
      gnome-online-accounts.enable = true;
    };

    # Udev
    udev.packages = with pkgs; [gnome3.gnome-settings-daemon];
  };

  environment.systemPackages = with pkgs; [
    # Terminal
    alacritty

    # Desktop
    feh
    polybar
    rofi

    # Editor
    vscode

    # Browser
    firefox
    chromium
    brave

    # Gnome
    gnome-podcasts
    gnome3.dconf-editor
    gnome3.gnome-tweaks
    gnomeExtensions.appindicator
    papirus-icon-theme

    # Apps
    element-desktop
    signal-desktop
    spotify
    tdesktop
    thunderbird
    zathura

    # Other
    pinentry-gnome
    yubikey-touch-detector

    # Tools
    gnuplot
  ];

  environment.gnome.excludePackages = with pkgs; [epiphany];
}
