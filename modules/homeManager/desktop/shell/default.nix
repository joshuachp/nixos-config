{ lib, ... }:
{
  imports = [
    ./aliases.nix
    ./atuin.nix
    ./environment.nix
    ./nushell
    ./zellij
    ./fish
  ];
  config = {
    programs = {
      bash.enable = true;
      zsh.enable = true;
      # Starship prompt
      starship = {
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
