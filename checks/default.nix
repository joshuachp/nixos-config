# Checks to run on `nix flake check`
pkgs: { main = pkgs.callPackage ./main.nix { }; }
