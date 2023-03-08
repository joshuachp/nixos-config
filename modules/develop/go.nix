{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    go
    gopls
  ]);
}
