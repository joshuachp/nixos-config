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
    ../modules/nixos.nix
    ../users
    ../systems/${name}
  ] ++ modules;
}
