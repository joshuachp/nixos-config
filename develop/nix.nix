{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    nixfmt
    nixpkgs-fmt

    rnix-lsp

    statix
  ];

}
