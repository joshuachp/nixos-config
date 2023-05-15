{ lib
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
      homeManager.enable = lib.options.mkOption {
        default = false;
        defaultText = "Flag for home-manager integration";
        description = "Whether to signal wheter home-manager is enabled for the environment";
        type = lib.types.bool;
      };
      desktop.enable = lib.options.mkOption {
        default = false;
        defaultText = "Defaults to CLI system";
        description = "Whether to enable the desktop environment";
        type = lib.types.bool;
      };
      desktop.wayland = lib.options.mkOption {
        default = false;
        defaultText = "Enable wayland backend";
        description = "Whether to enable the wayland desktop environment and packages";
        type = lib.types.bool;
      };
    };
  };
}
