{ config, lib, ... }:
{
  config =
    let
      cfg = config.systemConfig.desktop;
    in
    lib.mkMerge [
      {
        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";
        console = {
          keyMap = lib.mkDefault "us";
          useXkbConfig = true; # use xkb.options in tty.
        };
      }
      (lib.mkIf cfg.enable {
        # Enable ibus for accented letters
        i18n.inputMethod.enabled = "ibus";
      })
    ];
}
