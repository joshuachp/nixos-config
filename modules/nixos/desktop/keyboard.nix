{ config
, lib
, pkgs
, ...
}:
let
  sysCfg = config.systemConfig.desktop;
in
{
  options = {
    nixosConfig.desktop.zsa = lib.mkEnableOption "ZSA keyboard tools" // {
      default = true;
    };
  };
  config =
    let
      cfg = config.nixosConfig.desktop;
    in
    lib.mkIf (cfg.zsa && sysCfg.enable) {
      hardware.keyboard.zsa.enable = true;
      environment.systemPackages = with pkgs;[
        wally-cli
      ];
    };
}
