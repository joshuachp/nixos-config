{ config
, pkgs
, system
, jump
, note
, tools
, ...
}: {
  imports = [ ./gnupg.nix ];
  config = {
    environment.systemPackages = import ../../pkgs/cli.nix {
      inherit pkgs jump note tools system;
    };
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
