# Function to configure a nixosSystem
{
  # Inputs from the flake
  flakeInputs,
  # Default system (x86_64-linux)
  baseSystem,
}:
# Name for the current system
name:
# Other option to pass to nixosSystem function
{
  system ? baseSystem,
  overlays ? [ ],
  modules ? [ ],
  nixpkgs ? flakeInputs.nixpkgs,
}:

let
  specialArgs = {
    inherit system flakeInputs;
    inherit (flakeInputs) self;
    hostname = name;
  };
in
nixpkgs.lib.nixosSystem {
  inherit system specialArgs;

  modules = modules ++ [
    # Lib
    ./modules/common
    ./modules/nixos

    # Overlays
    ../overlays

    # Options
    ../options

    # Secrets
    flakeInputs.privateConf.nixosModules.nixos
    # Home manager
    flakeInputs.home-manager.nixosModules.home-manager

    # Default modules
    ../modules/common
    ../modules/nixos/base
    ../users

    # Config
    ../nixos/${name}

    {
      nixpkgs.overlays = overlays;
      home-manager.extraSpecialArgs = specialArgs;
    }
  ];
}
