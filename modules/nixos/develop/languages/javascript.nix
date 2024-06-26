# Javascript config
{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.systemConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import "${self}/pkgs/develop/javascript.nix" { inherit pkgs; };
  };
}
