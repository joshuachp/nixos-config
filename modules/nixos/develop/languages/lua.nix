# Lua develop config
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.systemConfig.develop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      stylua
      sumneko-lua-language-server
    ];
  };
}
