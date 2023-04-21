{ pkgs
, lib
, system
, nil
, nixgl
, ...
}: {
  imports = [
    ../../modules/common/nix
    ../../modules/home-manager/syncthing.nix
  ];
  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "joshuachp";
    home.homeDirectory = "/home/joshuachp";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Options
    systemConfig.desktopEnabled = lib.mkForce true;

    nixpkgs.overlays = [ nixgl.overlay ];

    home.packages = with pkgs; [
      tmux

      polybarFull
      xss-lock
      mpdris2
      rofi
      spotify

      ccache
      bmap-tools

      pkgs.nixgl.nixGLIntel
      pkgs.nixgl.nixVulkanIntel
    ]
    ++ import ../../pkgs/cli.nix pkgs
    ++ import ../../pkgs/nixpkgs.nix { inherit pkgs; }
    # Develop
    ++ import ../../pkgs/develop { inherit pkgs; }
    ++ import ../../pkgs/develop/nix.nix {
      inherit pkgs; nil = nil.packages.${system}.default;
    }
    ++ import ../../pkgs/develop/rust.nix {
      inherit pkgs;
    }
    ++ import ../../pkgs/develop/javascript.nix { inherit pkgs; }
    ++ import ../../pkgs/develop/python.nix { inherit pkgs; }
    ++ import ../../pkgs/develop/haskell.nix { inherit pkgs; }
    ++ import ../../pkgs/develop/c_cpp.nix { inherit pkgs; }
    ++ import ../../pkgs/develop/shell.nix pkgs
    ++ import ../../pkgs/develop/elixir.nix pkgs
    ++ import ../../pkgs/desktop.nix pkgs
    ;
  };
}
