{ config
, ...
}: {
  config = {
    programs.ccache = {
      enable = true;
      packageNames = [ "neovim-unwrapped" ];
    };
    nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
  };
}
