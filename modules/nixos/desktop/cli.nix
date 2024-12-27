# Cli packages
{
  self,
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = import "${self}/pkgs/cli.nix" pkgs;
    # Programs
    programs = {
      git.enable = true;
      zsh = {
        enable = true;

        enableGlobalCompInit = false;
        histFile = "$HOME/.cache/zsh/zsh_history";

        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        interactiveShellInit = ''
          source ${pkgs.fzf}/share/fzf/completion.zsh
          source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        '';
      };
    };
  };
}
