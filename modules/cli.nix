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
    environment.systemPackages = with pkgs; [
      # System utils
      pciutils

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
    ];

    # Programs
    programs = {
      zsh = {
        enable = true;

        enableGlobalCompInit = false;
        histFile = "$HOME/.cache/zsh/zsh_history";

        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };
      less.enable = true;
      git.enable = true;
      tmux.enable = true;
    };


    # Lorri
    # services.lorri.enable = true;
  };
}
