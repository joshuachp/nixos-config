{ pkgs
, lib
, system
, nil
, nixgl
, config
, ...
}: {
  imports = [
    ../../modules/common/nix
    ../../modules/home-manager/gpg.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/syncthing.nix
  ];
  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "joshuachp";
    home.homeDirectory = "/home/joshuachp";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Options
    systemConfig.desktop.enable = lib.mkForce true;

    nixpkgs.overlays = [
      nixgl.overlay

      (self: super:
        let
          wrapIntel = import ../../lib/wrapGLIntel.nix super;
        in
        {
          alacritty = wrapIntel "alacritty" "${super.alacritty}/bin/alacritty";
          vscode = wrapIntel "code" "${super.alacritty}/bin/code";
          libreoffice = wrapIntel "libreoffice" "${super.libreoffice}/bin/libreoffice";
          tdesktop = wrapIntel "telegram-desktop" "${super.tdesktop}/bin/telegram-desktop";
        })
    ];

    home.packages = with pkgs; [
      tmux

      polybarFull
      xss-lock
      mpdris2
      rofi

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
    ++ import ../../pkgs/desktop.nix { inherit pkgs lib config; }
    ;
  };
}
