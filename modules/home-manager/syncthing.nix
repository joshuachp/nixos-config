{ config
, lib
, ...
}: {
  config = lib.mkMerge [
    {
      services.syncthing. enable = true;
    }
    # Enable the tray icon only on desktops setups
    (lib.mkIf config.systemConfig.desktopEnabled {
      services.syncthing.tray.enable = true;
      # https://github.com/nix-community/home-manager/issues/2064
      systemd.user.targets.tray = lib.mkIf config.systemConfig.desktopEnabled {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session-pre.target" ];
        };
      };
    })
  ];
}
