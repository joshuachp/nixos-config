{ config
, pkgs
, ...
}: {
  imports = [ ./cachix.nix ];
  config = {
    # Allow unfree packages: nvidia drivers, ...
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = import ../../pkgs/nixpkgs.nix { inherit pkgs; };

    # Enable flakes system wide, this will no loner be necessary in some future release
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.settings.auto-optimise-store = true;

    # nix options for derivations to persist garbage collection
    nix.settings = {
      keep-outputs = true;
      keep-derivations = true;
    };
    environment.pathsToLink = [
      "/share/nix-direnv"
    ];
    # Support flakes in nix direnv
    nixpkgs.overlays = [
      (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; })
    ];

    # Periodically optimise the store
    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
    };
  };
}
