# Latex develop config
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
    environment.systemPackages = with pkgs; [
      texlive.combined.scheme-small
      texlab
    ];
  };
}
