{ config
, lib
, pkgs
, ...
}:
{
  config =
    let
      desktop = config.systemConfig.desktop.enable;
    in
    lib.mkMerge [
      {
        security = {
          # Sudo impl
          sudo.enable = false;
          sudo-rs.enable = true;
        };
      }
      (lib.mkIf desktop {
        security = {
          tpm2.enable = true;
          # Sudo U2F
          pam.u2f = {
            enable = true;
            control = "sufficient";
            cue = true;
          };
        };

        # Yubikey
        udev.packages = [ pkgs.yubikey-personalization ];
      })
    ];
}
