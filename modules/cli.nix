{ config
, pkgs
, system
, jump
, note
, tools
, installPkgs
, ...
}: {
  imports = [ ./gnupg.nix ];
  config = {
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
  } // installPkgs (with pkgs; [
    # System utils
    pciutils
    inotify-tools

    # Configuration
    chezmoi

    # Shells
    fish
    nushell
    direnv

    # Files
    fzf
    rclone
    file

    # Document
    pandoc

    # Security
    gopass

    # Network utils
    curl
    wget
    iproute2
    socat

    # Rust CLI programs
    bat
    exa
    fd
    ripgrep

    # Checkers
    shellcheck

    # Terminal
    starship

    # Personal
    jump.packages.${system}.default
    note.packages.${system}.default
    tools.packages.${system}.rust-tools
    tools.packages.${system}.shell-tools
  ]);
}
