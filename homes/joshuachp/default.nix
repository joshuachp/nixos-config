{ self
, pkgs
, lib
, system
, nil
, nixgl
, config
, ...
}: {
  imports = [
    "${self}/modules/common/nix"
    "${self}/modules/homeManager/nvim.nix"
    "${self}/modules/homeManager/gpg.nix"
    "${self}/modules/homeManager/qt.nix"
    "${self}/modules/homeManager/syncthing.nix"
  ];
  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      username = "joshuachp";
      homeDirectory = "/home/joshuachp";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Options
    systemConfig.desktop.enable = lib.mkForce true;

    nixpkgs.overlays = [
      nixgl.overlay

      (self: super:
        let
          inherit (config.lib.config) wrapGLIntel;
        in
        {
          alacritty = wrapGLIntel "alacritty" "${super.alacritty}/bin/alacritty";
          vscode = wrapGLIntel "code" "${super.vscode}/bin/code";
          libreoffice = wrapGLIntel "libreoffice" "${super.libreoffice}/bin/libreoffice";
          tdesktop = wrapGLIntel "telegram-desktop" "${super.tdesktop}/bin/telegram-desktop";
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
    ++ import "${self}/pkgs/cli.nix" pkgs
    ++ import "${self}/pkgs/cli-minimal.nix" pkgs
    ++ import "${self}/pkgs/nixpkgs.nix" pkgs
    # Develop
    ++ import "${self}/pkgs/develop" { inherit pkgs; }
    ++ import "${self}/pkgs/develop/nix.nix" {
      inherit pkgs; nil = nil.packages.${system}.default;
    }
    ++ import "${self}/pkgs/develop/rust.nix" {
      inherit pkgs;
      toolchain = pkgs.rust-bin.stable.latest.default;
    }
    ++ import "${self}/pkgs/develop/javascript.nix" { inherit pkgs; }
    ++ import "${self}/pkgs/develop/python.nix" { inherit pkgs; }
    ++ import "${self}/pkgs/develop/haskell.nix" { inherit pkgs; }
    ++ import "${self}/pkgs/develop/c_cpp.nix" { inherit pkgs; }
    ++ import "${self}/pkgs/develop/shell.nix" pkgs
    ++ import "${self}/pkgs/develop/elixir.nix" pkgs
    ++ import "${self}/pkgs/desktop.nix" { inherit pkgs lib config; }
    ;
  };
}
