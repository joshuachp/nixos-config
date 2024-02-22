# Rust develop config
{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.systemConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import ../../../../pkgs/develop/rust.nix { inherit pkgs; };
  };
}
