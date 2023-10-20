# Lua develop config
{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.nixosConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      stylua
      sumneko-lua-language-server
    ];
  };
}
