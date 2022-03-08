{ config, pkgs, lib, ... }: {

  imports = [
    ./c_cpp.nix
    ./go.nix
    ./javascript.nix
    ./lua.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
  ];

  environment.systemPackages = with pkgs; [
    # Tools
    git
    gnumake
    sqlite
  ];
}
