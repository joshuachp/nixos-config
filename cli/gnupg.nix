{ config, pkgs, ... }: {
  programs = {
    # GPG
    ssh.startAgent = false;
    gnupg.agent = {
      enable = config.networking.hostName != "nixos-wsl";
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };
  };
}
