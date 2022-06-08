{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ghc
    cabal-install
    haskell-language-server
  ];
}
