{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      ghc
      stack
      cabal-install
      haskell-language-server
    ];
  };
}
