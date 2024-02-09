# Syncthing configuration
{ config
, lib
, ...
}:
let
  cfg = config.homeConfig.syncthing;
  desktop = cfg.enable && config.systemConfig.desktop.enable;
in
{
  options = {
    homeConfig.syncthing.enable = lib.mkEnableOption "Syncthing";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.syncthing.enable = true;
    })
    # Enable the tray icon only on desktops setups
    (lib.mkIf desktop {
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
