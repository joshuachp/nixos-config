{
  description = "NerdFonts Symbols";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages = flake-utils.lib.flattenTree {
          nerd-font-symbols = import ./default.nix pkgs;
        };
        defaultPackage = self.packages.${system}.nerd-font-symbols;
      });
}
