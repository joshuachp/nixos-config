{ config
, lib
, ...
}:
{
  options = {
    systemConfig = {
      version = lib.options.mkOption {
        default = "23.05";
        description = "The current version of the system";
        type = lib.types.str;
      };
      minimal = lib.mkEnableOption "minimal system for cloud deployment";
      homeManager.enable = lib.options.mkOption {
        default = false;
        defaultText = "Flag for home-manager integration";
        description = "Whether to signal wheter home-manager is enabled for the environment";
        type = lib.types.bool;
      };
      desktop = {
        enable = lib.options.mkOption {
          default = false;
          defaultText = "Defaults to CLI system";
          description = "Whether to enable the desktop environment";
          type = lib.types.bool;
        };
        wayland = lib.options.mkOption {
          default = false;
          defaultText = "Enable wayland backend";
          description = "Whether to enable the wayland desktop environment and packages";
          type = lib.types.bool;
        };
        gnome.enable = lib.options.mkOption {
          default = false;
          defaultText = "Enable gnome desktop environment";
          description = "Whether to enable the gnome desktop environment and its packages";
          type = lib.types.bool;
        };
      };
    };
  };
  config = let cfg = config.systemConfig; in {
    assertions = [
      {
        assertion = !(cfg.desktop.wayland && cfg.desktop.gnome.enable) || cfg.desktop.enable;
        message = "Wayland and Gnome can only be enabled if the desktop environment is enabled";
      }
    ];
  };
}
