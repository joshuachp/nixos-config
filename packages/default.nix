pkgs: {
  astartectl = pkgs.callPackage ./astartectl.nix { };
  committed = pkgs.callPackage ./committed.nix { };
  customLocale = pkgs.callPackage ./customLocale.nix { };
  jj-p = pkgs.callPackage ./jj-p { };
}
