# Enables k8s tools
{ config
, lib
, pkgs
, ...
}:
{
  options = {
    nixosConfig.develop.k8s = lib.mkEnableOption "kubernetes tools";
  };
  config =
    let
      cfg = config.nixosConfig.develop;
    in
    lib.mkIf (cfg.enable && cfg.k8s) {
      environment.systemPackages = import ../../../pkgs/develop/kubernetes.nix pkgs;
    };
}