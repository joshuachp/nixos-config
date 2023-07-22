{ config
, lib
, ...
}: {
  config = lib.mkMerge [
    {
      services.syncthing. enable = true;
    }
    # Enable the tray icon only on desktops setups
    (lib.mkIf config.systemConfig.desktop.enable {
      services.syncthing.tray.enable = true;
      # https://github.com/nix-community/home-manager/issues/2064
      systemd.user.targets.tray = {
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Unit = {
          Description = "Home Manager System Tray";
          Before = "graphical-session.target";
          PartOf = [ "graphical-session.target" ];
        };
      };
    })
  ];
}
