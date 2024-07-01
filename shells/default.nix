# Default devShell
{
  mkShell,
  nixos-anywhere,
  pre-commit,
  statix,
  nixfmt-rfc-style,
}:
mkShell {
  packages = [
    nixos-anywhere
    pre-commit
    nixfmt-rfc-style
    statix
  ];
}
