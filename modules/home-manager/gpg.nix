# Configure GPG and the GPG agent to use with home-manager
{ config
, pkgs
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
      scdaemonSettings = {
        # Use the pcsc instead of the integrated ccid
        # https://wiki.archlinux.org/title/GnuPG#GnuPG_with_pcscd_(PCSC_Lite)
        disable-ccid = true;
        pcsc-driver = "${pkgs.pcsclite.out}/lib/libpcsclite.so";
        card-timeout = "5";
        pcsc-shared = true;
        # with pcsc-shared the pin is asked every time, this fixes it
        # https://dev.gnupg.org/T5436
        disable-application = "piv";
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
