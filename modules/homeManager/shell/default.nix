# Shell configuration
{ lib
, config
, ...
}:
let
  inherit (config.systemConfig) minimal;
in
{
  imports = [
    ./aliases.nix
    ./fish
    ./environment.nix
  ];
  config = {
    programs = {
      bash.enable = true;
      zsh.enable = true;
      # Starship prompt
      starship = lib.mkIf (!minimal) {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        settings = lib.importTOML ./config/starship.toml;
      };
      atuin = lib.mkIf (!minimal) {
        enable = true;
        flags = [
          "--disable-up-arrow"
        ];
        settings = {
          sync_address = "https://atuin.k.joshuachp.dev";
        };
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
