# Atuin config
{ config, lib, ... }:
let
  inherit (config.systemConfig) minimal;
in
{
  config = lib.mkIf (!minimal) {
    privateConfig.atuin.key = true;
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        sync_address = "https://atuin.k.joshuachp.dev";
      };
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
