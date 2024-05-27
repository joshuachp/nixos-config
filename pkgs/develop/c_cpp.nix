{ pkgs }:
with pkgs;
[
  clang
  clang-analyzer
  clang-tools

  lld
  mold

  cmake
  ninja

  ncurses
]
