# Rust develop config
{ self
, config
, pkgs
, lib
, ...
}:
let
  cfg = config.systemConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import "${self}/pkgs/develop/rust.nix" { inherit pkgs; };
  };
}
