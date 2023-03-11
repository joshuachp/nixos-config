{ pkgs, nil }: with pkgs; [
  # Formatters
  nixfmt
  nixpkgs-fmt
  alejandra
  # Language servers
  rnix-lsp
  # Linters
  statix

  nil
]
