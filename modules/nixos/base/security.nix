{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    security = {
      # Sudo impl
      sudo.enable = false;
      sudo-rs.enable = true;

      tpm2.enable = lib.mkDefault config.systemConfig.desktop.enable;
    };
  };
}
