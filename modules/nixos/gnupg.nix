# Configure gpg with pcscd and udev rules
{ pkgs
, ...
}: {
  config = {
    # Gnome key-chain
    services.dbus.packages = [ pkgs.gcr ];
    # Enable udev rules
    hardware.gpgSmartcards.enable = true;
    # Packages for the cli
    environment.systemPackages = with pkgs; [
      gnupg
      pinentry
      pinentry.curses
      pinentry.tty
    ];
    # Enable the pcscd daemon to be used instead of the integrated gnupg ccid, or if the ccid fails.
    services.pcscd.enable = true;
  };
}
