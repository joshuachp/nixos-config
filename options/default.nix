{ lib
, ...
}:
{
  options = {
    systemConfig.version = lib.options.mkOption {
      default = "22.11";
      description = "The current version of the system";
      type = lib.types.str;
    };
    systemConfig.homeManager.enabled = lib.options.mkOption {
      default = false;
      defaultText = "Flag for home-manager integration";
      description = "Whether to signal wheter home-manager is enabled for the environment";
      type = lib.types.bool;
    };
    systemOption.desktopEnabled = lib.options.mkOption {
      default = false;
      defaultText = "Defaults to CLI system";
      description = "Whether to enable the desktop environment";
      type = lib.types.bool;
    };
  };
}
