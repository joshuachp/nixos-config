# Nix development
{ config
, lib
, pkgs
, nil
, system
, ...
}:
let
  cfg = config.nixosConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import ../../../../pkgs/develop/nix.nix {
      inherit pkgs;
      nil = nil.packages.${system}.default;
    };
  };
}
