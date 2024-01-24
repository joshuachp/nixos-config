# Development config
{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.nixosConfig.develop;
in
{
  imports = [
    ./kubernetes.nix
    ./languages/c_cpp.nix
    ./languages/elixir.nix
    ./languages/go.nix
    ./languages/haskell.nix
    ./languages/javascript.nix
    ./languages/lua.nix
    ./languages/nix.nix
    ./languages/python.nix
    ./languages/rust.nix
    ./languages/sh.nix
    ./languages/tex.nix
  ];
  options = {
    nixosConfig.develop.enable = lib.mkEnableOption "develop environment";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import ../../../pkgs/develop { inherit pkgs; };

    # Enable direnv
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
