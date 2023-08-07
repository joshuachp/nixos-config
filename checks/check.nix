# Flake check
{ stdenvNoCC
, nixpkgs-fmt
, statix
, shfmt
, shellcheck
}: stdenvNoCC.mkDerivation {
  name = "check";
  src = ./..;
  nativeBuildInputs = [
    nixpkgs-fmt
    statix
    shfmt
    shellcheck
  ];
  buildPhase = ''
    bash ./scripts/check.sh
  '';
}
