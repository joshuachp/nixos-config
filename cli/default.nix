{ config, pkgs, lib, ... }: {
  imports = [
    ./gnupg.nix
    ./rclone.nix
  ];

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

    # Utils
    curl
    wget
    fzf
    gnupg
    pinentry
    rclone
    gopass

    # Network utils
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
    neovim

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
}
