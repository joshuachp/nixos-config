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
      nixosHardware.common-cpu-amd-pstate
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
  # Cloud 2
  nixos-cloud-2 = mkSystem "nixos-cloud-2" {
    system = "aarch64-linux";
    modules = [
      flakeInputs.privateConf.nixosModules.nixosCloud2
      flakeInputs.disko.nixosModules.disko
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
