# Shell configuration
{ lib, config, ... }:
let
  inherit (config.systemConfig) minimal;
in
{
  imports = [
    ./aliases.nix
    ./atuin.nix
    ./environment.nix
    ./fish
    ./nushell
    ./zellij
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
        enableNushellIntegration = true;
        enableZshIntegration = true;
        settings = lib.importTOML ./config/starship.toml;
      };
    };
  };
}
