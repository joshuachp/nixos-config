pkgs:
{
  astartectl = pkgs.callPackage ./astartectl.nix { };
  committed = pkgs.callPackage ./committed.nix { };
}
