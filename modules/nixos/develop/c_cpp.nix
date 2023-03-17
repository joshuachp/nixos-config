{ pkgs
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/c_cpp.nix { inherit pkgs; };
  };
}
