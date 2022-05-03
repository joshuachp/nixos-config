{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ghc
    cabal-install
    stack
    haskell-language-server
  ];
}
