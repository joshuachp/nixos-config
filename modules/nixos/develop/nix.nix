{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/nix.nix { inherit pkgs; };
  };
}
