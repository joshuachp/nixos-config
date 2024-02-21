# Javascript config
{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.systemConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import ../../../../pkgs/develop/javascript.nix { inherit pkgs; };
  };
}
