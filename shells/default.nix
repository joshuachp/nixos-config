# Default devShell
{ mkShell
, deploy
, pre-commit
, nixpkgs-fmt
, statix
}: mkShell {
  packages = [
    deploy
    pre-commit
    nixpkgs-fmt
    statix
  ];
}
