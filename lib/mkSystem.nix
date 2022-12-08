name: { inputs, system, overlays }:

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
  ];
}
