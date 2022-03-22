{
  config,
  pkgs,
  lib,
  neovim-nightly-overlay,
  ...
}: {
  imports = [./gnupg.nix];

  nixpkgs.overlays = [neovim-nightly-overlay.overlay];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    gnupg
    pinentry
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
    neovim-nightly

    # Desktop
    feh
    polybar
    rofi
  ];

  # Programs
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    less.enable = true;
    neovim.enable = true;
    git.enable = true;
    tmux.enable = true;
  };

  # Lorri
  services.lorri.enable = true;
}
