# Cli packages
{ config
, lib
, pkgs
, ...
}:
let
  inherit (config.systemConfig) minimal;
in
{
  config = {
    environment. systemPackages =
      (import ../../pkgs/cli-minimal.nix pkgs)
      ++ (lib.optionals (!minimal) (import ../../pkgs/cli.nix pkgs))
    ;
    # Programs
    programs = {
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
      less.enable = true;
      git.enable = true;
      tmux.enable = true;
    };
  };
}
