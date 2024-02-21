# C and Cpp config
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
    environment.systemPackages = import ../../../../pkgs/develop/c_cpp.nix { inherit pkgs; };
  };
}
