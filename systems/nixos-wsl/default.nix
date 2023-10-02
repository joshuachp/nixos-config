{ pkgs
, nixos-wsl
, lib
, ...
}: {
  imports = [
    # Wsl configuration
    nixos-wsl.nixosModules.wsl
  ];
  config = {
    nixosConfig.networking.enable = false;
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
