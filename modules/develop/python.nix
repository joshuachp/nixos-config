{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    python3Full
    nodePackages.pyright
  ]);
}
