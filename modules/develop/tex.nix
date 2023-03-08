{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    texlive.combined.scheme-small
    texlab
  ]);
}
