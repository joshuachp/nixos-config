{ config
, pkgs
, lib
, fenix
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/rust.nix { inherit pkgs; };
  };
}
