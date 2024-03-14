{ lib
, config
, ...
}:
{
  config =
    let
      inherit (config.systemConfig) minimal;
    in
    lib.mkIf (!minimal) {
      programs.zellij = {
        enable = true;
      };
      xdg.configFile."zellij/config.kdl" = {
        enable = true;
        source = ./config.kdl;
      };
    };
}
