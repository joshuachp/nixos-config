# Nixos in WSL
{ pkgs
, ...
}: {
  imports = [ ];
  config = {
    nixosConfig.networking.resolved = false;
    wsl = {
      enable = true;
      defaultUser = "joshuachp";
      startMenuLaunchers = true;

      interop = {
        includePath = false;
      };

      wslConf = {
        interop.enabled = false;
        automount.root = "/mnt";
      };
    };

    environment.systemPackages = with pkgs; [
      pinentry-curses
    ];

    security.sudo.wheelNeedsPassword = false;
  };
}
