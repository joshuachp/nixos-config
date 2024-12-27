# Atuin config
_: {
  config = {
    privateConfig.atuin.key = true;
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        sync_address = "https://atuin.k.joshuachp.dev";
        style = "compact";
        sync = {
          records = true;
        };
      };
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
