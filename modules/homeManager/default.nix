# Home-Manager config
{ config
, pkgs
, ...
}: {
  imports = [
    ./desktop
    ./gpg.nix
    ./nvim.nix
    ./syncthing.nix
  ];
  config = {
    nix.package = pkgs.nix;
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
  };
}
