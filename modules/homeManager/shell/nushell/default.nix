{ config, lib, ... }:
{
  config = lib.mkIf (!config.systemConfig.minimal) {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
    };
  };
}
