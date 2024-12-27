_: {
  config = {
    programs.zellij = {
      enable = true;
    };
    xdg.configFile."zellij/config.kdl" = {
      enable = true;
      source = ./config.kdl;
    };
  };
}
