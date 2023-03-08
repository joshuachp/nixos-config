{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    gcc
    bintools

    clang
    clang-analyzer
    clang-tools
    lld

    cmake
    ninja
  ]);
}
