{ config
, pkgs
, nil
, system
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/nix.nix {
      inherit pkgs;
      nil = nil.packages.${system}.default;
    };
  };
}
