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
      systemd.user.services.syncthingtray = {
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Unit = {
          After = lib.mkForce "graphical-session.target";
          Requires = lib.mkForce "";
        };
      };
    })
  ];
}
