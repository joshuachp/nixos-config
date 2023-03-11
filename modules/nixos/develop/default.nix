{ config
, pkgs
, lib
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
  config = {
    environment.systemPackages = import ../../../pkgs/develop { inherit pkgs; };
  };
}
