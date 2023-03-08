{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    ghc
    stack
    cabal-install
    haskell-language-server
  ]);
}
