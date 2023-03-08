{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    stylua
    sumneko-lua-language-server
  ]);
}
