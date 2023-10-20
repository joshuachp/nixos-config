# Go development config
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
    environment.systemPackages = with pkgs; [
      go
      gopls
    ];
  };
}
