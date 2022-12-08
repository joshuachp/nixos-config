{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      nixfmt
      nixpkgs-fmt
      alejandra

      rnix-lsp

      statix
    ];
  };
}
