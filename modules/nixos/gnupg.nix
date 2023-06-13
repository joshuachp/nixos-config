{ pkgs
, ...
}: {
  config = {
    services.dbus.packages = [ pkgs.gcr ];
    hardware.gpgSmartcards.enable = true;
    environment.systemPackages = with pkgs; [
      gnupg
      pinentry
      pinentry.curses
      pinentry.tty
    ];
  };
}
