{ lib
, ...
}:
{
  options = {
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
