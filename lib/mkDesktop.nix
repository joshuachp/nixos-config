# Function to configure a Desktop
{
  # Inputs from the flake
  flakeInputs,
  mkSystem,
}:
# Name for the current system
name:
# Other option to pass to nixosSystem function
{
  modules ? [ ],
  ...
}@args:
mkSystem name (
  args
  // {
    modules = modules ++ [
      # Pre-generated nix index database
      flakeInputs.nix-index-database.nixosModules.nix-index
      # Neovim configuration
      flakeInputs.neovimConfig.nixosModules.default

      # Modules
      ../modules/nixos/desktop

      # Default desktop options
      {
        systemConfig.desktop.enable = true;
      }
    ];
  }
)
