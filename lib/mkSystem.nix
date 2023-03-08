# Function to configure a nixosSystem
name: { inputs
      , system
      , overlays ? [ ]
      , modules ? [ ]
      , nixpkgs ? inputs.nixpkgs
      }:
nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = inputs // {
    inherit system;
    hostname = name;
    installPkgs = import ./installPkg.nix { };
  };

  modules = [
    {
      nixpkgs.overlays = overlays;
    }

    # Options
    ../options

    # Secrets
    inputs.privateConf.nixosModules.secrets

    # Default modules
    ../modules
    ../users
    ../systems/${name}
  ] ++ modules;
}
