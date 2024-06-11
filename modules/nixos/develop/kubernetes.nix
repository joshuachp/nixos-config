# Enables k8s tools
{
  self,
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    nixosConfig.develop.k8s = lib.mkEnableOption "kubernetes tools";
  };
  config =
    let
      cfg = config.nixosConfig.develop;
      sysCfg = config.systemConfig.develop;
    in
    lib.mkIf (sysCfg.enable && cfg.k8s) {
      environment.systemPackages = import "${self}/pkgs/develop/kubernetes.nix" pkgs;
    };
}
