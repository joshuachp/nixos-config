# Go development config
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.systemConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      go
      gopls
    ];
  };
}
