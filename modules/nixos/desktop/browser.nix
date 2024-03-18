# Browser configuration
{ config
, lib
, pkgs
, ...
}:
{
  config = lib.mkIf config.systemConfig.desktop.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      languagePacks = [
        "en-US"
        "it"
      ];
    };
  };
}
