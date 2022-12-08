{ config
, pkgs
, neovim-nightly-overlay
, system
, jump
, note
, tools
, ...
}: {
  imports = [ ./gnupg.nix ];
  config = {
    nixpkgs.overlays = [
      neovim-nightly-overlay.overlay
    ];
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

      # Editor
      (neovim.overrideAttrs (oas: {
        wrapRc = false;
      }))

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
      neovim.enable = true;
      git.enable = true;
      tmux.enable = true;
    };

    # Environment variables, useful for the root user
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Lorri
    services.lorri.enable = true;
  };
}
