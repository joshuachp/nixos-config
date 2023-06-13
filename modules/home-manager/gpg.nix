# Configure GPG and the GPG agent to use with home-manager
{ config
, ...
}: {
  config = {
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.configHome}/gnupg";
      settings = {
        keyserver = "hkps://keys.openpgp.org";
        use-agent = true;
      };
    };
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = true;
      defaultCacheTtl = 3600;
      maxCacheTtl = 60480000;
      defaultCacheTtlSsh = 3600;
      maxCacheTtlSsh = 60480000;
      pinentryFlavor =
        if config.systemConfig.desktop.enable then
          if config.systemConfig.desktop.gnome.enable then
            "gnome3"
          else
            "qt"
        else
          "curses";
    };
  };
}
