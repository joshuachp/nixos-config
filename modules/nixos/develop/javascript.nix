{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/javascript.nix { inherit pkgs; };
  };
}
