# System independent libraries functions
flakeInputs:
let
  baseSystem = flakeInputs.flake-utils.lib.system.x86_64-linux;
  mkSystem = import ./mkSystem.nix { inherit flakeInputs baseSystem; };
in
{
  inherit mkSystem;
  mkDesktop = import ./mkDesktop.nix { inherit flakeInputs mkSystem; };
  mkServer = import ./mkServer.nix { inherit flakeInputs mkSystem; };
}
