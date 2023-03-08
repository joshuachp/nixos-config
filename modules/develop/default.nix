{ config
, pkgs
, lib
, installPkgs
, ...
}: {
  imports = [
    ./c_cpp.nix
    ./elixir.nix
    ./go.nix
    ./haskell.nix
    ./javascript.nix
    ./lua.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./sh.nix
    ./tex.nix
  ];
  config = installPkgs (with pkgs; [
    # Git
    git
    git-extras
    pre-commit

    # Code
    delta
    difftastic
    jq

    # Make
    entr
    gnumake

    # Other
    sqlite-interactive
    vale

    # Perf
    hyperfine

    # Debug
    gdb
    lldb

    # Various
    nodePackages.vim-language-server
    tree-sitter
  ]);
}
