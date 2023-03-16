{ pkgs
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/python.nix { inherit pkgs; };
  };
}
