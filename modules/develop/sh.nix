{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    nodePackages.bash-language-server
    shfmt
    shellcheck
  ]);
}
