{ config
, pkgs
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
      };

      # Udev
      udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    };

    environment.gnome.excludePackages = with pkgs; [ epiphany ];

    environment.systemPackages = with pkgs; [
      gnome-podcasts
      gnome3.dconf-editor
      gnome3.gnome-tweaks
      gnomeExtensions.appindicator
      papirus-icon-theme
    ];
  };
}
