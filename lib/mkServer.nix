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
      flakeInputs.disko.nixosModules.disko

      # Modules
      ../modules/nixos/server

      # Default server options
      {
        systemConfig = {
          desktop.enable = false;
          minimal = true;
        };
      }
    ];
  }
)
