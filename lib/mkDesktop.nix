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
    # Pre-generated nix index database
    flakeInputs.nix-index-database.nixosModules.nix-index
    # Neovim configuration
    flakeInputs.neovimConfig.nixosModules.default

    # Default desktop options
    {
      systemConfig.desktop.enable = true;

      home-manager = {
        sharedModules = [ flakeInputs.neovimConfig.homeManagerModules.default ];
      };
    }
  ];
in
mkSystem name {
  inherit system overlays nixpkgs;
  modules = desktopModules;
}
