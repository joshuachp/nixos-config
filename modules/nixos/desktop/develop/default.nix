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
    ./docker.nix
    ./embedded.nix
    ./gnupg.nix
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
  config =
    let
      cfg = config.systemConfig.develop;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = import "${self}/pkgs/develop" { inherit pkgs; };

      programs.nix-ld.enable = true;

      # Enable direnv
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
