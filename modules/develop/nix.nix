{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      # Formatters
      nixfmt
      nixpkgs-fmt
      alejandra
      # Language servers
      rnix-lsp
      nil
      # Linters
      statix
    ];
  };
}
