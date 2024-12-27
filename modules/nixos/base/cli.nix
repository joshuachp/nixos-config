{ self, pkgs, ... }:
{
  config = {
    environment.systemPackages = import "${self}/pkgs/cli-minimal.nix" pkgs;

    programs = {
      tmux.enable = true;
      less.enable = true;
    };
  };
}
