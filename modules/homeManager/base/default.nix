{ config, lib, ... }:
{
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

    home.shellAliases = {
      q = "exit";
    };

    # Editor
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
      };
      bash.enable = true;
      fish = {
        enable = true;

        interactiveShellInit = lib.mkDefault ''
          fish_vi_key_bindings

          function fish_greeting
            uptime
            free -h
          end
        '';

      };
    };
  };
}
