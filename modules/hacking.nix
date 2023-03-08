{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    cutter
    radare2
  ]);
}
