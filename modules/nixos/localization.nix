{ lib
, ...
}: {
  config = {
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      keyMap = lib.mkDefault "us";
      useXkbConfig = true; # use xkb.options in tty.
    };
  };
}
