{ config
, pkgs
, ...
}: {
  imports = [
    ../../common/nix
  ];
  config = {
    nix.gc = {
      automatic = true;
      dates = "weekly";
    };
    # Periodically optimise the store
    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    environment = {
      systemPackages = import ../../../pkgs/nixpkgs.nix { inherit pkgs; };
      pathsToLink = [
        "/share/nix-direnv"
      ];
    };
  };
}
