# Development config
{
  self,
  config,
  pkgs,
  lib,
  ...
}:
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
  config = lib.mkIf config.systemConfig.develop.enable {
    environment.systemPackages = import "${self}/pkgs/develop" { inherit pkgs; };

    # Enable direnv
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
