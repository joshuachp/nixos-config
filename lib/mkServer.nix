# Function to configure a Desktop
{
  # Inputs from the flake
  flakeInputs,
  # Default system (x86_64-linux)
  baseSystem,
  mkSystem,
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
  desktopModules = modules ++ [
    flakeInputs.disko.nixosModules.disko
    # Default server options
    {
      systemConfig = {
        desktop.enable = false;
        minimal = true;
      };
    }
    (
      { modulesPath, ... }:
      {
        imports = [
          (modulesPath + "/profiles/minimal.nix")
        ];
      }
    )
  ];
in
mkSystem name {
  inherit system overlays nixpkgs;
  modules = desktopModules;
}
