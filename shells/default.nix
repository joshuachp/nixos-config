# Default devShell
{
  mkShell,
  nixos-anywhere,
  deploy,
  pre-commit,
  nixpkgs-fmt,
  statix,
}:
mkShell {
  packages = [
    nixos-anywhere
    deploy
    pre-commit
    nixpkgs-fmt
    statix
  ];
}
