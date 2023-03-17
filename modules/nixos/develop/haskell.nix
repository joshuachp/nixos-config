{ pkgs
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/haskell.nix { inherit pkgs; };
  };
}
