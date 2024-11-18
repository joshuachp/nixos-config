{ config, lib, ... }:
{
  options = {
    systemConfig = {
      version = lib.options.mkOption {
        default = "24.11";
        description = "The current version of the system";
        type = lib.types.str;
      };
      develop.enable = lib.mkEnableOption "develop environment";
      minimal = lib.mkEnableOption "minimal system for cloud deployment";
      homeManager.enable = lib.options.mkOption {
        default = false;
        defaultText = "Flag for home-manager integration";
        description = "Whether to signal whether home-manager is enabled for the environment";
        type = lib.types.bool;
      };
      desktop = {
        enable = lib.options.mkOption {
          default = false;
          defaultText = "Defaults to CLI system";
          description = "Whether to enable the desktop environment";
          type = lib.types.bool;
        };
        hidpi = lib.mkEnableOption "HIDPI desktop configuration";
        wayland = lib.options.mkOption {
          default = true;
          defaultText = "Enable wayland backend";
          description = "Whether to enable the wayland desktop environment and packages";
          type = lib.types.bool;
        };
        gnome.enable = lib.options.mkOption {
          default = true;
          defaultText = "Enable gnome desktop environment";
          description = "Whether to enable the gnome desktop environment and its packages";
          type = lib.types.bool;
        };
      };
    };
  };
  config =
    let
      cfg = config.systemConfig;
    in
    {
      assertions = [
        {
          assertion = !(cfg.develop.enable && cfg.minimal);
          message = "Development environment cannot be minimal";
        }
      ];
    };
}
