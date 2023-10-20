# Nix development
{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.nixosConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import ../../../../pkgs/develop/nix.nix pkgs;
  };
}
