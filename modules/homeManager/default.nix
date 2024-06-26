# Home-Manager config
{ config, ... }:
{
  imports = [
    ./desktop
    ./develop
    ./gpg.nix
    ./nvim.nix
    ./shell
    ./syncthing.nix
  ];
  config = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = config.systemConfig.version;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Enable linux specific settings for home-manager
    targets.genericLinux.enable = true;
    xdg.enable = true;
  };
}
