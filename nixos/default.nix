flakeInputs:
let
  neovimConfig = flakeInputs.neovim-config.nixosModules.default;
  nixosHardware = flakeInputs.nixos-hardware.nixosModules;
  inherit (flakeInputs.self.lib) mkSystem;
in
{
  # Nixos
  nixos = mkSystem "nixos" {
    modules = [
      neovimConfig
      # Hardware configuration
      nixosHardware.common-cpu-amd
      nixosHardware.common-gpu-amd
      nixosHardware.common-gpu-nvidia-nonprime
      nixosHardware.common-pc-laptop
      nixosHardware.common-pc-laptop-hdd
      nixosHardware.common-pc-laptop-acpi_call
    ];
  };
  # Work
  burkstaller = mkSystem "burkstaller" {
    modules = [
      neovimConfig
      # Hardware configuration
      nixosHardware.common-cpu-intel
      nixosHardware.common-pc
      nixosHardware.common-pc-ssd
    ];
  };
  # Cloud
  nixos-cloud = mkSystem "nixos-cloud" {
    modules = [
      flakeInputs.privateConf.nixosModules.nixosCloud
    ];
  };
  # Wsl
  nixos-wsl = mkSystem "nixos-wsl" {
    modules = [
      neovimConfig
      # Wsl configuration
      flakeInputs.nixos-wsl.nixosModules.wsl
    ];
  };
}
