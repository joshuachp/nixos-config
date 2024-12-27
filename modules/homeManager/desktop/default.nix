# Home-Manager desktop configuration
{ hostname, ... }:
{
  imports = [
    ./alacritty.nix
    ./develop
    ./shell
    ./gpg.nix
    ./gnome.nix
    ./qt.nix
    ./syncthing.nix
    ./wm
  ];

  config = {

    programs.direnv.config = {
      enable = true;
      global = {
        warn_timeout = 0;
      };
    };

    privateConfig.u2f.enable = hostname;

    privateConfig = {
      syncthing.enable = true;
      kubeConfig = true;
    };
  };
}
