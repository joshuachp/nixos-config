{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (
      self: super: {
        sumneko-lua-language-server = super.sumneko-lua-language-server.overrideAttrs (old: let
          version = "3.2.2";
        in {
          inherit version;
          src = super.fetchFromGitHub {
            owner = "sumneko";
            repo = "lua-language-server";
            rev = version;
            sha256 = "sha256-wjn0yYHKNdm8kaNCrx5vif2U1N9+P9+rmwDGuNpBpLY=";
            fetchSubmodules = true;
          };
        });
      }
    )
  ];

  environment.systemPackages = with pkgs; [
    luaformatter
    sumneko-lua-language-server
  ];
}
