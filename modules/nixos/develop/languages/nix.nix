# Nix development
{ self
, config
, lib
, pkgs
, ...
}:
let
  cfg = config.systemConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import "${self}/pkgs/develop/nix.nix" pkgs;
  };
}
