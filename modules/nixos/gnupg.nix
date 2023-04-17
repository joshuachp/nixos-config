{ config
, pkgs
, ...
}: {
  config = {
    programs = {
      # GPG
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        enableExtraSocket = true;
        pinentryFlavor = if config.systemConfig.desktopEnabled then "gnome3" else "curses";
      };
      ssh.startAgent = false;
    };

    services.dbus.packages = [ pkgs.gcr ];

    systemd.user.sockets.gpg-agent.listenStreams = [ "" "%t/gnupg/d.8jmbbcqh9gemi75at4554oo4/S.gpg-agent" ];
    systemd.user.sockets.gpg-agent-ssh.listenStreams = [ "" "%t/gnupg/d.8jmbbcqh9gemi75at4554oo4/S.gpg-agent.ssh" ];
    systemd.user.sockets.gpg-agent-extra.listenStreams = [ "" "%t/gnupg/d.8jmbbcqh9gemi75at4554oo4/S.gpg-agent.extra" ];

    hardware.gpgSmartcards.enable = true;

    environment.systemPackages = with pkgs; [
      gnupg
      pinentry
      pinentry.curses
      pinentry.tty
    ];
  };
}
