# Configure gpg with pcscd and udev rules
{
  config,
  lib,
  pkgs,
  ...
}:
let
  gnome = config.systemConfig.desktop.gnome.enable;
in
{
  config = {
    # Enable udev rules
    # hardware.gpgSmartcards.enable = true;
    # Packages for the cli
    environment.systemPackages = with pkgs; [
      gnupg
      pinentry
      pinentry.curses
      pinentry.tty
    ];
    # Gnome key-chain
    services.dbus.packages = lib.optionals gnome [ pkgs.gcr ];
    # Enable the pcscd daemon to be used instead of the integrated gnupg ccid, or if the ccid
    # fails.
    services.pcscd.enable = true;
  };
}
