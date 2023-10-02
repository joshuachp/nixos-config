# Rust develop config
{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.nixosConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import ../../../../pkgs/develop/rust.nix { inherit pkgs; };
  };
}
