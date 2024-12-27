# Browser configuration
{
  pkgs,
  ...
}:
{
  config = {
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
