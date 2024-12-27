{ config, lib, ... }:
{
  config =
    let
      cfg = config.systemConfig.desktop;
    in
    lib.mkMerge [
      {
        # Select internationalisation properties.
        i18n = {
          defaultLocale = "en_US.UTF-8";
          supportedLocales = [
            "en_US.UTF-8/UTF-8"
            "en_DK.UTF-8/UTF-8"
            "it_IT.UTF-8/UTF-8"
          ];
          extraLocaleSettings = {
            LC_TIME = "en_DK.UTF-8";
            LC_MONETARY = "it_IT.UTF-8";
            LC_PAPER = "it_IT.UTF-8";
            LC_TELEPHONE = "it_IT.UTF-8";
            LC_MEASUREMENT = "it_IT.UTF-8";
          };
        };
        console = {
          keyMap = lib.mkDefault "us";
          useXkbConfig = true; # use xkb.options in tty.
        };
      }
      (lib.mkIf cfg.enable {
        # Enable ibus for accented letters
        i18n.inputMethod = {
          enable = true;
          type = "ibus";
        };
      })
    ];
}
