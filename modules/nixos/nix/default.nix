# Nix configuration
{ pkgs
, nixpkgs
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
    # Nix flake registry
    nix.registry.nixpkgs.flake = nixpkgs;
    # Disable nix channels, but keep the system compatible
    nix.channel.enable = false;
    nix.settings.nix-path = "nixpkgs=${nixpkgs}";
  };
}
