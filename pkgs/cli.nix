{ pkgs
, jump
, note
, tools
, system
}: with pkgs; [
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
]
