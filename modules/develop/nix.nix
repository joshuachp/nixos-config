{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    # Formatters
    nixfmt
    nixpkgs-fmt
    alejandra
    # Language servers
    rnix-lsp
    nil
    # Linters
    statix
  ]);
}
