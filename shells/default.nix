# Default devShell
{
  mkShell,
  pre-commit,
  statix,
  nixfmt-rfc-style,
  shellcheck,
  shfmt,
  nodePackages,
  dprint,
  typos,
  committed,
}:
mkShell {
  packages = [
    pre-commit

    typos
    committed

    nixfmt-rfc-style
    statix

    shellcheck
    shfmt

    nodePackages.prettier
    dprint
  ];
}
