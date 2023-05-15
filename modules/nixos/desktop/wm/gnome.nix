{ pkgs
, ...
}: {
  config = {
    services.xserver.desktopManager.gnome.enable = true;

    # List services that you want to enable:
    services = {
      gnome = {
        gnome-keyring.enable = true;
        evolution-data-server.enable = true;
        gnome-online-accounts.enable = true;
        gnome-remote-desktop.enable = true;
      };

      # Udev
      udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    };

    environment.gnome.excludePackages = with pkgs; [ epiphany ];

    environment.systemPackages = with pkgs; [
      gnome-podcasts
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnomeExtensions.appindicator
      gnome.gnome-sound-recorder
      papirus-icon-theme
    ];
  };
}
