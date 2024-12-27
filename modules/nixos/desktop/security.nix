{ pkgs, ... }:
{
  config = {
    # Sudo U2F
    security.pam.u2f = {
      enable = true;
      control = "sufficient";
      settings.cue = true;
    };

    # Yubikey
    services.udev.packages = [ pkgs.yubikey-personalization ];
  };
}
