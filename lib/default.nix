# System independent libraries functions
flakeInputs:
let
  baseSystem = flakeInputs.flake-utils.lib.system.x86_64-linux;
in
{
  mkSystem = import ./mkSystem.nix flakeInputs baseSystem;
  mkHome = import ./mkHome.nix flakeInputs baseSystem;
}
