# Function to configure a nixosSystem
name: { inputs
      , system
      , overlays ? [ ]
      , modules ? [ ]
      }:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = inputs // {
    inherit system;
    hostname = name;
  };

  modules = [
    {
      nixpkgs.overlays = overlays;
    }

    ../modules
    ../users
    ../systems/${name}
  ] ++ modules;
}
