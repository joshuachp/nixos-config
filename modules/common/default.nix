# Common configuration between home-manager and NixOS
_: {
  imports = [
    ./desktop/qt.nix
    ./nix/default.nix
  ];
}
