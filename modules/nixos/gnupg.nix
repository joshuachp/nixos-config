# Configure gpg with pcscd and udev rules
{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktop = config.systemConfig.desktop.enable;
  gnome = config.systemConfig.desktop.gnome.enable;
in
{
  config = lib.mkMerge [
    {
      # Enable udev rules
      # hardware.gpgSmartcards.enable = true;
      # Packages for the cli
      environment.systemPackages = with pkgs; [
        gnupg
        pinentry
        pinentry.curses
        pinentry.tty
      ];
    }
    (lib.mkIf desktop {
      # Gnome key-chain
      services.dbus.packages = lib.mkIf gnome [ pkgs.gcr ];
      # Enable the pcscd daemon to be used instead of the integrated gnupg ccid, or if the ccid
      # fails.
      services.pcscd.enable = true;
    })
  ];
}
