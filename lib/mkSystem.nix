# Function to configure a nixosSystem
inputs:
baseSystem:
name:
{ system ? baseSystem
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
    # Overlays
    ../overlays
    {
      nixpkgs.overlays = overlays;
    }

    # Options
    ../options

    # Secrets
    inputs.privateConf.nixosModules.nixos

    # Home manager
    inputs.home-manager.nixosModules.home-manager
    # Default modules
    ../modules/nixos
    ../users
    ../systems/${name}
  ] ++ modules;
}
