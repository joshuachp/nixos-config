{ config
, pkgs
, system
, note
, jump
, tools
, nil
, ...
}: {
  imports = [
    ../../modules/common/nix
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

    home.packages = with pkgs; [
      neovim
      tmux

      polybarFull
      xss-lock
      mpdris2
      rofi

      spotify
    ]
    ++ import ../../pkgs/cli.nix { inherit pkgs system note jump tools; }
    ++ import ../../pkgs/develop { inherit pkgs; }
    ++ import ../../pkgs/develop/nix.nix {
      inherit pkgs; nil = nil.packages.${system}.default;
    }
    ++ import ../../pkgs/develop/rust.nix {
      inherit pkgs;
    }
    ++ import ../../pkgs/develop/javascript.nix { inherit pkgs; }
    ++ import ../../pkgs/develop/python.nix { inherit pkgs; }
    ++ import ../../pkgs/nixpkgs.nix { inherit pkgs; }
    ;
  };
}
