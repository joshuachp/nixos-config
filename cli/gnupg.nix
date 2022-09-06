{ config
, pkgs
, ...
}: {
  config = {
    programs = {
      # GPG
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "curses";
      };
    };

    environment.systemPackages = with pkgs; [
      gnupg
      pinentry
      pinentry-curses
    ];
  };
}
