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
    nixosConfig.develop.k8s = lib.mkEnableOption "kubernetes tools" // {
      default = true;
    };
  };
  config =
    let
      cfg = config.nixosConfig.develop;
    in
    lib.mkIf (cfg.enable && cfg.k8s) {
      environment.systemPackages = import "${self}/pkgs/develop/kubernetes.nix" pkgs;
    };
}
