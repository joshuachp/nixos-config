{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./c_cpp.nix
    ./go.nix
    ./javascript.nix
    ./lua.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./sh.nix
    ./tex.nix
  ];

  environment.systemPackages = with pkgs; [
    # Git
    git
    git-extras
    pre-commit

    # Tools
    entr
    gnumake
    hyperfine
    jq
    sqlite
    vale

    # Various
    nodePackages.vim-language-server
  ];
}
