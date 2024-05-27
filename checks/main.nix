# Flake check
{
  stdenvNoCC,
  nixfmt-rfc-style,
  statix,
  shfmt,
  shellcheck,
}:
stdenvNoCC.mkDerivation {
  name = "main-check";
  src = ./..;
  nativeBuildInputs = [
    nixfmt-rfc-style
    statix
    shfmt
    shellcheck
  ];
  buildPhase = ''
    bash ./scripts/check.sh
  '';
}
