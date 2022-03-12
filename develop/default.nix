{ config, pkgs, lib, ... }: {

  imports = [
    ./c_cpp.nix
    ./go.nix
    ./javascript.nix
    ./lua.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./tex.nix
  ];

  environment.systemPackages = with pkgs; [
    # Git
    git
    pre-commit

    # Tools
    entr
    gnumake
    hyperfine
    sqlite
  ];
}
